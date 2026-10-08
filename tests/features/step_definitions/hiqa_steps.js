// Steps for the HIQA 2026 feature files (hiqa-eprescription, hiqa-patient-summary, data-minimisation).
const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('chai');
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const { checkInvariant, loadExample, RESOURCES } = require('../support/invariants');

const IE = 'https://hl7-ie.github.io/medication-events/fhir';
const IG_ROOT = path.resolve(__dirname, '..', '..', '..');

const entriesOf = (bundle, type) => (bundle.entry || []).map(e => e.resource).filter(r => r.resourceType === type);
const first = (bundle, type) => entriesOf(bundle, type)[0];
const extUrl = name => `${IE}/StructureDefinition/${name}`;

// Named changes that each break exactly one HIQA rule. Applied to a deep copy of the loaded example.
const MUTATIONS = {
  // ── Electronic prescription group (ADR-003) ──
  'remove the prescription group status reason': r => {
    const g = r.resourceType === 'RequestGroup' ? r : entriesOf(r, 'RequestGroup')[0];
    g.extension = (g.extension || []).filter(x => !x.url.endsWith('/ie-mpd-prescription-group-status-reason'));
  },
  'drop the second item from the prescription group': r => {
    entriesOf(r, 'RequestGroup')[0].action.splice(1);
  },
  'give the first item another prescription identifier': r => {
    entriesOf(r, 'MedicationRequest')[0].groupIdentifier.value = '9-RX-2026-999999';
  },
  'change the first item date of issue': r => {
    entriesOf(r, 'MedicationRequest')[0].authoredOn = '2026-09-22T09:45:00+01:00';
  },
  'reactivate the cancelled item': r => {
    entriesOf(r, 'MedicationRequest')[0].status = 'active';
  },
  'remove the facility postcode': r => {
    for (const o of entriesOf(r, 'Organization')) for (const a of o.address || []) delete a.postalCode;
  },
  'point the dispensation at a prescription outside the ePG': r => {
    entriesOf(r, 'MedicationDispense')[0].authorizingPrescription = [{ reference: 'MedicationRequest/not-in-this-epg' }];
  },
  'make the dispensation for another patient': r => {
    entriesOf(r, 'MedicationDispense')[0].subject = { reference: 'Patient/hiqa-patient-niamh-keane' };
  },
  'point the provenance at a resource outside the ePG': r => {
    entriesOf(r, 'Provenance')[0].target = [{ reference: 'MedicationDispense/not-in-this-epg' }];
  },
  // ── Dosage (ADR-004) ──
  'remove the period from every dosage': r => {
    for (const d of r.dosage) if (d.timing && d.timing.repeat) delete d.timing.repeat.period;
  },
  'remove the maximum dose': r => {
    for (const d of r.dosage) delete d.maxDosePerPeriod;
  },
  'remove the text of every dosage': r => {
    for (const d of r.dosage) delete d.text;
  },
  'remove the high end of the dose range': r => {
    delete r.dosage[0].doseAndRate[0].doseRange.high;
  },
  'remove the age at prescribing from every item': r => {
    for (const mr of entriesOf(r, 'MedicationRequest')) {
      mr.extension = (mr.extension || []).filter(x => x.url !== extUrl('ie-mpd-patient-age-at-prescribing'));
    }
  },
  'remove the allergy statement reference from every item': r => {
    for (const mr of entriesOf(r, 'MedicationRequest')) {
      mr.supportingInformation = (mr.supportingInformation || []).filter(s => !s.reference.startsWith('List/'));
      if (!mr.supportingInformation.length) delete mr.supportingInformation;
    }
  },
  'give the second item a different group identifier': r => {
    entriesOf(r, 'MedicationRequest')[1].groupIdentifier.value = 'DIFFERENT-GROUP';
  },
  'remove every telephone number': r => {
    for (const x of r.entry.map(e => e.resource)) {
      if (x.telecom) x.telecom = x.telecom.filter(t => t.system !== 'phone');
    }
  },
  'remove every email address': r => {
    for (const x of r.entry.map(e => e.resource)) {
      if (x.telecom) x.telecom = x.telecom.filter(t => t.system !== 'email');
    }
  },
  'make the signature cover only the first item': r => {
    first(r, 'Provenance').target = first(r, 'Provenance').target.slice(0, 1);
  },
  'remove the quantity in words and figures': r => {
    r.extension = (r.extension || []).filter(x => x.url !== extUrl('ie-mpd-quantity-in-words-and-figures'));
  },
  'remove the number of instalments': r => {
    r.dispenseRequest.extension = (r.dispenseRequest.extension || [])
      .filter(x => x.url !== extUrl('ie-mpd-number-of-instalments'));
  },
  'extend the validity period to 30 days': r => {
    r.dispenseRequest.validityPeriod.end = '2026-10-15';
  },
  'extend the validity period to three months': r => {
    r.dispenseRequest.validityPeriod.end = '2026-12-15';
  },
  'remove the dispense interval': r => {
    delete r.dispenseRequest.dispenseInterval;
  },
  'give the patient a year-only date of birth': r => {
    entriesOf(r, 'Patient')[0].birthDate = entriesOf(r, 'Patient')[0].birthDate.slice(0, 4);
  },
  'point the allergy statement at another patient': r => {
    entriesOf(r, 'List')[0].subject = { reference: 'Patient/someone-else' };
  },
  'change the allergy statement code': r => {
    entriesOf(r, 'List')[0].code = { coding: [{ system: 'http://loinc.org', code: '10160-0' }] };
  },
  'drop the listed allergy from the Bundle': r => {
    r.entry = r.entry.filter(e => e.resource.resourceType !== 'AllergyIntolerance');
  },
  'remove the prescriber telephone numbers but keep the patient phone': r => {
    for (const x of r.entry.map(e => e.resource)) {
      if (['Practitioner', 'PractitionerRole', 'Organization'].includes(x.resourceType) && x.telecom) {
        x.telecom = x.telecom.filter(t => t.system !== 'phone');
      }
    }
  },
  'mark it entered in error without a clinical status': r => {
    r.verificationStatus = { coding: [{ system: 'http://terminology.hl7.org/CodeSystem/allergyintolerance-verification', code: 'entered-in-error' }] };
    delete r.clinicalStatus;
  },
  'remove the clinical status': r => {
    delete r.clinicalStatus;
  },
  'remove the reason for not allowing substitution': r => {
    delete r.substitution.reason;
  },
  'remove the administration status reason': r => {
    delete r.statusReason;
  },
  'remove the dose and the dosage text': r => {
    delete r.dosage.dose;
    delete r.dosage.text;
  },
  'record the dose as completed': r => {
    r.status = 'completed';
  },
  'remove the dispense status reason': r => {
    delete r.statusReasonCodeableConcept;
  },
  'remove the hand-over time': r => {
    delete r.whenHandedOver;
  },
  'set the status to on-hold without a reason': r => {
    r.status = 'on-hold';
    delete r.statusReason;
  },
  'remove the dosage text': r => {
    delete r.dosageInstruction[0].text;
  },
  'remove the empty reason': r => {
    delete r.emptyReason;
  },
  'remove the allergies section empty reason': r => {
    const s = r.section.find(x => x.code.coding.some(c => c.code === '48765-2'));
    delete s.emptyReason;
  },
  'remove the attestation time': r => {
    delete r.attester[0].time;
  }
};

Given('the HIQA example {string}', function (filename) {
  this.resource = loadExample(filename);
});

When('I {string}', function (change) {
  const fn = MUTATIONS[change];
  if (!fn) throw new Error(`Unknown change "${change}". Known: ${Object.keys(MUTATIONS).join('; ')}`);
  this.resource = JSON.parse(JSON.stringify(this.resource));
  fn(this.resource);
});

Then('invariant {string} should pass', async function (key) {
  const res = await checkInvariant(this.resource, key);
  expect(res.passed, `${key} (${res.invariant.expression}) failed on ${this.resource.resourceType}/${this.resource.id}`).to.be.true;
});

Then('invariant {string} should fail', async function (key) {
  const res = await checkInvariant(this.resource, key);
  expect(res.passed, `${key} should have failed on the changed ${this.resource.resourceType}/${this.resource.id}`).to.be.false;
});

Then('the entry for the {word} should pass invariant {string}', async function (type, key) {
  const r = first(this.resource, type);
  expect(r, `no ${type} entry`).to.exist;
  const res = await checkInvariant(r, key);
  expect(res.passed, `${key} failed on ${type}/${r.id}`).to.be.true;
});

Then('the Bundle should claim profile {string}', function (id) {
  expect(this.resource.meta.profile).to.include(`${IE}/StructureDefinition/${id}`);
});

Then('every prescription item should record the age {int} {string}', function (value, ucum) {
  for (const mr of entriesOf(this.resource, 'MedicationRequest')) {
    const age = (mr.extension || []).find(x => x.url === extUrl('ie-mpd-patient-age-at-prescribing'));
    expect(age, `no age on ${mr.id}`).to.exist;
    expect(age.valueAge.value).to.equal(value);
    expect(age.valueAge.code).to.equal(ucum);
    expect(age.valueAge.system).to.equal('http://unitsofmeasure.org');
  }
});

Then('the medication should be classified {string} in {string}', function (code, csId) {
  const med = this.resource.resourceType === 'Bundle' ? first(this.resource, 'Medication') : this.resource;
  const codings = (med.extension || [])
    .filter(x => x.url.endsWith('ihe-ext-medication-classification'))
    .flatMap(x => x.valueCodeableConcept.coding);
  expect(codings.some(c => c.code === code && c.system === `${IE}/CodeSystem/${csId}`)).to.be.true;
});

// Repeats dispensed are DERIVED from the dispense records (ADR-003), never stored on the request.
Then('the dispenses of {string} should total {int} {string} with {int} repeat(s) used of {int} allowed',
  function (rxId, total, unit, repeatsUsed, allowed) {
    const rx = loadExample(`MedicationRequest-${rxId}.json`);
    const dispenses = fs.readdirSync(RESOURCES).filter(f => f.startsWith('MedicationDispense-'))
      .map(f => loadExample(f))
      .filter(d => (d.authorizingPrescription || []).some(a => a.reference === `MedicationRequest/${rxId}`));
    const completed = dispenses.filter(d => d.status === 'completed');
    expect(completed.reduce((n, d) => n + d.quantity.value, 0)).to.equal(total);
    expect(completed.every(d => d.quantity.code === unit)).to.be.true;
    const refills = completed.filter(d => d.type && d.type.coding.some(c => ['RF', 'RFC', 'RFP'].includes(c.code)));
    expect(refills.length).to.equal(repeatsUsed);
    expect(rx.dispenseRequest.numberOfRepeatsAllowed).to.equal(allowed);
    expect(repeatsUsed).to.be.at.most(allowed);
  });

Then('the dispense should be a non-dispensation with status {string} and quantity {int}', function (status, qty) {
  expect(this.resource.status).to.equal(status);
  expect(this.resource.quantity.value).to.equal(qty);
  expect(this.resource.whenHandedOver).to.be.undefined;
  expect(this.resource.statusReasonCodeableConcept.text).to.match(/\S/);
});

// ── Patient Summary ─────────────────────────────────────────────────
function composition(bundle) {
  const c = first(bundle, 'Composition');
  expect(bundle.entry[0].resource.resourceType, 'the first entry must be the Composition').to.equal('Composition');
  return c;
}
const sectionByLoinc = (comp, loinc) => comp.section.find(s => s.code.coding.some(c => c.code === loinc));

Then('the Composition should pass invariant {string}', async function (key) {
  const res = await checkInvariant(composition(this.resource), key);
  expect(res.passed, `${key} failed`).to.be.true;
});

Then('section {string} should have {int} entr(y)(ies)', function (loinc, n) {
  const s = sectionByLoinc(composition(this.resource), loinc);
  expect(s, `section ${loinc} missing`).to.exist;
  expect((s.entry || []).length).to.equal(n);
});

Then('section {string} should have empty reason {string}', function (loinc, code) {
  const s = sectionByLoinc(composition(this.resource), loinc);
  expect(s, `section ${loinc} missing`).to.exist;
  expect(s.entry, 'an empty section must not have entries').to.be.undefined;
  expect(s.emptyReason.coding[0].system).to.equal('http://terminology.hl7.org/CodeSystem/list-empty-reason');
  expect(s.emptyReason.coding[0].code).to.equal(code);
});

Then('every section should have a narrative', function () {
  for (const s of composition(this.resource).section) {
    expect(s.text && s.text.div, `section ${s.title} has no narrative`).to.match(/<div/);
  }
});

Then('every section entry should resolve to an entry in the Bundle', function () {
  const refs = new Set(this.resource.entry.map(e => `${e.resource.resourceType}/${e.resource.id}`));
  for (const s of composition(this.resource).section) {
    for (const e of s.entry || []) expect(refs.has(e.reference), `${e.reference} not in Bundle`).to.be.true;
  }
});

// ── Data minimisation (ADR-002) ─────────────────────────────────────
const PROHIBITED_EP_EXTENSIONS = [
  extUrl('ie-mpd-ethnicity'),
  extUrl('ie-mpd-mothers-former-surname'),
  extUrl('ie-mpd-country-of-affiliation'),
  'http://hl7.org/fhir/StructureDefinition/patient-mothersMaidenName',
  'http://hl7.org/fhir/StructureDefinition/patient-nationality',
  'http://hl7.org/fhir/StructureDefinition/patient-citizenship',
  'http://hl7.org/fhir/StructureDefinition/patient-religion',
  'http://hl7.org/fhir/StructureDefinition/patient-birthPlace',
  'http://hl7.org/fhir/StructureDefinition/individual-pronouns'
];

function epPatients() {
  const out = [];
  for (const f of fs.readdirSync(RESOURCES)) {
    if (!f.endsWith('.json')) continue;
    const r = loadExample(f);
    const claims = p => ((p.meta && p.meta.profile) || []).includes(`${IE}/StructureDefinition/ie-mpd-patient-eprescription`);
    if (r.resourceType === 'Patient' && claims(r)) out.push({ where: f, patient: r });
    if (r.resourceType === 'Bundle' && ((r.meta && r.meta.profile) || []).some(p => p.includes('bundle-eprescription'))) {
      for (const p of entriesOf(r, 'Patient')) out.push({ where: `${f} → Patient/${p.id}`, patient: p });
    }
  }
  return out;
}

Given('every ePrescription patient in the IG examples', function () {
  this.epPatients = epPatients();
  expect(this.epPatients.length).to.be.greaterThan(5);
});

Then('none of them should carry a prohibited demographic extension', function () {
  for (const { where, patient } of this.epPatients) {
    const urls = (patient.extension || []).map(x => x.url);
    const bad = urls.filter(u => PROHIBITED_EP_EXTENSIONS.includes(u));
    expect(bad, `${where} carries ${bad.join(', ')}`).to.be.empty;
  }
});

Then('none of them should have {word}', function (element) {
  for (const { where, patient } of this.epPatients) {
    expect(patient[element], `${where} has ${element}`).to.be.undefined;
  }
});

Then('profile {string} should prohibit extension slice {string}', function (profileId, slice) {
  const sd = loadExample(`StructureDefinition-${profileId}.json`);
  const el = sd.differential.element.find(e => e.id === `Patient.extension:${slice}`);
  expect(el, `no ${slice} slice in the ${profileId} differential`).to.exist;
  expect(el.max).to.equal('0');
});

Then('profile {string} should prohibit element {string}', function (profileId, element) {
  const sd = loadExample(`StructureDefinition-${profileId}.json`);
  const el = sd.differential.element.find(e => e.id === `Patient.${element}`);
  expect(el, `no ${element} in the ${profileId} differential`).to.exist;
  expect(el.max).to.equal('0');
});

Then('example {string} should carry extension {string}', function (filename, name) {
  const r = loadExample(filename);
  expect((r.extension || []).some(x => x.url === extUrl(name) || x.url.endsWith(`/${name}`))).to.be.true;
});

// ── Scripts run as tests (guard, traceability) ──────────────────────
function python() {
  for (const cmd of ['python', 'python3', 'py']) {
    try {
      execFileSync(cmd, ['--version'], { stdio: 'ignore' });
      return cmd;
    } catch (e) { /* try the next */ }
  }
  throw new Error('Python 3 is required for this scenario');
}

When('I run the script {string}', function (script) {
  const [file, ...args] = script.split(' ');
  try {
    this.scriptOutput = execFileSync(python(), [path.join(IG_ROOT, file), ...args],
      { cwd: IG_ROOT, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
    this.scriptStatus = 0;
  } catch (e) {
    this.scriptOutput = String(e.stdout || '') + String(e.stderr || '');
    this.scriptStatus = e.status;
  }
});

Then('the script should succeed', function () {
  expect(this.scriptStatus, this.scriptOutput).to.equal(0);
});

Then('every dosage should pass invariant {string}', async function (key) {
  const res = await checkInvariant(this.resource, key, 'dosage');
  expect(res.results.length, 'no dosage').to.be.greaterThan(0);
  expect(res.passed, `${key} (${res.invariant.expression}) failed on ${this.resource.id}`).to.be.true;
});

Then('a dosage should fail invariant {string}', async function (key) {
  const res = await checkInvariant(this.resource, key, 'dosage');
  expect(res.passed, `${key} should have failed on the changed ${this.resource.id}`).to.be.false;
});

