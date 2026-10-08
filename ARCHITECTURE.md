# Architecture

## Profile layering

```text
FHIR R4 4.0.1
├── HL7 Europe MPD 1.0.0 ─────────── IEMpdMedicationRequestEPrescription (ePrescription item)
│                                    IEMpdMedicationDispense ── IEMpdMedicationDispenseEDispensation
│                                    IEMpdMedicationEPrescription (Medication)
├── HL7 Europe Base 2.0.0 ────────── IEMpdMedicationStatement
│                                    IEMpdPatient ── IEMpdPatientEPrescription
│                                    IEMpdPractitioner, IEMpdPractitionerRole, IEMpdOrganization, IEMpdLocation
├── FHIR R4 vital signs ──────────── IEMpdVitalSigns ── IEMpdBodyWeight, IEMpdBodyHeight
└── FHIR R4 base ─────────────────── IEMpdMedicationAdministration (no European profile exists)
                                     IEMpdElectronicPrescriptionGroup ── IEMpdElectronicPrescriptionGroupCrossBorder
                                     IEMpdListAllergiesAtPrescribing, IEMpdAllergyIntolerance, IEMpdRelatedPerson
                                     IEMpdProvenance ── IEMpdProvenanceEPrescriptionSignature
```

## Dependencies

Declared in `sushi-config.yaml`:

| Package | Version | Why |
|---|---|---|
| `hl7.fhir.eu.mpd` | 1.0.0 | Parent of the prescription, dispense and medication profiles |
| `hl7.fhir.eu.base` | 2.0.0 | Parent of the patient and medication statement profiles |
| `hl7.fhir.eu.extensions.r4` | 1.3.0 | European extensions used by the parents |
| `ihe.pharm.mpd.r4` | 1.0.0-comment-2 | Extensions used by HL7 Europe MPD (e.g. prescribed quantity) |
| `hl7.fhir.uv.extensions.r4` | 5.1.0 | FHIR extensions |
| `hl7.fhir.extensions.r5` | 4.0.1 | SUSHI cross-version support only (not a package dependency) |

## HIQA traceability pipeline

```text
docs/sources/hiqa-2026/ep-elements.csv      HIQA EP data elements (242)
docs/hiqa-2026/mapping/ep-mapping.csv       element -> profile path, status, notes
        │  scripts/hiqa/generate_traceability.py
        ▼
input/fsh/logical/HIQAEPrescriptionLM.fsh   logical model with the mapping
docs/hiqa-2026/traceability-matrix.csv
input/pagecontent/hiqa-traceability.md
        │  scripts/hiqa/check_mapping_against_snapshots.py
        ▼
checks every claimed path, cardinality and MustSupport against the generated profile snapshots
```

CI fails if the generated files are out of date (`--check`) or a mapping over-claims.

## Canonical URLs on GitHub Pages

The canonical is `https://hl7-ie.github.io/medication-events/fhir`; the IG is deployed at the site root.
`scripts/generate-canonical-redirects.mjs` writes a redirect page at each canonical path (for example
`/fhir/StructureDefinition/ie-mpd-medicationadministration/`) to the artefact page, so the canonical URLs resolve.

## Quality gates

See the CI section of the [README](README.md). The whole-IG FHIR Validator run has a ratcheting error baseline
(`scripts/qa/qa-baseline.json`): lower it when errors are fixed, never raise it without an explanation.
