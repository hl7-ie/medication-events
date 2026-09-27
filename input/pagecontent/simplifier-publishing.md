<div class="note-to-balloters" markdown="1">

**Not yet published.** This page describes how to publish this IG on [Simplifier.net](https://simplifier.net). The
IG's author does the Simplifier steps: creating the project, uploading content and releasing a package. A released
package version can never be deleted, only unlisted.

</div>

### What gets published

| Item | Value |
|---|---|
| Package id | `nostalgic-ie.fhir.medication-events` (the FHIR package specification reserves `hl7.*` for HL7; ADR-001) |
| Release name | Nostalgic IE (draft) |
| Version | from `sushi-config.yaml` (currently `0.1.0`, draft) |
| FHIR version | 4.0.1 |
| Canonical | `https://hl7-ie.github.io/medication-events/fhir` |
| Content | conformance resources (profiles, extensions, the HIQA logical model, ValueSets, CodeSystems, NamingSystems) and every example |
| Dependencies | listed in the bundle's `package.json`, taken from `sushi-config.yaml` (HL7 Europe Base, MPD and Extensions R4; IHE MPD; FHIR Extensions R4) |
{:.grid}

The IG Publisher site stays on GitHub Pages. Simplifier hosts the package.

### The bundle

SUSHI output is not committed, so publishing starts from the **Simplifier bundle**, built from a fresh SUSHI run:

```
sushi .
python scripts/simplifier/build_bundle.py      # -> build/simplifier-upload.zip
```

CI builds it on every pull request and on `main` (the `simplifier-bundle` artifact). The script fails if the package
id starts with `hl7.`, if a dependency is missing from `package.json`, if two resources share an id, or if a
conformance resource sits outside the canonical.

### Upload

1. In a **public** Simplifier project, upload the files from `resources/conformance/` and `resources/examples/`.
2. In the project's **Dependencies**, add every package in the bundle's `package.json`, at the same versions.
3. Run Simplifier's quality control and fix anything it reports.
4. **Releases → Create → Create new package**: name `nostalgic-ie.fhir.medication-events`, version as in
   `sushi-config.yaml`, marked **prerelease**. The release notes say it is a proof of concept, not endorsed by HIQA,
   the HSE, HL7 Ireland or HL7 Europe, and not for clinical use.

Simplifier lists a project under a country, and returns its package in search, only after a package is released.

Sources: [FHIR package naming](https://hl7.org/fhir/packages.html) ·
[Simplifier packages](https://github.com/FirelyTeam/firely-docs-simplifier/blob/main/package_releases/simplifierPackages.rst)
