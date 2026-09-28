// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECorePractitioner.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdPractitioner
Parent: $EUPractitionerCore
Id: ie-mpd-practitioner
Title: "IE MPD Practitioner"
Description: "The IE Medication Events Practitioner Profile is based upon the core FHIR Practitioner Resource and defines the minimum set of data required to query and retrieve practitioner demographic information within the Irish healthcare system. It includes identifier slicing for professional registration numbers (HIQA EP/PS 2.6)."

// ── Identifier Slicing ──────────────────────────────────────────────────
* identifier MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^short = "An identifier for the practitioner"
* identifier 1..*
* identifier ^comment = "HIQA EP/PS 2.6 Health practitioner registration (Mandatory 1..1): registration with a professional body (2.6.1 type = the body, carried as the identifier system; 2.6.2 value = the registration number). Health practitioners from other EU Member States use their own register's identifier."
* identifier contains
    IMC 0..1 MS and
    PSI 0..1 MS and
    NMBI 0..1 MS and
    DentalCouncil 0..1 MS and
    HSPI 0..1

// HSP-I: Health Services Provider Identifier of an individual (Health Identifiers Act 2014 s.13-14; not a HIQA element)
* identifier[HSPI] ^short = "Health Services Provider Identifier, individual (HSP-I)"
* identifier[HSPI] ^comment = "Health Identifiers Act 2014 s.13 assigns a health services provider identifier (HSPI, 'a unique number', alphanumeric) to each health services provider; s.14 keeps it in the National Register of Health Services Provider Identifiers (Parts A, C, D for individuals). Not a HIQA draft element, so not MustSupport. No format is set by the Act. System URI placeholder shared with IE Core (IE Core OI-003, OI-030)."
* identifier[HSPI].system 1..1
* identifier[HSPI].system = $HSPI-I
* identifier[HSPI].type = $V2-0203#PRN "Provider number"
* identifier[HSPI].value 1..1

// PSI – Pharmaceutical Society of Ireland registration (HIQA EP/PS 2.6.2: up to eight digits)
* identifier[PSI] ^short = "Pharmaceutical Society of Ireland (PSI) registration number"
* identifier[PSI] ^comment = "HIQA EP/PS 2.6.2 example: a pharmacist's PSI registration number may contain up to eight digits. System URI placeholder (IE Core OI-003)."
* identifier[PSI].system 1..1 MS
* identifier[PSI].system = $PSI
* identifier[PSI].value 1..1 MS
* identifier[PSI] obeys ie-prac-psi-1

// NMBI – Nursing and Midwifery Board of Ireland (RNP / RMP divisions)
* identifier[NMBI] ^short = "Nursing and Midwifery Board of Ireland (NMBI) registration number"
* identifier[NMBI] ^comment = "HIQA EP/PS 2.6.2: a registered nurse or midwife prescriber records the value for the Registered Nurse Prescriber (RNP) or Registered Midwife Prescriber (RMP) division. Format Requires Clarification. System URI placeholder (IE Core OI-003)."
* identifier[NMBI].system 1..1 MS
* identifier[NMBI].system = $NMBI
* identifier[NMBI].value 1..1 MS

// Dental Council of Ireland
* identifier[DentalCouncil] ^short = "Dental Council registration number"
* identifier[DentalCouncil] ^comment = "HIQA EP (definitions, p. 11): registered dentists are prescribers. Format Requires Clarification. System URI placeholder (IE Core OI-003)."
* identifier[DentalCouncil].system 1..1 MS
* identifier[DentalCouncil].system = $DentalCouncil
* identifier[DentalCouncil].value 1..1 MS

// IMC – Irish Medical Council Registration
* identifier[IMC] ^short = "Irish Medical Council (IMC) registration number (MCRN)"
* identifier[IMC] ^comment = "HIQA EP/PS 2.6.2 example: a General Practitioner's six-digit Medical Council Registration Number (MCRN). Given as an example only, so no format is enforced. System URI placeholder (IE Core OI-003)."
* identifier[IMC] ^definition = "The Irish Medical Council registration number. All practising doctors in Ireland must be registered with the IMC."
* identifier[IMC].system 1..1 MS
* identifier[IMC].system = $IMC
* identifier[IMC].type = $V2-0203#MD "Medical License number"
* identifier[IMC].value 1..1 MS
* identifier[IMC].value ^short = "IMC registration number"

// ── Name ────────────────────────────────────────────────────────────────
* name 1..* MS
* name ^short = "The name(s) associated with the practitioner"
* name.family 1..1 MS
* name.family ^comment = "HIQA EP/PS 2.3 Surname (Mandatory 1..1): the registered family name."
* name.family ^short = "Family name (surname)"
* name.given 1..* MS
* name.given ^comment = "HIQA EP/PS 2.2 Forename (Mandatory 1..1): the registered first name."
* name.given ^short = "Given names"
* name.prefix MS
* name.suffix MS

// ── Telecom ─────────────────────────────────────────────────────────────
* telecom MS
* telecom ^short = "A contact detail for the practitioner"
* telecom.system MS
* telecom.value MS
* telecom.use MS

// ── Address ─────────────────────────────────────────────────────────────
* address MS
* address ^short = "Address(es) of the practitioner"
* address.line MS
* address.city MS
* address.state MS
* address.state from https://hl7-ie.github.io/medication-events/fhir/ValueSet/ie-mpd-county (extensible)
* address.postalCode MS
* address.country MS

// ── Qualification ───────────────────────────────────────────────────────
* qualification MS
* qualification ^short = "Certification, licenses, or training pertaining to the provision of care"
* qualification.identifier MS
* qualification.code MS
* qualification.code ^short = "Coded representation of the qualification"
* qualification.code from http://terminology.hl7.org/ValueSet/v2-0360 (preferred)
* qualification.period MS
* qualification.issuer MS

// ── Gender ──────────────────────────────────────────────────────────────
* gender MS

// ── Communication ───────────────────────────────────────────────────────
* communication MS


Invariant: ie-prac-psi-1
Description: "PSI registration number: up to eight digits (HIQA EP/PS 2.6.2)"
Expression: "value.matches('^[0-9]{1,8}$')"
Severity: #warning
