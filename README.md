# IE Medication Events (IE MPD)

FHIR R4 implementation guide for Irish **ePrescription, eDispensation, medication administration and medication
statements**, aligned with the HIQA *Draft National Standard for Electronic Prescriptions and Electronic
Dispensations* (September 2026).

> **Proof of concept by Nithin Mohan. Not for clinical use.** Not affiliated with, or endorsed by, HIQA, the HSE,
> HL7 Ireland, HL7 Europe or the Department of Health. The HIQA standard is a consultation draft and will change.

| Item | Value |
|---|---|
| Package id | `nostalgic-ie.fhir.medication-events` |
| Release name | Nostalgic IE (draft) |
| Version | 0.1.0 |
| Canonical | `https://hl7-ie.github.io/medication-events/fhir` |
| FHIR | 4.0.1 |
| Built on | HL7 Europe MPD 1.0.0 (prescription, dispense, medication), HL7 Europe Base 2.0.0 (medication statement) |
| Site | <https://hl7-ie.github.io/medication-events/> |

The ePrescription and eDispensation profiles were copied from [IE Core](https://github.com/hl7-ie/ie-core) and
renamed `IEMpd*`; this IG has its own canonical and does not depend on the IE Core package
([ADR-001](docs/adr/ADR-001-identity-and-copy-from-ie-core.md)). Administration and statements are described in
[ADR-002](docs/adr/ADR-002-administration-and-statement-scope.md).

## Repository layout

```text
input/fsh/profiles/       IEMpd* profiles (ePrescription, eDispensation, administration, statement, actors)
input/fsh/extensions/     extensions (HIQA-specific and general)
input/fsh/terminology/    CodeSystems, ValueSets, HIQA placeholders
input/fsh/identifiers/    NamingSystems for Irish identifiers
input/fsh/logical/        HIQA EP logical model (generated)
input/fsh/examples/       HIQA scenarios 1-9, NMPC-coded medicines
input/pagecontent/        IG pages
docs/adr/                 architecture decision records
docs/hiqa-2026/           mapping, traceability matrix, open issues, NMPC verification, clinical-safety log
docs/sources/hiqa-2026/   HIQA EP data elements (source for the logical model)
scripts/                  traceability, QA, terminology and Simplifier tooling
tests/                    BDD (Cucumber) and FHIR Validator runs
```

## Build and test

Prerequisites: Node.js 20+, Java 17+, Python 3.12+.

```bash
npm install                                  # SUSHI 3.18.0
npm run build                                # SUSHI: FSH -> fsh-generated/
cd tests && npm ci && npm run test:bdd       # BDD tests (invariants, data minimisation, scenarios)
npm run download:validator                   # FHIR Validator 6.10.4
node validator/run-validation.js --tx        # validate every example (codes checked on tx.fhir.org)
```

From the repository root:

```bash
python scripts/hiqa/generate_traceability.py         # regenerate the HIQA logical model and traceability
python scripts/hiqa/check_mapping_against_snapshots.py
python scripts/qa/check_ep_data_minimisation.py
python scripts/terminology/verify_codes.py           # every SNOMED CT, LOINC, UCUM code; NMPC via the CSV
python scripts/hiqa/sync_open_issues.py              # docs/hiqa-2026/open-issues.md -> the Open Issues page
python scripts/simplifier/build_bundle.py            # build/simplifier-upload.zip
npm run publisher:download && npm run publish:local  # IG Publisher 2.3.4 (needs Jekyll)
```

## CI

- `pr-validation.yml`: every pull request. SUSHI (0 errors), BDD, traceability, mapping, data-minimisation guard,
  open issues, page links, Simplifier bundle, code verification, FHIR Validator (examples, and whole-IG QA not above
  `scripts/qa/qa-baseline.json`), IG Publisher QA.
- `build-ig.yml`: `main`. The same gates, then the IG Publisher and deployment to GitHub Pages.

Actions are pinned to commit SHAs; tools are pinned to exact versions and the jars are checked against SHA-256.

## Licence

CC0-1.0. See [GOVERNANCE.md](GOVERNANCE.md) and [CONTRIBUTING.md](CONTRIBUTING.md).
