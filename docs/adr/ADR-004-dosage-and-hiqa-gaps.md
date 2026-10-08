# ADR-004: Dosage profile, dosage guidance, and other HIQA EP gaps

- **Status:** Accepted (project owner request, 2026-10-08)
- **Breaking:** no for valid data (stricter rules: ie-dos-1 to ie-dos-4, ie-allergy-2, weight/height performer)
- **Related:** HIQA EP Sections 1.6, 4.9 and 5; ADR-003

## Context

Dosage rules were repeated on the MedicationRequest and MedicationStatement profiles, with no guidance on how to
express common Irish prescriptions. The project owner asked for dosage guidance like the UK Core medicines
implementation guide's Dosage page, which covers, in order: sequence, text, additional instruction, patient
instruction, timing, as needed, site, route, method, dose and rate, and maximum dose, using SNOMED CT for routes,
sites, methods and instructions and UCUM or SNOMED CT units of presentation for quantities, with worked examples
(e.g. a tapering course as consecutive sequences).

HL7 Europe MPD 1.0.0 types `MedicationRequest.dosageInstruction` to `Dosage-eu-mpd`, which allows only
`asNeededBoolean`.

Remaining HIQA EP gaps and partials were also reviewed.

## Decision

1. **`IEMpdDosage`** (parent `Dosage-eu-mpd`) is used by the ePrescription item, the eDispensation and the
   medication statement. It maps HIQA EP 5.1 to 5.2.7 and adds:
   - `ie-dos-1`: structured dosage comes with text (HIQA EP 5.1);
   - `ie-dos-2`: a frequency has its period and unit (5.2.4.3.1 and 5.2.4.3.2, both Mandatory in the cluster);
   - `ie-dos-3` (warning): an as-needed dosage states a maximum dose per period;
   - `ie-dos-4`: a dose range has both ends (5.2.3.1.2).
   As-needed reasons go in text because HL7 Europe MPD allows only `asNeededBoolean`.
2. **Dosage guidance page**, structured like the UK Core guidance, mapped to HIQA EP 5.x, with seven validated
   examples: consecutive sequences (warfarin loading), concurrent dosages (insulin with meals), as needed with a
   dose range and maximum (salbutamol), time bounds with an additional instruction (amoxicillin), with food
   (metformin), linked to an event (omeprazole before breakfast) and a named weekday (weekly methotrexate). Codes:
   NMPC VMPs from the verified list; SNOMED CT routes, units of presentation and instructions checked on
   tx.fhir.org.
3. **HIQA EP 1.6 record entry author** (allergy, weight, height): the allergy's recorder and recorded date are given
   together (`ie-allergy-2`); weight and height require a performer (their record entry date is always present).
4. **HIQA EP 4.9 characteristics**: mapped to the IHE MPD characteristic extension that HL7 Europe Base already
   slices on Medication (type plus coded, quantity, dateTime, integer, decimal, ratio or string value).

Left open (no authoritative answer): address type for homelessness (1.2.6), PPSN (1.3.2), gender identity codes
(1.4.4.1), supply legal status and MDA schedule codes (4.2.2, 4.2.3), EDQM dose form and route bindings (4.5, 4.7.1,
5.2.7), exempt medication item (4.11), product description (4.6, no R4 element), and practitioner registration
enforcement (2.6, because foreign prescribers use their own registers).

## Consequences

- HIQA EP 1.6.2.4.2, 1.6.3.3.2, 1.6.4.3.2 and 4.9.2.x are Aligned; 1.6.2.4.3 and 4.9.1 are Partial with the reason
  (Mandatory within an optional cluster, enforced by an invariant or by the extension).
- Dosage rules live in one profile; the guidance page links each rule to HIQA and to an example.
