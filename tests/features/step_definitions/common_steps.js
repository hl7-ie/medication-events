const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('chai');
const path = require('path');

Given('the SUSHI compiler has been run successfully', function () {
  expect(this.isFshGeneratedAvailable(), 'fsh-generated directory not found. Run sushi first.').to.be.true;
});

Given('the fsh-generated resources are available', function () {
  expect(this.isFshGeneratedAvailable()).to.be.true;
});

Given('I have the example resource {string}', function (filename) {
  this.resource = this.loadResource(filename);
});

Given('I have the profile {string}', function (filename) {
  this.resource = this.loadResource(filename);
});

Given('I have the resource {string}', function (filename) {
  this.resource = this.loadResource(filename);
});

Given('I have all IE Core profile StructureDefinitions', function () {
  this.profiles = this.loadAllByPrefix('StructureDefinition-ie-mpd-');
  expect(this.profiles.length).to.be.greaterThan(0);
});

Given('I have all IE Core ValueSet resources', function () {
  this.valueSets = this.loadAllByPrefix('ValueSet-');
  expect(this.valueSets.length).to.be.greaterThan(0);
});

Given('I have all IE Core CodeSystem resources', function () {
  this.codeSystems = this.loadAllByPrefix('CodeSystem-');
  expect(this.codeSystems.length).to.be.greaterThan(0);
});

Then('the resource should have resourceType {string}', function (type) {
  expect(this.resource.resourceType).to.equal(type);
});

Then('the resource should have a meta.profile containing {string}', function (profileUrl) {
  expect(this.resource.meta).to.exist;
  expect(this.resource.meta.profile).to.be.an('array');
  expect(this.resource.meta.profile.some(p => p.includes(profileUrl))).to.be.true;
});

Then('the resource should have at least {int} identifier(s)', function (count) {
  expect(this.resource.identifier).to.be.an('array');
  expect(this.resource.identifier.length).to.be.at.least(count);
});

Then('the resource should have a name with a family component', function () {
  expect(this.resource.name).to.be.an('array');
  expect(this.resource.name.length).to.be.greaterThan(0);
  const hasFamily = this.resource.name.some(n => n.family && n.family.length > 0);
  expect(hasFamily).to.be.true;
});

Then('the resource should have a gender value', function () {
  expect(this.resource.gender).to.exist;
  expect(['male', 'female', 'other', 'unknown']).to.include(this.resource.gender);
});

Then('the resource should have an active status', function () {
  expect(this.resource.active).to.exist;
});

Then('the resource should have a name value', function () {
  expect(this.resource.name).to.exist;
  expect(this.resource.name.length).to.be.greaterThan(0);
});

Then('the resource should have a status value', function () {
  expect(this.resource.status).to.exist;
});

Then('the resource should have a class value', function () {
  expect(this.resource.class).to.exist;
});

Then('the resource should have a code value', function () {
  expect(this.resource.code).to.exist;
});

Then('the resource should have a subject reference', function () {
  expect(this.resource.subject).to.exist;
  expect(this.resource.subject.reference).to.exist;
});

When('I extract identifiers with system {string}', function (system) {
  expect(this.resource.identifier).to.be.an('array');
  this.identifiers = this.resource.identifier.filter(id => id.system === system);
  expect(this.identifiers.length).to.be.greaterThan(0);
});

Then('each identifier value should match pattern {string}', function (pattern) {
  const regex = new RegExp(pattern);
  for (const id of this.identifiers) {
    expect(id.value).to.match(regex, `Identifier value "${id.value}" does not match ${pattern}`);
  }
});

Then('the profile baseDefinition should be {string}', function (expectedBase) {
  expect(this.resource.baseDefinition).to.equal(expectedBase);
});

Then('every profile URL should start with {string}', function (prefix) {
  for (const profile of this.profiles) {
    expect(profile.url).to.satisfy(
      url => url.startsWith(prefix),
      `Profile ${profile.id} URL "${profile.url}" does not start with "${prefix}"`
    );
  }
});

Then('the profile should have type {string}', function (type) {
  expect(this.resource.type).to.equal(type);
});

Then('a profile should exist with id containing {string}', function (idFragment) {
  const found = this.profiles.some(p => p.id && p.id.includes(idFragment));
  expect(found, `No profile found with id containing "${idFragment}"`).to.be.true;
});
