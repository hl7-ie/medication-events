### 0.1.0 "Nostalgic IE" (draft)

First release of IE Medication Events, replacing the starter scaffold.

**Breaking, compared with the scaffold:**

- Package id `hl7.fhir.ie.medication-events` → `nostalgic-ie.fhir.medication-events`; canonical
  `https://hl7.eu/fhir/ie/medication-events/fhir` → `https://hl7-ie.github.io/medication-events/fhir` (ADR-001). The
  `hl7.*` package prefix is reserved for HL7, and the `hl7.eu` domain belongs to HL7 Europe.
- The scaffold profiles `IEMedicationRequest` and `IEMedicationObservation`, the extension `IEEPrescriptionReference`,
  the medication event type terminology and the CapabilityStatement are removed. Administration was modelled as an
  Observation; it is now a MedicationAdministration.

**Added:**

- ePrescription and eDispensation profiles aligned with the HIQA draft ePrescription and eDispensation standard
  (September 2026), copied from IE Core 0.2.0 and renamed `IEMpd*` (ADR-001): MedicationRequest, MedicationDispense,
  Medication, the ePrescription Bundle and cross-border Bundle, the allergy statement, the signature Provenance, and
  the patient, practitioner, organisation and location profiles.
- MedicationAdministration (IE-defined) and MedicationStatement on HL7 Europe Base (ADR-002).
- HIQA EP logical model and traceability matrix (242 elements), data-minimisation guard, NMPC-coded examples
  (scenarios 1–9), BDD tests, FHIR Validator gate, code verification and the Simplifier bundle.
- Simplifier publishing from CI (manual, approved upload through the Project ZIP API; releases stay manual), and
  local testing with Docker, docker compose and Kubernetes manifests.
