<div class="note-to-balloters" markdown="1">

**Proof of concept. Not for clinical use.** This IG is written by Nithin Mohan. It is **not** affiliated with, or
endorsed by, HIQA, the HSE, HL7 Ireland, HL7 Europe or the Department of Health. It follows a HIQA **draft**
national standard that is out for public consultation (September 2026) and will change.

</div>

### What this IG is

IE Medication Events (IE MPD) profiles the exchange of medication events in Ireland on FHIR R4:

| Event | Profile | Basis |
|---|---|---|
| Prescribing (ePrescription) | [MedicationRequest (ePrescription)](StructureDefinition-ie-mpd-medicationrequest-eprescription.html), grouped in an [ePrescription Bundle](StructureDefinition-ie-mpd-bundle-eprescription.html) | HIQA EP Sections 1–5; HL7 Europe MPD 1.0.0 |
| Dispensing (eDispensation) | [MedicationDispense (eDispensation)](StructureDefinition-ie-mpd-medicationdispense-edispensation.html) | HIQA EP Section 6; HL7 Europe MPD 1.0.0 |
| Administration | [MedicationAdministration](StructureDefinition-ie-mpd-medicationadministration.html) | IE MPD design (HIQA has no administration dataset); base FHIR R4 |
| Medication statement | [MedicationStatement](StructureDefinition-ie-mpd-medicationstatement.html) | HIQA Patient Summary 6.3 (Medication summary); HL7 Europe Base 2.0.0 |
{:.grid}

The medicine itself is a [Medication (ePrescription)](StructureDefinition-ie-mpd-medication-eprescription.html),
coded with the NMPC (SNOMED CT Irish Edition). The people and organisations are
[Patient (ePrescription)](StructureDefinition-ie-mpd-patient-eprescription.html),
[Practitioner](StructureDefinition-ie-mpd-practitioner.html),
[PractitionerRole](StructureDefinition-ie-mpd-practitionerrole.html),
[Organization](StructureDefinition-ie-mpd-organization.html) and [Location](StructureDefinition-ie-mpd-location.html).

### Where to start

- [HIQA Alignment](hiqa-alignment.html): how the HIQA ePrescription and eDispensation standard maps to this IG.
- [HIQA Traceability](hiqa-traceability.html): every HIQA data element, and where it is represented.
- [Electronic Prescription Group](electronic-prescription-group.html): the prescription as a whole (HIQA EP Section 3), compared with NHS England EPS.
- [Dosage](dosage.html): how to express dosage instructions, with worked examples (HIQA EP Section 5).
- [Administration and Statements](administration-and-statements.html): the two event types beyond HIQA EP.
- [Data Minimisation](data-minimisation.html): what an ePrescription must not carry.
- [Terminology](terminology.html): NMPC and SNOMED CT Irish Edition codes, and how they were checked.
- [Open Issues](open-issues.html): what the draft does not settle.
- [Artifacts](artifacts.html): every profile, extension, ValueSet and example.

### Relationship to IE Core

This IG started as a copy of the ePrescription and eDispensation profiles in
[IE Core](https://hl7-ie.github.io/ie-core/) (0.2.0, "Nostalgic IE"). It owns its own canonical
(`https://hl7-ie.github.io/medication-events/fhir`) and does not depend on the IE Core package. Identifier system
URIs (IHI, PPSN, IMC, PSI, ...) stay in IE Core's namespace, so the same identifier carries the same `system` in
both IGs. See ADR-001 in the [source repository](https://github.com/hl7-ie/medication-events/tree/main/docs/adr).

### Package

| Item | Value |
|---|---|
| Package id | `nostalgic-ie.fhir.medication-events` |
| Release name | Nostalgic IE (draft) |
| Version | {{site.data.fhir.version}} |
| FHIR version | 4.0.1 |
| Canonical | `https://hl7-ie.github.io/medication-events/fhir` |
{:.grid}

All people, organisations and identifiers in the examples are fictional.
