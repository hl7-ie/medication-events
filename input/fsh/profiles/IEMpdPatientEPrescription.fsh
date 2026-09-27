// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECorePatientEPrescription.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdPatientEPrescription
Parent: IEMpdPatient
Id: ie-mpd-patient-eprescription
Title: "IE MPD Patient (ePrescription/eDispensation)"
Description: "The patient as the subject of an ePrescription or eDispensation. It carries the HIQA ePrescription/eDispensation patient dataset (Section 1) and nothing more. Ethnicity, mother's maiden name, nationality, citizenship, place of birth, religion, marital status, pronouns, photo and contact persons are not part of that dataset, so they are prohibited (GDPR Art. 5(1)(c) data minimisation; ethnicity and religion are Art. 9 special-category data). Patient identity is established by the IHI (when available) together with name, date of birth and address (see the clinical-safety log, IE Core HZ-06)."
* ^status = #draft

// ── Data minimisation: not in the HIQA EP dataset (IE Core ADR-002) ────────────
* extension[patient-nationality] 0..0
* extension[patient-citizenship] 0..0
* extension[birthPlace] 0..0
* extension[pronouns] 0..0
* extension contains
    $PatientReligion named religion 0..0 and
    IEMpdMothersFormerSurname named mothersFormerSurname 0..0 and
    IEMpdCountryOfAffiliation named countryOfAffiliation 0..0
* extension[ethnicity] 0..0
* extension[ethnicity] ^comment = "Prohibited: not in the HIQA EP dataset; GDPR Art. 9 special-category data (IE Core ADR-002)."
* extension[mothersMaidenName] 0..0
* extension[mothersMaidenName] ^comment = "Prohibited: not in the HIQA EP dataset (IE Core ADR-002). Identity: see IE Core HZ-06."
* extension[interpreterRequired] 0..0
* extension[patient-nationality] ^comment = "Prohibited: not in the HIQA EP dataset (it is PS 1.4.7)."
* extension[religion] ^comment = "Prohibited: not in either HIQA dataset; GDPR Art. 9 special-category data."
* extension[birthPlace] ^comment = "Prohibited: not in the HIQA EP dataset (it is PS 1.4.3)."
* maritalStatus 0..0
* maritalStatus ^comment = "Prohibited: not in the HIQA EP dataset."
* photo 0..0
* contact 0..0
* contact ^comment = "Prohibited: third-party personal data not in the HIQA EP dataset. The person collecting a dispensed medicine is recorded on the dispense (EP 6.4 Receiver)."
* multipleBirth[x] 0..0

// ── 1.4.3 Sex / 1.4.4 Gender ───────────────────────────────────────────
* extension[sexAssignedAtBirth] 1..1 MS
* extension[sexAssignedAtBirth] ^comment = "HIQA EP 1.4.3 Sex (Mandatory 1..1): the sex of the patient assigned at birth."
* extension[gender-identity] 0..1 MS
* extension[gender-identity] ^comment = "HIQA EP 1.4.4 Gender cluster (Required 0..1): 1.4.4.1 Gender (coded) and 1.4.4.2 Other gender identity (free text in valueCodeableConcept.text)."

// ── 1.1 Name details ───────────────────────────────────────────────────
* name.given 1..* MS
* name.given ^comment = "HIQA EP 1.1.2 Forename (Mandatory 1..1): the legal first name."
* name.family 1..1 MS
* name.family ^comment = "HIQA EP 1.1.3 Surname (Mandatory 1..1): the legal family or marital name."
* name.prefix ^comment = "HIQA EP 1.1.1 Name title (Optional 0..*)."
* name.suffix ^comment = "HIQA EP 1.1.4 Name suffix (Optional 0..*)."

// ── 1.2 Address ────────────────────────────────────────────────────────
* address 1..* MS
* address.use 1..1 MS
* address.use ^comment = "HIQA EP 1.2.6 Address type (Mandatory 1..1): type or purpose of the address, e.g. place of residence (home) or temporary accommodation (temp). No HL7 code exists for homelessness; that is Requires Clarification (see open issues)."
* address.line 1..* MS
* address.line ^comment = "HIQA EP 1.2.2 Address line(s) (Mandatory 1..1). If the address is unknown, HIQA says it may be recorded here."
* address.city ^comment = "HIQA EP 1.2.3 Suburb/Town/Townland/Locality (Required 0..1)."
* address.state 1..1 MS
* address.state ^comment = "HIQA EP 1.2.4 District/County (Mandatory 1..1). Outside Ireland: the equivalent district or city."
* address.postalCode ^comment = "HIQA EP 1.2.1 Postcode (Required 0..1): Eircode in the format XXX XXXX."
* address.country ^comment = "HIQA EP 1.2.5 Country (Required 0..1)."
* address.type ^comment = "HIQA EP 1.2.7 Address use (Optional 0..1): whether the address is a postal address."

// ── 1.3 Identifiers ────────────────────────────────────────────────────
* identifier contains PPSN 0..1
* identifier[PPSN] ^short = "Personal Public Service Number (PPSN): Requires Clarification"
* identifier[PPSN] ^definition = "HIQA EP 1.3.2 Personal Public Service Number (Required 0..1): seven numbers followed by one or two letters."
* identifier[PPSN] ^comment = "Deliberately NOT MustSupport. The legal basis for using the PPSN as a health identifier is Requires Clarification (IE Core OI-008), so a sender is never obliged to send it. The system URI is a placeholder (IE Core OI-003)."
* identifier[PPSN].system 1..1
* identifier[PPSN].system = $PPS
* identifier[PPSN].value 1..1
* identifier[PPSN] obeys ie-pat-ppsn-1
* identifier[IHI] ^comment = "HIQA EP 1.3.1 IHI (Required 0..1). For individuals living outside Ireland, record their healthcare ID as an 'other identifier' (EP 1.3.3)."

// ── 1.4.1 Date of birth ────────────────────────────────────────────────
* birthDate 1..1 MS
* birthDate ^comment = "HIQA EP 1.4.1 Date of birth (Mandatory 1..1). A legal requirement on cross-border prescriptions. Age under 12: see IEMpdPatientAgeAtPrescribing on the prescription (EP 1.4.2)."

// ── 1.5 Communication details ──────────────────────────────────────────
* telecom ^comment = "HIQA EP 1.5.1 Mobile phone (Required 0..*), 1.5.2 Email (Required 0..*), 1.5.3 Other communication details (Optional 0..*)."
* communication ^comment = "Not a HIQA EP element. MustSupport is inherited from IEMpdPatient; useful for choosing the language of the patient instructions. Not personal special-category data."


Invariant: ie-pat-ppsn-1
Description: "PPSN format: seven numbers followed by one or two letters (HIQA EP/PS 1.3.2)"
Expression: "value.matches('^[0-9]{7}[A-Za-z]{1,2}$')"
Severity: #warning
