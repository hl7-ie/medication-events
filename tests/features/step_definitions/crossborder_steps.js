const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('chai');

// ──────────────────────────────────────────────────────────────────────
// Cross-border ePrescription specific step definitions
// ──────────────────────────────────────────────────────────────────────

Then('the resource should have a criticality of {string}', function (criticality) {
  expect(this.resource, 'Resource was not loaded by a prior step').to.exist;
  expect(this.resource.criticality).to.equal(criticality);
});

Then('the resource should have a verificationStatus of {string}', function (status) {
  expect(this.resource, 'Resource was not loaded by a prior step').to.exist;
  expect(this.resource.verificationStatus).to.exist;
  const coding = this.resource.verificationStatus.coding;
  expect(coding).to.be.an('array').with.length.greaterThan(0);
  const found = coding.some(c => c.code === status);
  expect(found, `Expected verificationStatus "${status}" but got: ${JSON.stringify(coding)}`).to.be.true;
});

Then('the resource should have at least {int} reaction', function (n) {
  expect(this.resource, 'Resource was not loaded by a prior step').to.exist;
  expect(this.resource.reaction).to.be.an('array');
  expect(this.resource.reaction.length).to.be.at.least(n);
});

Then('the resource should have at least {int} coding', function (n) {
  expect(this.resource, 'Resource was not loaded by a prior step').to.exist;
  // Works for any resource with code.coding or direct coding array
  const codings = this.resource.code
    ? this.resource.code.coding
    : this.resource.coding;
  expect(codings).to.be.an('array');
  expect(codings.length).to.be.at.least(n);
});

Then('one coding should have code {string}', function (code) {
  expect(this.resource, 'Resource was not loaded by a prior step').to.exist;
  // Search in code.coding, coding, or medicationCodeableConcept.coding
  let codings = [];
  if (this.resource.code && this.resource.code.coding) {
    codings = codings.concat(this.resource.code.coding);
  }
  if (this.resource.coding) {
    codings = codings.concat(this.resource.coding);
  }
  if (this.resource.medicationCodeableConcept && this.resource.medicationCodeableConcept.coding) {
    codings = codings.concat(this.resource.medicationCodeableConcept.coding);
  }
  const found = codings.some(c => c.code === code);
  expect(found, `Expected code "${code}" in codings: ${JSON.stringify(codings)}`).to.be.true;
});
