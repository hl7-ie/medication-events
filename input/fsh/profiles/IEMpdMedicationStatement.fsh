// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECoreMedicationStatement.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdMedicationStatement
Parent: http://hl7.eu/fhir/base/StructureDefinition/medicationStatement-eu-core
Id: ie-mpd-medicationstatement
Title: "IE MPD MedicationStatement"
Description: "What a patient is taking, has taken or will take, as reported by the patient, a carer or a clinician (a medication use statement), derived from the HL7 Europe Base MedicationStatement (medicationStatement-eu-core). Traced to the HIQA draft Patient Summary Section 6.3 (Medication). Aligned with the Xt-EHR EHDSMedicationUse logical model v1.0.0; the R5 equivalent is MedicationUsage."

* ^status = #draft

// ── Status ─────────────────────────────────────────────────────────────────
// EHDSMedicationUse.header.status
* status 1..1 MS
* status ^short = "Status of the medication use statement (active | completed | entered-in-error | intended | stopped | on-hold | unknown | not-taken)"

// ── Medication ─────────────────────────────────────────────────────────────
// EHDSMedicationUse.medication
* medication[x] 1..1 MS
* medication[x] only CodeableConcept or Reference(IEMpdMedicationEPrescription)
* medicationCodeableConcept from IEMpdMedicationCodes (extensible)
* medication[x] ^short = "Medication (NMPC preferred; SNOMED CT Irish Edition and ATC as secondary codes)"

// ── Subject ────────────────────────────────────────────────────────────────
* subject 1..1 MS
* subject only Reference(IEMpdPatient)

// ── Effective period ───────────────────────────────────────────────────────
// EHDSMedicationUse.periodOfUse
* effective[x] MS
* effective[x] ^short = "Period when the patient took or is taking the medication (EHDSMedicationUse.periodOfUse)"

// ── Information source / author ────────────────────────────────────────────
// EHDSMedicationUse.header.author
* informationSource MS
* informationSource only Reference(IEMpdPatient or IEMpdPractitioner or IEMpdPractitionerRole or IEMpdRelatedPerson or IEMpdOrganization)
* informationSource ^short = "Author of the medication statement"

// ── Reason ─────────────────────────────────────────────────────────────────
// EHDSMedicationUse.reason
* reasonCode MS
* reasonCode ^short = "Reason for taking the medication — diagnosis or procedure (ICD-10, SNOMED CT)"
* reasonReference MS

// ── Dosage ─────────────────────────────────────────────────────────────────
// EHDSMedicationUse.dosageInstructions
* dosage 1..* MS
* dosage only IEMpdDosage
* dosage.text 1..1 MS
* dosage.text ^short = "Human-readable dosage instructions"
* dosage.timing MS
* dosage.route MS
* dosage.doseAndRate MS

// ── Derived from ───────────────────────────────────────────────────────────
// EHDSMedicationUse.derivedFrom — prescriptions, dispenses, or administrations
* derivedFrom MS
* derivedFrom ^short = "Prescription, dispense, or administration that is the basis for this statement (EHDSMedicationUse.derivedFrom)"

// ── Note ───────────────────────────────────────────────────────────────────
// EHDSMedicationUse.note
* note MS
* note ^short = "Additional information about the medication use statement"

// ── HIQA PS Section 6 Medication Information ───────────────────────────
* identifier MS
* identifier ^comment = "HIQA PS 6.3.2 Medication identifier (Required)."
* statusReason MS
* statusReason ^comment = "HIQA PS 6.3.1.2 Medication status reason (Required)."
* dosage.site MS
* dosage.site ^comment = "HIQA PS 6.3.8 Site (Required)."
* dosage.doseAndRate.dose[x] MS
* dosage.doseAndRate.dose[x] ^comment = "HIQA PS 6.3.9 Dose (Mandatory 1..1). Not enforced as 1..1: that would reject 'as directed' statements where only dosage.text is known (Requires Clarification; raised in the consultation feedback)."
* dosage.timing.repeat.frequency MS
* dosage.timing.repeat.frequency ^comment = "HIQA PS 6.3.10.1 Frequency (Mandatory within the frequency cluster)."
* dosage.timing.repeat.period MS
* dosage.timing.repeat.period ^comment = "HIQA PS 6.3.10.2 Period (Mandatory within the frequency cluster)."
* dosage.additionalInstruction MS
* dosage.additionalInstruction ^comment = "HIQA PS 6.3.11.1 Additional instructions (Required)."
