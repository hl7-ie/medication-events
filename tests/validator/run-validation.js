// Validate the IE Core example instances with the HL7 FHIR Validator CLI and report per example.
//
// One validator run covers every selected example (starting a JVM per example took hours).
// The dependency packages are read from sushi-config.yaml, so they cannot drift from the IG.
//
// Usage:
//   node validator/run-validation.js                    all examples
//   node validator/run-validation.js --domain dispense  one domain (see DOMAIN_PATTERNS)
//   node validator/run-validation.js --only hiqa-       examples whose file name matches a regex
//   node validator/run-validation.js --tx               validate codes on tx.fhir.org (default: -tx n/a;
//                                                       codes are checked by scripts/terminology/verify_codes.py)
// Output: tests/reports/validation-results[-<domain>].json and a PASS/FAIL line per example.
// An example FAILS when the validator reports an error or fatal issue for it.
const { execFileSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const glob = require('glob');

const VALIDATOR_JAR = process.env.VALIDATOR_JAR || path.join(__dirname, 'validator_cli.jar');  // env: Docker image
const IG_ROOT = path.resolve(__dirname, '..', '..');
const FSH_GENERATED = path.join(IG_ROOT, 'fsh-generated', 'resources');
const REPORTS_DIR = path.join(__dirname, '..', 'reports');

if (!fs.existsSync(REPORTS_DIR)) fs.mkdirSync(REPORTS_DIR, { recursive: true });

if (!fs.existsSync(VALIDATOR_JAR)) {
  console.error('validator_cli.jar not found. Run: npm run download:validator');
  process.exit(1);
}

if (!fs.existsSync(FSH_GENERATED)) {
  console.error('fsh-generated not found. Run sushi first: sushi .');
  process.exit(1);
}

// Dependencies exactly as declared in sushi-config.yaml (short `id: version` or `id:\n    version: x`).
function dependencyIgs() {
  const text = fs.readFileSync(path.join(IG_ROOT, 'sushi-config.yaml'), 'utf8').replace(/\r\n/g, '\n');
  const block = text.split('\ndependencies:')[1].split('\n\n')[0];
  const deps = [];
  let current = null;
  for (const line of block.split('\n')) {
    let m = line.match(/^  ([\w.\-]+):\s*(\S+)?\s*$/);
    if (m) {
      current = m[1];
      if (m[2]) deps.push(`${current}#${m[2]}`);
      continue;
    }
    m = line.match(/^    version:\s*(\S+)/);
    if (m && current) deps.push(`${current}#${m[1]}`);
  }
  // SUSHI pseudo-package for R5 cross-version extensions: the validator resolves these natively
  return deps.filter(d => !d.startsWith('hl7.fhir.extensions.r5#'));
}

// Domain filtering: each domain maps to a regex on the JSON filename prefix (ResourceType-).
const DOMAIN_PATTERNS = {
  persons:       /^(Patient|Practitioner|PractitionerRole)-/,
  organizations: /^(Organization|Location)-/,
  clinical:      /^(Condition|AllergyIntolerance|Immunization|Observation|Encounter|Provenance)-/,
  medication:    /^Medication-/,
  prescription:  /^MedicationRequest-/,
  dispense:      /^MedicationDispense-/,
  bundles:       /^Bundle-/,
};

function argValue(name) {
  const i = process.argv.indexOf(name);
  return i !== -1 ? process.argv[i + 1] : null;
}
const domainArg = argValue('--domain');
const onlyArg = argValue('--only');
const useTx = process.argv.includes('--tx');

if (domainArg && !DOMAIN_PATTERNS[domainArg]) {
  console.error(`Unknown domain: "${domainArg}". Valid domains: ${Object.keys(DOMAIN_PATTERNS).join(', ')}`);
  process.exit(1);
}

const NON_EXAMPLE = /^(StructureDefinition|ValueSet|CodeSystem|ImplementationGuide|SearchParameter|CapabilityStatement|TestScript|NamingSystem|ConceptMap)-/;
// SUSHI-generated examples plus the hand-written payloads in input/examples (SUSHI adds those to the IG too)
const PREDEFINED = path.join(IG_ROOT, 'input', 'examples');
const sourceOf = {};
for (const f of glob.sync(path.join(FSH_GENERATED, '*.json').replace(/\\/g, '/'))) sourceOf[path.basename(f)] = f;
for (const f of glob.sync(path.join(PREDEFINED, '*.json').replace(/\\/g, '/'))) sourceOf[path.basename(f)] = f;
const examples = Object.keys(sourceOf)
  .filter(n => !NON_EXAMPLE.test(n))
  .filter(n => !domainArg || DOMAIN_PATTERNS[domainArg].test(n))
  .filter(n => !onlyArg || new RegExp(onlyArg).test(n))
  .sort();

const label = [domainArg && `domain=${domainArg}`, onlyArg && `only=${onlyArg}`].filter(Boolean).join(', ');
const reportFile = domainArg ? `validation-results-${domainArg}.json` : 'validation-results.json';

if (examples.length === 0) {
  console.log('No example resources found to validate. Skipping.');
  fs.writeFileSync(path.join(REPORTS_DIR, reportFile),
    JSON.stringify({ summary: { passed: 0, failed: 0, total: 0 }, results: [] }, null, 2));
  process.exit(0);
}

console.log(`\n=== FHIR Validator${label ? ` [${label}]` : ''}: ${examples.length} example resources ===\n`);

// Copy the selection to a temp folder and validate it in ONE run; the IG's own definitions come from -ig.
const work = fs.mkdtempSync(path.join(os.tmpdir(), 'ie-mpd-validate-'));
for (const n of examples) fs.copyFileSync(sourceOf[n], path.join(work, n));
const rawOut = path.join(work, 'validator-output.json');

const args = [`-Xmx${process.env.VALIDATOR_HEAP || '6g'}`, '-Dfile.encoding=UTF-8', '-jar', VALIDATOR_JAR, work, '-version', '4.0.1',
  '-ig', FSH_GENERATED, '-output', rawOut, '-level', 'warnings'];
for (const d of dependencyIgs()) args.push('-ig', d);
if (!useTx) args.push('-tx', 'n/a');

try {
  execFileSync('java', args, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'], maxBuffer: 256 * 1024 * 1024 });
} catch (e) {
  // The validator exits non-zero when any resource has errors; the output file is still written.
  if (!fs.existsSync(rawOut)) {
    console.error('Validator did not produce output:\n' + String(e.stdout || '').slice(-2000) + String(e.stderr || '').slice(-2000));
    process.exit(2);
  }
}

const data = JSON.parse(fs.readFileSync(rawOut, 'utf8'));
const outcomes = data.resourceType === 'Bundle' ? (data.entry || []).map(e => e.resource) : [data];
const byFile = {};
for (const oo of outcomes) {
  const ext = (oo.extension || []).find(x => (x.url || '').endsWith('operationoutcome-file'));
  const name = ext ? path.basename(ext.valueString) : '?';
  const rec = byFile[name] || (byFile[name] = { errors: [], warnings: 0 });
  for (const issue of oo.issue || []) {
    const text = (issue.details && issue.details.text) || issue.diagnostics || '';
    const loc = (issue.expression || issue.location || [''])[0];
    if (issue.severity === 'error' || issue.severity === 'fatal') rec.errors.push(`${loc}: ${text}`);
    else if (issue.severity === 'warning') rec.warnings += 1;
  }
}

const results = examples.map(n => {
  // An example with no validator outcome was not validated: that is a failure, not a pass (review R-11).
  const rec = byFile[n] || { errors: ['(no validator outcome for this file)'], warnings: 0 };
  const status = rec.errors.length ? 'FAIL' : 'PASS';
  console.log(`  ${status}  ${n}${rec.warnings ? `  (${rec.warnings} warnings)` : ''}`);
  for (const m of rec.errors.slice(0, 5)) console.log(`        ${m.slice(0, 300)}`);
  return { file: n, status, errors: rec.errors, warnings: rec.warnings };
});
fs.rmSync(work, { recursive: true, force: true });

const passed = results.filter(r => r.status === 'PASS').length;
const failed = results.length - passed;
console.log(`\n=== Results${label ? ` [${label}]` : ''}: ${passed} passed, ${failed} failed out of ${results.length} ===\n`);
fs.writeFileSync(path.join(REPORTS_DIR, reportFile),
  JSON.stringify({ summary: { passed, failed, total: results.length, tx: useTx ? 'tx.fhir.org' : 'n/a' }, results }, null, 2));
if (failed > 0) process.exit(1);
