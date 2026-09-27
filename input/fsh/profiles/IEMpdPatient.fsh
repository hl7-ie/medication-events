// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECorePatient.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdPatient
Parent: $EUPatientCore
Id: ie-mpd-patient
Title: "IE MPD Patient"
Description: "Base Patient profile for the Irish health system, derived from the HL7 Europe Base Patient. It is deliberately permissive: special-category and identity-disambiguation data (for example ethnicity or mother's maiden name) are allowed but NOT MustSupport. Use-case profiles decide what must be sent and what must not be sent: IEMpdPatientEPrescription for ePrescription and eDispensation, and IEMpdPatientSummaryPatient for the Patient Summary (IE Core ADR-002, GDPR Art. 5(1)(c) data minimisation)."

// ── Extensions ──────────────────────────────────────────────────────────
// EU Base (patient-eu-core) already slices: birthPlace, sex-for-clinical-use, gender-identity,
// pronouns, patient-citizenship, patient-nationality, birthTime. Those slices are reused, never re-declared.
* extension contains
    $RecordedSexOrGender named sexAssignedAtBirth 0..1 MS and
    IEMpdEthnicity named ethnicity 0..* and
    $PatientMothersMaidenName named mothersMaidenName 0..1 and
    $PatientInterpreterRequired named interpreterRequired 0..1
* extension[gender-identity] MS

* extension[sexAssignedAtBirth] ^short = "Sex assigned at birth (recorded sex, type LOINC 76689-9)"
* extension[sexAssignedAtBirth] ^definition = "The patient's sex assigned at birth, recorded with individual-recordedSexOrGender and typed with LOINC 76689-9 'Sex assigned at birth'. This is distinct from Patient.gender (administrative gender) and from gender identity."
* extension[sexAssignedAtBirth] ^comment = "HIQA EP 1.4.3 / PS 1.4.4 Sex (Mandatory 1..1). Mandatory in the use-case profiles (IE Core ADR-002). Displaying sex at birth alongside gender identity can disclose a gender reassignment; see the security guidance."
* extension[sexAssignedAtBirth].extension[type] 1..1
* extension[sexAssignedAtBirth].extension[type].value[x] = $LOINC#76689-9 "Sex assigned at birth"
* extension[gender-identity] ^short = "Gender identity (HIQA gender cluster)"
* extension[gender-identity] ^comment = "HIQA EP 1.4.4 / PS 1.4.5 Gender cluster (Required 0..1). 'Other gender identity' free text (EP 1.4.4.2 / PS 1.4.5.2) goes in valueCodeableConcept.text."
* extension[ethnicity] ^short = "Ethnicity (special-category data; Patient Summary only)"
* extension[ethnicity] ^comment = "GDPR Art. 9 special-category data. HIQA PS 1.4.10 (Required 0..*). Not part of the HIQA ePrescription dataset, and prohibited in IEMpdPatientEPrescription (IE Core ADR-002)."
* extension[mothersMaidenName] ^short = "Mother's maiden name (not MustSupport)"
* extension[mothersMaidenName] ^comment = "Not part of the HIQA ePrescription dataset. The Patient Summary uses IEMpdMothersFormerSurname (HIQA PS 1.4.6, 0..*)."
* extension[pronouns] ^short = "Personal pronouns (not in either HIQA dataset)"
* extension[interpreterRequired] ^short = "Whether the patient requires an interpreter"

// ── Identifier Slicing (IE Core ADR-006) ─────────────────────────────────────────
* identifier MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^short = "Identifiers for this patient"
* identifier ^comment = "HIQA EP/PS 1.3. Identifiers other than the IHI (and the PPSN in the use-case profiles) are carried as 'other identifiers used in health and social care' (HIQA 1.3.3): type, value, validity period and issuing organisation. Examples from HIQA include PCRS scheme numbers (medical card, GP visit card, DPS, LTI, HAA), GP record number, MRN, NHS number and EHIC."
* identifier.type MS
* identifier.type ^comment = "HIQA EP/PS 1.3.3.1 (Required)."
* identifier.value MS
* identifier.value ^comment = "HIQA EP/PS 1.3.3.2 (Required)."
* identifier.period MS
* identifier.period ^comment = "HIQA EP/PS 1.3.3.3 (Required)."
* identifier.assigner MS
* identifier.assigner ^comment = "HIQA EP/PS 1.3.3.4 (Required): name of the issuing organisation (assigner.display), for example 'HSE'."
* identifier contains IHI 0..1 MS

// IHI – Individual Health Identifier (HIQA EP/PS 1.3.1, Required 0..1)
* identifier[IHI] ^short = "Individual Health Identifier (IHI)"
* identifier[IHI] ^definition = "The Individual Health Identifier assigned by the HSE. HIQA describes it as a unique 18 or 10-digit number."
* identifier[IHI] ^comment = "HIQA EP/PS 1.3.1 (Required 0..1). The system URI is a placeholder pending an HSE-published URI (IE Core OI-003). The relationship between the 18- and 10-digit forms is Requires Clarification (IE Core OI-002)."
* identifier[IHI].system 1..1 MS
* identifier[IHI].system = $IHI
* identifier[IHI].type = $V2-0203#NI "National unique individual identifier"
* identifier[IHI].value 1..1 MS
* identifier[IHI].value ^short = "IHI number (18 or 10 digits)"
* identifier[IHI] obeys ie-pat-1

// ── Name ────────────────────────────────────────────────────────────────
* name 1..* MS
* name ^short = "A name associated with the patient"
* name.family MS
* name.family ^short = "Family name (surname)"
* name.given MS
* name.given ^short = "Given names (first and middle names)"
* name.prefix MS
* name.suffix MS
* name.use MS

// ── Gender ──────────────────────────────────────────────────────────────
* gender 1..1 MS
* gender ^short = "Administrative gender (not sex assigned at birth)"
* gender ^comment = "Administrative gender for record-keeping. Sex assigned at birth (HIQA EP 1.4.3 / PS 1.4.4) is carried in extension[sexAssignedAtBirth], and gender identity in extension[gender-identity]."

// ── Birth Date ──────────────────────────────────────────────────────────
* birthDate MS
* birthDate ^short = "The date of birth for the patient"
* birthDate ^comment = "HIQA EP/PS 1.4.1 Date of birth (Mandatory 1..1). 1..1 is inherited from HL7 Europe Base patient-eu-core."

// ── Address ─────────────────────────────────────────────────────────────
* address MS
* address ^short = "An address for the patient (Irish address)"
* address.use MS
* address.line MS
* address.line ^short = "Street name, number, direction & P.O. Box etc."
* address.city MS
* address.city ^short = "Suburb, town, townland or locality (Dublin postal district, e.g. 'Dublin 2', goes here)"
* address.state MS
* address.state ^short = "County"
* address.state ^definition = "The Irish county. Bound to the IE Medication Events County ValueSet."
* address.state from https://hl7-ie.github.io/medication-events/fhir/ValueSet/ie-mpd-county (extensible)
* address.postalCode MS
* address.postalCode ^short = "Eircode or postal code (Eircode format XXX XXXX)"
* address.country MS
* address.country ^short = "Country (ISO 3166-1 alpha-2)"

// ── Telecom ─────────────────────────────────────────────────────────────
* telecom MS
* telecom ^short = "A contact detail for the patient"
* telecom.system 1..1 MS
* telecom.value 1..1 MS
* telecom.use MS

// ── Communication ───────────────────────────────────────────────────────
* communication MS
* communication.language MS

// ── Deceased ────────────────────────────────────────────────────────────
* deceased[x] MS

// ── Managing Organization ───────────────────────────────────────────────
* managingOrganization MS
* managingOrganization only Reference(IEMpdOrganization)

// ── General Practitioner ────────────────────────────────────────────────
* generalPractitioner MS
* generalPractitioner only Reference(IEMpdOrganization or IEMpdPractitioner or IEMpdPractitionerRole)


// ╭──────────────────────────────────────────────────────────────────────╮
// │  Invariants                                                          │
// ╰──────────────────────────────────────────────────────────────────────╯

Invariant: ie-pat-1
Description: "IHI SHALL be 18 or 10 digits (HIQA EP/PS 1.3.1: 'A unique 18 or 10-digit number')"
Expression: "value.matches('^([0-9]{18}|[0-9]{10})$')"
Severity: #error
