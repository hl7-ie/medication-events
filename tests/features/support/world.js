const { setWorldConstructor } = require('@cucumber/cucumber');
const fs = require('fs');
const path = require('path');
const glob = require('glob');

const FSH_GENERATED = path.resolve(__dirname, '..', '..', '..', 'fsh-generated', 'resources');

class FHIRWorld {
  constructor() {
    this.resource = null;
    this.resources = [];
    this.identifiers = [];
    this.identifierValue = null;
    this.postalCode = null;
    this.profiles = [];
    this.valueSets = [];
    this.codeSystems = [];
  }

  loadResource(filename) {
    const filePath = path.join(FSH_GENERATED, filename);
    if (!fs.existsSync(filePath)) {
      throw new Error(`Resource file not found: ${filePath}`);
    }
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  }

  loadAllByPrefix(prefix) {
    const pattern = path.join(FSH_GENERATED, `${prefix}*.json`).replace(/\\/g, '/');
    const files = glob.sync(pattern);
    return files.map(f => JSON.parse(fs.readFileSync(f, 'utf8')));
  }

  isFshGeneratedAvailable() {
    return fs.existsSync(FSH_GENERATED);
  }
}

setWorldConstructor(FHIRWorld);
