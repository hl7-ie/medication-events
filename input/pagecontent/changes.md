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
- Health Services Provider Identifier slices HSP-I (Practitioner) and HSP-O (Organization), Health Identifiers Act
  2014 s.13–14, on IE Core's identifier systems (OI-030).
- **Reference examples** (illustrative, ported from IE Core 0.2.0 when IE Core removed ePrescription, IE Core ADR-009):
  the Cross-Border ePrescription pages (overview, Seán Murphy's patient profile and scenarios, sample payloads) and the
  Irish ePrescription legislation page; 82 FSH examples (11 cross-border destinations and NePS inbound flows, local
  scenarios 1–6: full, partial, multi-item, IE→ES, ES→IE, repeat); 22 FHIR and CDA payloads; a Postman collection;
  and their BDD features (77 scenarios). Conditions and the encounter in these examples use the base FHIR resource.
  The payloads' broken `ie-core-allergy-intolerance` profile reference now points to `ie-mpd-allergyintolerance`.
- **Electronic Prescription Group (ePG)** (ADR-003): the ePrescription Bundle becomes the ePG,
  `IEMpdElectronicPrescriptionGroup` (and `IEMpdElectronicPrescriptionGroupCrossBorder`): one prescription's items
  (eP) together with their eDispensations and provenance, plus a required **Prescription Group Header**
  (`IEMpdPrescriptionGroupHeader`, RequestGroup) carrying HIQA EP 3.1 identifier (with type), 3.2 date of issue, 3.3
  prescription status with a reason (`IEMpdPrescriptionGroupStatusReason`), 3.4 presented form (`IEMpdPresentedForm`)
  and the items as actions. Rules `ie-bnd-rx-7` to `ie-bnd-rx-14` and `ie-grp-status-1` (item consistency informed by
  the NHS England EPS `prescription-order` rules; eDispensations authorised by an item in the same ePG). Scenarios 1,
  3, 4 and 5 are full ePGs; scenario 10 is a cancelled prescription. **Breaking:** profile ids
  `ie-mpd-bundle-eprescription(-crossborder)` → `ie-mpd-electronic-prescription-group(-crossborder)`; the header is
  required.
- **Dosage** (ADR-004): `IEMpdDosage` on HL7 Europe MPD `Dosage-eu-mpd` for prescription, dispense and statement
  (`ie-dos-1` to `ie-dos-4`), a Dosage guidance page structured like the UK Core medicines guidance, and seven
  validated dosage examples. Product-based doses in the examples use SNOMED CT units of presentation.
- **HIQA EP gaps closed:** 2.9 facility address (`ie-bnd-rx-11`, OI-013 resolved); 1.6 record entry author for
  allergies (`ie-allergy-2`), weight and height (performer required); 4.9 characteristics mapped to the IHE MPD
  characteristic extension. New open issues OI-104 (identifier type value set) and OI-105 (national service
  interface).

