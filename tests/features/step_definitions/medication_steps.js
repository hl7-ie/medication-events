const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('chai');

// ──────────────────────────────────────────────────────────────────────
// Medication-specific step definitions for IE MPD medication scenarios
// ──────────────────────────────────────────────────────────────────────

Then('the resource should have an intent value of {string}', function (intent) {
  expect(this.resource.intent).to.equal(intent);
});

Then('the resource should have a status value of {string}', function (status) {
  expect(this.resource.status).to.equal(status);
});

Then('the resource should have a quantity value', function () {
  expect(this.resource.quantity).to.exist;
  expect(this.resource.quantity.value).to.be.a('number').and.greaterThan(0);
});

Then('the resource should have a quantity value of {int}', function (qty) {
  expect(this.resource.quantity).to.exist;
  expect(this.resource.quantity.value).to.equal(qty);
});

Then('the resource should have a dispenseRequest with numberOfRepeatsAllowed of {int}', function (n) {
  expect(this.resource.dispenseRequest).to.exist;
  expect(this.resource.dispenseRequest.numberOfRepeatsAllowed).to.equal(n);
});

Then('the resource should have a dispenseRequest quantity of {int}', function (qty) {
  expect(this.resource.dispenseRequest).to.exist;
  expect(this.resource.dispenseRequest.quantity).to.exist;
  expect(this.resource.dispenseRequest.quantity.value).to.equal(qty);
});

Then('the resource should have a dispense type code of {string}', function (code) {
  expect(this.resource.type).to.exist;
  const coding = this.resource.type.coding;
  expect(coding).to.be.an('array').with.length.greaterThan(0);
  const found = coding.some(c => c.code === code);
  expect(found, `Expected dispense type code "${code}" but got: ${JSON.stringify(coding)}`).to.be.true;
});

Then('the resource should have an authorizingPrescription reference', function () {
  expect(this.resource.authorizingPrescription).to.be.an('array').with.length.greaterThan(0);
  expect(this.resource.authorizingPrescription[0].reference).to.exist;
});

Then('the resource should have a groupIdentifier', function () {
  expect(this.resource.groupIdentifier).to.exist;
  expect(this.resource.groupIdentifier.value).to.exist;
});

Then('the resource should have a groupIdentifier value of {string}', function (value) {
  expect(this.resource.groupIdentifier).to.exist;
  expect(this.resource.groupIdentifier.value).to.equal(value);
});

Then('the resource should have substitution wasSubstituted {word}', function (boolStr) {
  const expected = boolStr === 'true';
  expect(this.resource.substitution).to.exist;
  expect(this.resource.substitution.wasSubstituted).to.equal(expected);
});

Then('the resource should have a validity period spanning 6 months', function () {
  expect(this.resource.dispenseRequest).to.exist;
  expect(this.resource.dispenseRequest.validityPeriod).to.exist;
  const start = new Date(this.resource.dispenseRequest.validityPeriod.start);
  const end = new Date(this.resource.dispenseRequest.validityPeriod.end);
  const monthsDiff = (end.getFullYear() - start.getFullYear()) * 12 + (end.getMonth() - start.getMonth());
  expect(monthsDiff).to.be.at.least(6);
});

Then('one identifier should use system {string}', function (system) {
  expect(this.resource.identifier).to.be.an('array');
  const found = this.resource.identifier.some(id => id.system === system);
  expect(found, `No identifier with system "${system}" found`).to.be.true;
});

Then('no identifier should use system {string}', function (system) {
  const ids = this.resource.identifier || [];
  expect(ids.some(id => id.system === system), `Unexpected identifier with system "${system}"`).to.be.false;
});

Then('at least one identifier should exist', function () {
  expect(this.identifiers).to.be.an('array').with.length.greaterThan(0);
});

// Other countries' identifiers carry no invented system; the issuing country is named in assigner (ADR-006, HZ-10).
Then('one identifier should be issued in {string}', function (country) {
  const ids = this.resource.identifier || [];
  const found = ids.some(i => i.assigner && (i.assigner.display || '').includes(country));
  expect(found, `No identifier issued in ${country}`).to.be.true;
});
