### Medicines: NMPC and the SNOMED CT Irish Edition

Medicines are coded with the **National Medicinal Product Catalogue (NMPC)**. NMPC concepts are SNOMED CT Irish
Extension concepts (namespace 1000220), published in the **SNOMED CT Irish Edition**. Use:

| Item | Value |
|---|---|
| `system` | `http://snomed.info/sct` |
| `version` (edition) | `http://snomed.info/sct/1601000220105` (the Irish Edition module; OI-004) |
| Primary code | the NMPC concept (VMP, VMPP, AMP or AMPP) |
| Secondary codes | SNOMED CT International concepts, and ATC for EU cross-border exchange |
{:.grid}

The [Medication Codes](ValueSet-ie-mpd-medication-codes.html) ValueSet includes the Irish Edition's pharmaceutical
and biologic products, plus ATC. Medication and prescription profiles bind to it as *extensible*.

### How the codes in this IG were checked

- **NMPC codes.** tx.fhir.org does not host the Irish Edition (OI-022), so every NMPC code in the examples was checked
  by hand in the [NMPC Meds Catalogue](https://nmpc.hse.ie/browser) and recorded, with its NMPC name, in
  `docs/hiqa-2026/nmpc-verification.csv`. The Irish Edition is also published in the SNOMED International browser
  (edition `MAIN/SNOMEDCT-IE`).
- **Every other code.** `scripts/terminology/verify_codes.py` looks up each SNOMED CT, LOINC and UCUM code used in the
  FSH on tx.fhir.org and fails if one is missing or inactive. Irish Extension codes (namespace 1000220) are checked
  against `nmpc-verification.csv` instead. The result is written to `docs/hiqa-2026/terminology-verification.csv`.
- **Examples.** The FHIR Validator checks every example with tx.fhir.org. It cannot expand ValueSets that filter on the
  Irish Edition, which is the one known validator error (OI-022).

### Placeholders

HIQA does not publish code systems for these concepts, and no authoritative FHIR code system was found. The IG
carries clearly named, **experimental** placeholders until one is agreed:

| Placeholder | Used for | Open issue |
|---|---|---|
| [Misuse of Drugs Schedule](CodeSystem-ie-mpd-mda-schedule.html) | Controlled-drug schedule (EP 4.2.3); drives `ie-rx-cd-1/2/3` | OI-007, OI-027 |
| [Supply Legal Status](CodeSystem-ie-mpd-supply-legal-status.html) | Supply legal status (EP 4.2.2) | OI-007 |
| [PCRS Scheme Type](CodeSystem-ie-mpd-pcrs-scheme-type.html) | Reimbursement scheme | OI-003, OI-007 |
{:.grid}

### Identifier systems

The [NamingSystems](artifacts.html) describe the Irish identifiers the IG uses (IHI, PPSN, GMS, DPS, LTI, HAA, NePS,
IMC, PSI, NMBI, Dental Council, PSI registered pharmacy, GMS panel). Their `system` URIs are IE Core's
(`https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/...`), so an identifier is written the same way in both IGs
(ADR-001). No HSE-published FHIR system URIs exist for them yet (OI-003).
