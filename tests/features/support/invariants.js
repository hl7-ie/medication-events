// Evaluate the IG's own invariants (read from the SUSHI-generated StructureDefinitions) with
// fhirpath.js, the HL7 reference JavaScript FHIRPath engine. Tests therefore exercise the rule the
// IG publishes, not a copy of it.
//
// resolve() is asynchronous in fhirpath.js and fetches from a FHIR server. The global fetch is
// stubbed with an in-memory store: the entries of the Bundle under test first (FHIR Bundle reference
// resolution), then every example in fsh-generated/resources. Nothing goes over the network.
const fs = require('fs');
const path = require('path');
const fhirpath = require('fhirpath');
const r4 = require('fhirpath/fhir-context/r4');

const RESOURCES = path.resolve(__dirname, '..', '..', '..', 'fsh-generated', 'resources');
const STORE_URL = 'http://ie-core.test/fhir';

let examplesByRef = null;
function exampleStore() {
  if (examplesByRef) return examplesByRef;
  examplesByRef = {};
  for (const f of fs.readdirSync(RESOURCES)) {
    if (!f.endsWith('.json')) continue;
    const r = JSON.parse(fs.readFileSync(path.join(RESOURCES, f), 'utf8'));
    if (r.resourceType && r.id) examplesByRef[`${r.resourceType}/${r.id}`] = r;
  }
  return examplesByRef;
}

// fhirpath.js caches resolve() results by URL, so every evaluation gets its own base URL; otherwise a check
// on a mutated copy would see the resource fetched for an earlier, unmutated evaluation.
let evaluation = 0;

function installFetch(resource, base) {
  const local = {};
  if (resource.resourceType === 'Bundle') {
    for (const e of resource.entry || []) {
      if (e.resource) local[`${e.resource.resourceType}/${e.resource.id}`] = e.resource;
    }
  }
  globalThis.fetch = async (url) => {
    const ref = String(url).slice(base.length + 1).split('?')[0];
    const found = local[ref] || exampleStore()[ref];
    return {
      ok: !!found,
      status: found ? 200 : 404,
      headers: { get: () => 'application/fhir+json' },
      json: async () => found || { resourceType: 'OperationOutcome', issue: [] }
    };
  };
}

// Find invariant `key` in the differential of any IE Core StructureDefinition: returns its expression and the
// element path it is attached to (e.g. MedicationRequest.dosageInstruction).
const invariantCache = {};
function findInvariant(key) {
  if (invariantCache[key]) return invariantCache[key];
  for (const f of fs.readdirSync(RESOURCES)) {
    if (!f.startsWith('StructureDefinition-')) continue;
    const sd = JSON.parse(fs.readFileSync(path.join(RESOURCES, f), 'utf8'));
    for (const el of (sd.differential && sd.differential.element) || []) {
      for (const c of el.constraint || []) {
        if (c.key === key) {
          invariantCache[key] = { expression: c.expression, path: el.path, profile: sd.id };
          return invariantCache[key];
        }
      }
    }
  }
  throw new Error(`Invariant ${key} not found in any generated StructureDefinition`);
}

// Evaluate invariant `key` against `resource`. When the invariant is attached below the root, it is evaluated
// for every node at that path. Returns {passed, results}.
async function checkInvariant(resource, key) {
  const inv = findInvariant(key);
  const base = `${STORE_URL}/eval-${++evaluation}`;
  installFetch(resource, base);
  const options = { async: true, fhirServerUrl: base };
  const env = { resource, rootResource: resource };
  const [type, ...rest] = inv.path.split('.');
  if (type !== resource.resourceType) {
    throw new Error(`${key} applies to ${type}, not ${resource.resourceType}`);
  }
  const bases = rest.length ? await fhirpath.evaluate(resource, rest.join('.'), env, r4, options) : [resource];
  const results = [];
  for (let i = 0; i < bases.length; i++) {
    const base = rest.length ? { base: inv.path, expression: inv.expression } : inv.expression;
    const node = rest.length ? bases[i] : resource;
    const out = await fhirpath.evaluate(node, base, env, r4, options);
    // FHIRPath: an empty result or true passes; false fails (FHIR invariant semantics).
    results.push(!(out.length === 1 && out[0] === false));
  }
  return { passed: results.every(Boolean), results, invariant: inv };
}

function loadExample(filename) {
  return JSON.parse(fs.readFileSync(path.join(RESOURCES, filename), 'utf8'));
}

module.exports = { checkInvariant, findInvariant, loadExample, RESOURCES };
