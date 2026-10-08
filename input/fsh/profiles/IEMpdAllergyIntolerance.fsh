// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECoreAllergyIntolerance.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdAllergyIntolerance
Parent: AllergyIntolerance
Id: ie-mpd-allergyintolerance
Title: "IE MPD AllergyIntolerance"
Description: "The IE Medication Events AllergyIntolerance profile sets minimum expectations for the AllergyIntolerance resource to record, search, and fetch allergy and intolerance data associated with a patient, based on Irish requirements."

* ^url = "https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-allergyintolerance"
* ^status = #draft

* clinicalStatus 0..1 MS
* obeys ie-allergy-1 and ie-allergy-2
* verificationStatus MS
* category MS
* code 1..1 MS
* code from IEMpdAllergyIntoleranceSet (extensible)
* patient 1..1 MS
* patient only Reference(IEMpdPatient)
* onset[x] MS
* reaction MS
* reaction.manifestation MS
* reaction.severity MS

// ── HIQA EP 1.6.2 / PS Section 5 ───────────────────────────────────────
* code ^comment = "HIQA PS 5.3.2 Causative agent or allergen (Mandatory); EP 1.6.2.1 Allergies or intolerances (Required)."
* clinicalStatus ^comment = "HIQA PS 5.3.1 Allergies or intolerances status (Mandatory): required unless the record was entered in error (invariant ie-allergy-1; FHIR ait-2 forbids clinicalStatus when entered-in-error)."
* verificationStatus ^comment = "HIQA PS 5.3.5 Certainty (Optional)."
* onset[x] ^comment = "HIQA PS 5.3.3 Onset date (Required)."
* reaction.substance MS
* reaction.substance ^comment = "HIQA EP 1.6.2.2 Causative agent (Required); PS 5.3.7.1 Allergen (Mandatory within the reaction cluster)."
* reaction.description MS
* reaction.description ^comment = "HIQA PS 5.3.7.2 Description of reaction (Required)."
* reaction.severity ^comment = "HIQA PS 5.3.7.4 Severity (Required)."
* recorder MS
* recorder ^comment = "HIQA EP 1.6.2.4.2 / PS 19.2.3 Record entry author (Mandatory within the provenance cluster)."
* recordedDate MS
* recordedDate ^comment = "HIQA EP 1.6.2.4.3 / PS 19.2.4 Record entry date (Mandatory within the provenance cluster)."
* asserter ^comment = "HIQA EP 1.6.2.4.4 / PS 19.2.5 Record entry source (Optional): patient, contact person or health practitioner."
* note ^comment = "HIQA EP 1.6.2.3 Additional information / PS 5.3.6 Note (Optional)."


Invariant: ie-allergy-1
Description: "An allergy or intolerance SHALL have a clinical status unless it was entered in error (HIQA PS 5.3.1, Mandatory; FHIR ait-2 forbids clinicalStatus when entered-in-error)"
Expression: "verificationStatus.coding.where(code = 'entered-in-error').exists() or clinicalStatus.exists()"
Severity: #error

Invariant: ie-allergy-2
Description: "Record entry provenance: when the author or the date of the record entry is given, both SHALL be given (HIQA EP 1.6.2.4.2 and 1.6.2.4.3 are Mandatory within the provenance cluster)"
Expression: "(recorder.exists() or recordedDate.exists()) implies (recorder.exists() and recordedDate.exists())"
Severity: #error
