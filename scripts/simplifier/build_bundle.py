"""Build the Simplifier.net upload bundle for IE Core (ADR-008).

Simplifier imports FHIR resources as JSON/XML (plus Markdown and images) and builds a package from a project's
resources. SUSHI output is not committed (fsh-generated/ is git-ignored), so this script assembles what Simplifier
needs from a fresh `sushi .` run:

    build/simplifier/
      resources/conformance/   StructureDefinitions, ValueSets, CodeSystems, NamingSystems, SearchParameters,
                               CapabilityStatements (the package content)
      resources/examples/      every example instance (FSH examples and the input/examples payloads)
      pages/                   the IG's narrative pages (Markdown) and generated images, for a Simplifier guide
      package.json             FHIR NPM manifest: name, version, canonical, fhirVersions, dependencies
      README.md                what to do with the bundle (see docs/simplifier-publishing.md)
    build/simplifier-upload.zip

Checks (exit 1 on failure):
  * the package id does not start with `hl7.` (reserved: "HL7 manages all the packages that start with hl7.");
  * every dependency in sushi-config.yaml is in package.json (the SUSHI-only pseudo-package is left out);
  * every resource has a unique `ResourceType/id` and the conformance resources carry the IG canonical.

Run: sushi . && python scripts/simplifier/build_bundle.py
"""
import glob
import json
import os
import re
import shutil
import sys
import zipfile

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
OUT = os.path.join(ROOT, 'build', 'simplifier')
CONFORMANCE = {'StructureDefinition', 'ValueSet', 'CodeSystem', 'NamingSystem', 'SearchParameter',
               'CapabilityStatement', 'OperationDefinition', 'ConceptMap'}
PSEUDO = {'hl7.fhir.extensions.r5'}  # SUSHI cross-version helper, not a real package dependency


def sushi_config():
    """The few top-level keys and the dependency list from sushi-config.yaml (no YAML library needed)."""
    text = open(os.path.join(ROOT, 'sushi-config.yaml'), encoding='utf-8').read().replace('\r\n', '\n')
    top = dict(re.findall(r'^(id|canonical|version|fhirVersion|title|name|status|license|description):\s*(.+)$',
                          text, re.M))
    block = text.split('\ndependencies:', 1)[1].split('\n\n', 1)[0]
    deps, current = {}, None
    for line in block.splitlines():
        m = re.match(r'^  ([\w.\-]+):\s*(\S+)?\s*$', line)
        if m:
            current = m.group(1)
            if m.group(2):
                deps[current] = m.group(2)
            continue
        m = re.match(r'^    version:\s*(\S+)', line)
        if m and current:
            deps[current] = m.group(1)
    return {k: v.strip().strip('"') for k, v in top.items()}, deps


def main():
    cfg, deps = sushi_config()
    problems = []
    if cfg['id'].startswith('hl7.'):
        problems.append(f"package id {cfg['id']} starts with 'hl7.' (reserved for HL7; ADR-008)")

    gen = os.path.join(ROOT, 'fsh-generated', 'resources')
    if not os.path.isdir(gen):
        sys.exit('fsh-generated/resources not found: run `sushi .` first')
    shutil.rmtree(OUT, ignore_errors=True)
    for sub in ('resources/conformance', 'resources/examples', 'pages'):
        os.makedirs(os.path.join(OUT, sub))

    seen, counts = {}, {'conformance': 0, 'examples': 0}
    sources = sorted(glob.glob(os.path.join(gen, '*.json'))) + sorted(glob.glob(os.path.join(ROOT, 'input', 'examples', '*.json')))
    for f in sources:
        r = json.load(open(f, encoding='utf-8'))
        rt = r.get('resourceType')
        if rt == 'ImplementationGuide':
            continue  # Simplifier builds the package manifest itself; the HL7 IG resource is Publisher-specific
        key = f"{rt}/{r.get('id')}"
        if key in seen:
            problems.append(f'duplicate resource {key}: {os.path.basename(f)} and {seen[key]}')
        seen[key] = os.path.basename(f)
        kind = 'conformance' if rt in CONFORMANCE else 'examples'
        # R4 NamingSystem has no url element; every other conformance resource must sit under the canonical
        if kind == 'conformance' and rt != 'NamingSystem' and not str(r.get('url', '')).startswith(cfg['canonical']):
            problems.append(f"{key} url {r.get('url')} is outside the canonical {cfg['canonical']}")
        with open(os.path.join(OUT, 'resources', kind, f"{rt}-{r['id']}.json"), 'w', encoding='utf-8', newline='\n') as fh:
            json.dump(r, fh, ensure_ascii=False, indent=2)
            fh.write('\n')
        counts[kind] += 1

    for f in glob.glob(os.path.join(ROOT, 'input', 'pagecontent', '*.md')):
        shutil.copy(f, os.path.join(OUT, 'pages', os.path.basename(f)))
    img = os.path.join(ROOT, 'input', 'images')
    if os.path.isdir(img):
        shutil.copytree(img, os.path.join(OUT, 'pages', 'images'))

    manifest = {
        'name': cfg['id'],
        'version': cfg['version'],
        'canonical': cfg['canonical'],
        'url': cfg['canonical'],
        'title': cfg.get('title', cfg['id']),
        'description': 'IE MPD: Irish ePrescription, eDispensation, medication administration and medication statement '
                       'profiles aligned with the HIQA draft ePrescription and eDispensation standard (Sept 2026). '
                       'Proof of concept by Nithin Mohan; not affiliated with HIQA, the HSE, HL7 Ireland or the '
                       'Department of Health. Not for clinical use.',
        'fhirVersions': [cfg.get('fhirVersion', '4.0.1')],
        'type': 'IG',
        'license': cfg.get('license', 'CC-BY-4.0'),
        'author': 'Nithin Mohan',
        'jurisdiction': 'urn:iso:std:iso:3166#IE',
        'dependencies': {'hl7.fhir.r4.core': '4.0.1', **{k: v for k, v in deps.items() if k not in PSEUDO}},
    }
    missing = [k for k in deps if k not in PSEUDO and k not in manifest['dependencies']]
    if missing:
        problems.append(f'dependencies missing from package.json: {missing}')
    with open(os.path.join(OUT, 'package.json'), 'w', encoding='utf-8', newline='\n') as fh:
        json.dump(manifest, fh, indent=2)
        fh.write('\n')

    with open(os.path.join(OUT, 'README.md'), 'w', encoding='utf-8', newline='\n') as fh:
        fh.write(f"""# {manifest['title']}: Simplifier.net upload bundle

Package `{manifest['name']}` version `{manifest['version']}`, FHIR {manifest['fhirVersions'][0]}.
Built from a fresh SUSHI run by `scripts/simplifier/build_bundle.py`.

- `resources/conformance/` ({counts['conformance']} files): the package content.
- `resources/examples/` ({counts['examples']} files): example instances.
- `pages/`: the IG pages (Markdown) and images, for a Simplifier guide.
- `package.json`: the manifest; its dependencies must match the package's Dependencies tab in Simplifier.

Follow `docs/simplifier-publishing.md` in the source repository. A published package version can never be deleted
(only unlisted): publish the first version as a prerelease and check it before a final release.
""")

    zip_path = os.path.join(ROOT, 'build', 'simplifier-upload.zip')
    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as z:
        for folder, _, files in os.walk(OUT):
            for name in files:
                full = os.path.join(folder, name)
                z.write(full, os.path.relpath(full, OUT))

    print(f"{manifest['name']}#{manifest['version']}: {counts['conformance']} conformance resources, "
          f"{counts['examples']} examples, {len(manifest['dependencies'])} dependencies -> {os.path.relpath(zip_path, ROOT)}")
    for p in problems:
        print('FAIL', p)
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
