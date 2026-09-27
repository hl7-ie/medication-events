// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/extensions/HIQAExtensions.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Extension: IEMpdMothersFormerSurname
Id: ie-mpd-mothers-former-surname
Title: "IE MPD Mother's Former Surname"
Description: "One former surname of the patient's mother (repeat for each). HIQA PS 1.4.6 'Mother's former surnames' (Required 0..*): all former surnames of the patient's mother that may help identify the patient. The HL7 patient-mothersMaidenName extension holds only one name. Whether HIQA means the mother's birth surname only is Requires Clarification (IE Core OI-011). Patient Summary only; prohibited in ePrescription (IE Core ADR-002)."
Context: Patient
* ^status = #draft
* value[x] only string
* value[x] 1..1


Extension: IEMpdCountryOfAffiliation
Id: ie-mpd-country-of-affiliation
Title: "IE MPD Country of Affiliation"
Description: "HIQA PS 1.4.8 Country of affiliation (Required 0..1): the designated source country where the patient and their health information are based. Typically, but not always, the country of residence, and it may differ from nationality. No HL7 extension exists. Patient Summary only; prohibited in ePrescription (IE Core ADR-002)."
Context: Patient
* ^status = #draft
* value[x] only CodeableConcept
* value[x] 1..1
* valueCodeableConcept from http://hl7.org/fhir/ValueSet/iso3166-1-2 (required)


Extension: IEMpdPatientAgeAtPrescribing
Id: ie-mpd-patient-age-at-prescribing
Title: "IE MPD Patient Age at Prescribing"
Description: "HIQA EP 1.4.2 Age (cluster): the patient's age recorded on the prescription. HIQA: if the date of birth shows the patient is under 12 years, recording the age on the prescription record is a legal requirement in Ireland. Age should be entered in years, and to the nearest three months (or less) for children under two. 1.4.2.1 value and 1.4.2.2 type are Mandatory within the cluster."
Context: MedicationRequest
* ^status = #draft
* value[x] only Age
* value[x] 1..1
* valueAge.value 1..1
* valueAge.value ^comment = "HIQA EP 1.4.2.1 Age if less than 12 years – value (Mandatory 1..1)."
* valueAge.system 1..1
* valueAge.system = $UCUM
* valueAge.code 1..1
* valueAge.code from IEMpdAgeUnits (extensible)
* valueAge obeys ie-age-units-1
* valueAge.code ^comment = "HIQA EP 1.4.2.2 Age if less than 12 years – type (Mandatory 1..1): years, months or days."


ValueSet: IEMpdAgeUnits
Id: ie-mpd-age-units
Title: "IE MPD Age Units"
Description: "UCUM units for recording a patient's age: years, months or days (HIQA EP 1.4.2.2)."
* ^experimental = false
* $UCUM#a "year"
* $UCUM#mo "month"
* $UCUM#d "day"


// ── HIQA EP Section 3: Medication prescription ─────────────────────────

Extension: IEMpdQuantityInWordsAndFigures
Id: ie-mpd-quantity-in-words-and-figures
Title: "IE MPD Quantity Prescribed (Words and Figures)"
Description: "HIQA EP 3.5.7.2 Quantity prescribed (free text): the overall quantity in words and figures, e.g. 'twenty-eight (28) tablets'. HIQA: a legal requirement if the item is a controlled drug under the Misuse of Drugs Act 1977 (as amended) and the Misuse of Drugs Regulations 2017 (S.I. No. 173/2017). Enforced for MDA Schedules 2, 3 and 4 Part 1 by invariant ie-rx-cd-1."
Context: MedicationRequest
* ^status = #draft
* value[x] only string
* value[x] 1..1


Extension: IEMpdNumberOfInstalments
Id: ie-mpd-number-of-instalments
Title: "IE MPD Number of Instalments"
Description: "HIQA EP 3.5.12 Number of instalments (Required 0..1): whether the total quantity can be dispensed in smaller, specified amounts at specified intervals (phased dispensing). This differs from repeats (numberOfRepeatsAllowed, EP 3.5.11). HIQA: a legal requirement for Schedule 2, 3 and 4 Part 1 controlled drugs; the interval is dispenseRequest.dispenseInterval (EP 3.5.13)."
Context: MedicationRequest.dispenseRequest
* ^status = #draft
* value[x] only positiveInt
* value[x] 1..1


Extension: IEMpdDoNotExtend
Id: ie-mpd-do-not-extend
Title: "IE MPD Do Not Extend"
Description: "HIQA EP 3.5.9.2 'Do Not Extend' (Optional 0..1): true when the prescriber does not want the pharmacist to extend the prescription beyond its validity period. HIQA: pharmacists can extend a six-month prescription for up to a further six months."
Context: MedicationRequest.dispenseRequest
* ^status = #draft
* value[x] only boolean
* value[x] 1..1


// ── HIQA EP Section 4: Medication ──────────────────────────────────────

Extension: IEMpdMedicationInterchangeable
Id: ie-mpd-medication-interchangeable
Title: "IE MPD Medicinal Product Is Interchangeable"
Description: "HIQA EP 3.5.10.1 (Required 0..1, expected auto-populated from the NMPC): whether the medicinal product is on the HPRA List of Interchangeable Medicines. If true, substitution is allowed by default unless the prescriber invokes 'Do Not Substitute' (MedicationRequest.substitution.allowedBoolean = false)."
Context: Medication
* ^status = #draft
* value[x] only boolean
* value[x] 1..1


Extension: IEMpdExemptMedicationItem
Id: ie-mpd-exempt-medication-item
Title: "IE MPD Exempt Medication Item (Requires Clarification)"
Description: "HIQA EP 4.11 Exempt medication item (Required 0..1, Boolean, expected auto-populated). REQUIRES CLARIFICATION: the draft does not say what the item is exempt from (e.g. an exempt medicinal product without a marketing authorisation). Modelled as a boolean flag so that the dataset element can be carried; see the open issues."
Context: Medication
* ^status = #draft
* ^experimental = true
* value[x] only boolean
* value[x] 1..1


// ── HIQA EP Section 6: Medication dispense ─────────────────────────────

Extension: IEMpdDispenseReceiverRelatedPerson
Id: ie-mpd-dispense-receiver-related-person
Title: "IE MPD Dispense Receiver (Related Person)"
Description: "HIQA EP 6.4.3 Related person is the receiver (Optional): the person (e.g. carer or family member) who collected the dispensed medication on the patient's behalf. R4 MedicationDispense.receiver allows only Patient or Practitioner."
Context: MedicationDispense
* ^status = #draft
* value[x] only Reference(IEMpdRelatedPerson)
* value[x] 1..1


Invariant: ie-age-units-1
Description: "The age SHALL be in UCUM years (a), months (mo) or days (d) (HIQA EP 1.4.2.2)"
Expression: "system = 'http://unitsofmeasure.org' and (code = 'a' or code = 'mo' or code = 'd')"
Severity: #error
