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

Prerequisites: Node.js 22+ (24 LTS recommended; Cucumber 13 needs 22, 24 or 26+), Java 17+, Python 3.12+.

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

`scripts/local/run-gates.sh test|validate|codes|publish|all` runs the same gates as CI in one command.

## Local testing with Docker

The [Dockerfile](Dockerfile) pins the same tools as CI (SUSHI 3.18.0, IG Publisher 2.3.4, FHIR Validator 6.10.4,
Jekyll 4.4.1) and checks the jars' SHA-256. Nothing else needs installing.

```bash
docker compose run --rm gates                # SUSHI, BDD, HIQA and QA gates, Simplifier bundle
docker compose run --rm gates validate       # FHIR Validator: examples (tx.fhir.org) + whole-IG QA baseline
docker compose run --rm gates codes          # verify every code on tx.fhir.org
docker compose run --rm gates publish        # IG Publisher -> output/, site/ (with canonical redirects)
docker compose up preview                    # serve site/ at http://localhost:8080
```

Image targets: `toolchain` (mount the repository), `ci` (self-contained copy), `site` (the built IG on unprivileged
nginx, port 8080): `docker build --target site -t ie-mpd-site:local .`

## Local Kubernetes

[k8s/](k8s) holds a kustomization for a local cluster (minikube, kind, Docker Desktop): a Job that runs the gates in
the `ci` image and a Deployment/Service serving the `site` image. Both run as non-root with all capabilities dropped,
in a namespace with the `restricted` Pod Security Standard.

```bash
docker build --target ci -t ie-mpd-ci:local . && docker build --target site -t ie-mpd-site:local .
minikube image load ie-mpd-ci:local && minikube image load ie-mpd-site:local
kubectl apply -k k8s/
kubectl -n ie-mpd logs -f job/ie-mpd-gates
kubectl -n ie-mpd port-forward svc/ie-mpd-site 8080:80
```

## CI

- `pr-validation.yml`: every pull request. SUSHI (0 errors), BDD, traceability, mapping, data-minimisation guard,
  open issues, page links, Simplifier bundle, code verification, FHIR Validator (examples, and whole-IG QA not above
  `scripts/qa/qa-baseline.json`), IG Publisher QA, and the Docker image and Kubernetes manifests.
- `build-ig.yml`: `main`. The same gates, then the IG Publisher and deployment to GitHub Pages.
- `simplifier-publish.yml` (manual): builds the Simplifier bundle from `main` and, in `upload` mode, puts the
  resources in a Simplifier.net project through the Project ZIP API. It needs the `simplifier` environment (with
  required reviewers) holding `SIMPLIFIER_EMAIL` and `SIMPLIFIER_PASSWORD`, and a project URL key (input or the
  `SIMPLIFIER_PROJECT` variable). It **never releases a package**: Simplifier has no API for that, and package
  versions are permanent.
- `simplifier-sync.yml` (manual): force-pushes the bundle to a `simplifier-sync` branch for Simplifier's GitHub
  integration (Team plan).

Actions are pinned to commit SHAs; tools are pinned to exact versions and the jars are checked against SHA-256.

## Licence

CC0-1.0. See [GOVERNANCE.md](GOVERNANCE.md) and [CONTRIBUTING.md](CONTRIBUTING.md).
