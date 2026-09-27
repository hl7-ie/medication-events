// IE Medication Events: medication administration (ADR-002).
// The HIQA Draft National Standard for Electronic Prescriptions and Electronic Dispensations (Sept 2026) does not cover
// administration, so this profile is IE-defined: it follows the FHIR R4 MedicationAdministration resource and reuses
// the IG's patient, practitioner, medication and ePrescription profiles. No HIQA element is claimed for it.

Profile: IEMpdMedicationAdministration
Parent: MedicationAdministration
Id: ie-mpd-medicationadministration
Title: "IE MPD MedicationAdministration"
Description: "A medicine given to, or taken by, a patient under observation: a dose administered in hospital, a GP practice, a pharmacy or the community, or a dose that was due but not given. IE-defined (HIQA's EP draft does not cover administration). Not-given doses state the reason (invariant ie-mad-status-1); given doses record what was given (ie-mad-dose-1)."
* ^status = #draft

* identifier MS
* status 1..1 MS
* status ^comment = "completed = given; not-done = not given (a reason is required, ie-mad-status-1); in-progress for an infusion under way; entered-in-error to retract."
* statusReason MS
* statusReason ^comment = "Why the dose was not given (e.g. patient declined, patient absent, medicine unavailable). Coded where possible; free text in statusReason.text."
* obeys ie-mad-status-1 and ie-mad-dose-1

* medication[x] 1..1 MS
* medication[x] only CodeableConcept or Reference(IEMpdMedicationEPrescription)
* medicationCodeableConcept from IEMpdMedicationCodes (extensible)
* medication[x] ^comment = "The medicine given. NMPC code (SNOMED CT Irish Edition) where available, as a CodeableConcept or a Medication resource."

* subject 1..1 MS
* subject only Reference(IEMpdPatient)
* context MS
* context ^comment = "The encounter or episode of care during which the dose was given, where known."
* effective[x] 1..1 MS
* effective[x] ^comment = "When the dose was given: a date-time for a single dose, a period for an infusion. For a not-given dose, when it was due."

* performer MS
* performer.actor 1..1 MS
* performer.actor only Reference(IEMpdPractitioner or IEMpdPractitionerRole or IEMpdPatient or IEMpdRelatedPerson)
* performer.actor ^comment = "Who gave the dose: a practitioner, the patient (self-administration) or a carer."

* request MS
* request ^comment = "The prescription item the dose was given against, where there is one (for an ePrescription, an IEMpdMedicationRequestEPrescription)."
* reasonCode MS

* dosage MS
* dosage.text MS
* dosage.text ^comment = "Human-readable description of what was given, as recorded."
* dosage.route MS
* dosage.site MS
* dosage.dose MS
* dosage.dose ^comment = "The amount given, in UCUM units."
* dosage.rate[x] MS
* note MS

Invariant: ie-mad-status-1
Description: "A dose that was not given SHALL state why (patient safety: a missed dose must be explainable)"
Expression: "status = 'not-done' implies statusReason.exists()"
Severity: #error

Invariant: ie-mad-dose-1
Description: "A dose that was given SHALL record what was given (dose or dosage text)"
Expression: "status = 'completed' implies (dosage.dose.exists() or dosage.text.exists())"
Severity: #error
