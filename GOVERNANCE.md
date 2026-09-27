# Governance

## Status

IE Medication Events is a **proof of concept** maintained by Nithin Mohan in the `hl7-ie` GitHub organisation. It is
not affiliated with, or endorsed by, HIQA, the HSE, HL7 Ireland, HL7 Europe, HL7 International or the Department of
Health, and it has no formal ballot or approval process. It is not for clinical use.

## Sources of requirements

In order of precedence:

1. The HIQA *Draft National Standard for Electronic Prescriptions and Electronic Dispensations* (September 2026,
   consultation draft).
2. HL7 Europe MPD 1.0.0 and HL7 Europe Base 2.0.0, which the profiles derive from.
3. Irish terminology and identifiers from authoritative sources: the NMPC and SNOMED CT Irish Edition (HSE),
   professional registers (IMC, PSI, NMBI, Dental Council).

Where these do not settle a question, the IG does not invent an answer. It uses a clearly named placeholder and
records the question in [docs/hiqa-2026/open-issues.md](docs/hiqa-2026/open-issues.md).

## Decisions

Design decisions are recorded as ADRs in [docs/adr](docs/adr). A breaking change needs an ADR and an entry on the
Changes page (`input/pagecontent/changes.md`). Clinical-safety hazards are recorded in
[docs/hiqa-2026/clinical-safety-log.md](docs/hiqa-2026/clinical-safety-log.md).

## Relationship to IE Core

This IG copied its ePrescription and eDispensation content from [IE Core](https://github.com/hl7-ie/ie-core)
(ADR-001). Changes to shared rules should be considered for both IGs. Identifier system URIs are shared and stay in
IE Core's namespace.

## Releases

- Package id `nostalgic-ie.fhir.medication-events`; semantic versioning; `0.x` releases are drafts.
- Release names follow the IE Core family: "Nostalgic IE" first, then "*Adjective* IE", alphabetically.
- Nothing is published to the FHIR package registry or Simplifier.net without the maintainer's explicit decision.
  Released package versions are permanent.
