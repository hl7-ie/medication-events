// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/extensions/Extensions.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Extension: IEMpdEthnicity
Id: ie-mpd-ethnicity
Title: "IE MPD Ethnicity"
Description: "A patient's ethnicity (repeat the extension for more than one ethnic background). GDPR Art. 9 special-category data. HIQA PS 1.4.10 (Required 0..*, coded). It is NOT part of the HIQA ePrescription/eDispensation dataset and is prohibited in IEMpdPatientEPrescription (IE Core ADR-002). HIQA: 'not used for patient identification'; collected with appropriate safeguards and consent."
Context: Patient
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from https://hl7-ie.github.io/medication-events/fhir/ValueSet/ie-mpd-ethnicity (extensible)
* valueCodeableConcept ^comment = "HIQA PS 1.4.10. HIQA names the CSO as a source for coded values; verification of the CSO classification is Requires Clarification (IE Core OI-005)."
