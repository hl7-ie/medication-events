# ADR-002: Medication administration and medication statement scope

- **Status:** Accepted (27 September 2026)
- **Breaking:** yes (the scaffold's `IEMedicationObservation` is removed)

## Context

The project owner set the scope as ePrescription and eDispensation plus administration and medication statements.
The HIQA draft ePrescription and eDispensation standard (September 2026) ends at dispensing. It has no administration
dataset. Medication statements appear in the HIQA draft Patient Summary (Section 6.3, Medication).

The scaffold modelled administration as an `Observation`, which is the wrong resource: FHIR R4 has
`MedicationAdministration` for this. HL7 Europe MPD 1.0.0 profiles MedicationRequest, MedicationDispense and
Medication, but not MedicationAdministration. HL7 Europe Base 2.0.0 has `medicationStatement-eu-core`.

## Decision

1. **MedicationAdministration** (`ie-mpd-medicationadministration`) derives from the FHIR R4 resource. It is
   IE-defined and claims no HIQA element. Two invariants make it safe to act on:
   - `ie-mad-status-1`: a dose that was not given (`not-done`) states why (`statusReason`).
   - `ie-mad-dose-1`: a dose that was given (`completed`) records what was given (a dose or dosage text).

   It reuses this IG's medication, patient, practitioner and ePrescription profiles (`request`).
2. **MedicationStatement** (`ie-mpd-medicationstatement`) is copied from IE Core and re-parented on HL7 Europe Base
   `medicationStatement-eu-core`. HIQA PS 6.3 element mappings are carried in the element comments. PS 6.3.9 Dose is
   MustSupport, not 1..1 (OI-017).
3. Administration and statements take the permissive base Patient, not the ePrescription patient: they are recorded in
   settings (for example, hospital wards) whose patient dataset HIQA has not defined. Sensitive elements carry no
   MustSupport.
4. The HIQA traceability matrix covers the EP standard only. Administration and statements are described on the
   *Administration and Statements* page and tested in `tests/features/medication-administration-statement.feature`.

## Consequences

- An administration record can point to the prescription item it fulfils, and a statement can point to the
  prescription, dispense or administration it is based on.
- When HIQA or the HSE defines an administration dataset, this profile will need a traceability mapping and may change
  (OI-101). Coded "dose not given" reasons wait for a national list (OI-103).
