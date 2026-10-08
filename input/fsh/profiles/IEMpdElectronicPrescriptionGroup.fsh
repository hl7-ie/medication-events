// Electronic Prescription Group (ePG), ADR-003. Started from IE Core's ePrescription Bundle (hl7-ie/ie-core @ 2b91509,
// input/fsh/profiles/IECoreBundleEPrescription.fsh), renamed for IE Medication Events (ADR-001).
// The ePG is a Bundle of 1..* electronic prescriptions (eP, MedicationRequest) issued together as part of the same
// request, sharing one prescription group identifier, with their eDispensations and provenance. The prescription group
// header (RequestGroup) carries the group-level HIQA EP data (3.1 to 3.4); the patient, prescriber, facility,
// medicines and allergy statement travel with them.

Profile: IEMpdElectronicPrescriptionGroup
Parent: Bundle
Id: ie-mpd-electronic-prescription-group
Title: "IE MPD Electronic Prescription Group (ePG)"
Description: "An Electronic Prescription Group (ePG): a Bundle of one or more electronic prescriptions (eP, IEMpdMedicationRequestEPrescription) issued together as part of the same request, sharing one prescription group identifier (MedicationRequest.groupIdentifier), with the eDispensations of those eP (IEMpdMedicationDispenseEDispensation) and their provenance (the prescriber's signature, dispensing records). The prescription group header (IEMpdPrescriptionGroupHeader) carries the group-level data HIQA EP Section 3 defines (identifier, date of issue, status, presented form), because a Bundle cannot. The patient (IEMpdPatientEPrescription), prescriber and facility, dispensing pharmacist and pharmacy, medicinal products and the allergy statement (IEMpdListAllergiesAtPrescribing) travel with them. Prescription-level legal and safety rules (HIQA EP 1.4.2, 1.6.1, 2.9, 2.10.1, 3.1 to 3.5, 6.5) are enforced here because they span resources."
* ^status = #draft
* identifier 1..1 MS
* identifier ^comment = "The prescription group identifier (HIQA EP 3.1 electronic prescription identifier): the same as the header identifier and every eP's groupIdentifier."
* type = #collection
* timestamp 1..1 MS
* entry 1..* MS
* entry.fullUrl 1..1
* entry.resource 1..1
* entry ^slicing.discriminator.type = #type
* entry ^slicing.discriminator.path = "resource"
* entry ^slicing.rules = #open
* entry contains
    patient 1..1 MS and
    header 1..1 MS and
    electronicPrescription 1..* MS and
    allergyStatement 1..1 MS and
    allergy 0..* MS and
    practitioner 0..* MS and
    practitionerRole 0..* MS and
    organization 0..* MS and
    medication 0..* MS and
    dispensation 0..* MS and
    provenance 0..* MS
* entry[patient].resource only IEMpdPatientEPrescription
* entry[header].resource only IEMpdPrescriptionGroupHeader
* entry[header] ^comment = "HIQA EP Section 3: the prescription group header (identifier, date of issue, prescription status, presented form) listing the eP (ADR-003)."
* entry[electronicPrescription].resource only IEMpdMedicationRequestEPrescription
* entry[electronicPrescription] ^comment = "The electronic prescriptions (eP) of the group: one MedicationRequest per prescribed medication (HIQA EP 3.5 prescription item), all with the group's identifier in groupIdentifier."
* entry[allergyStatement].resource only IEMpdListAllergiesAtPrescribing
* entry[allergyStatement] ^comment = "HIQA EP 1.6.1 / 1.6.2: exactly one allergy statement per prescription, either listing the allergies or giving the reason none are recorded."
* entry[allergy].resource only IEMpdAllergyIntolerance
* entry[practitioner].resource only IEMpdPractitioner
* entry[practitionerRole].resource only IEMpdPractitionerRole
* entry[organization].resource only IEMpdOrganization
* entry[medication].resource only IEMpdMedicationEPrescription
* entry[dispensation].resource only IEMpdMedicationDispenseEDispensation
* entry[dispensation] ^comment = "HIQA EP Section 6: the eDispensations (and non-dispensations) of the eP in this ePG. Each is authorised by an eP in the ePG and is for the ePG's patient (ie-bnd-rx-12, ie-bnd-rx-13)."
* entry[provenance].resource only IEMpdProvenance
* entry[provenance] ^comment = "Provenance of the ePG's resources: the prescriber's signature over the eP (IEMpdProvenanceEPrescriptionSignature, HIQA EP 2.13) and records of who dispensed what and when. Every Provenance targets resources in the ePG (ie-bnd-rx-14)."
* obeys ie-bnd-rx-1 and ie-bnd-rx-2 and ie-bnd-rx-3 and ie-bnd-rx-4 and ie-bnd-rx-5 and ie-bnd-rx-6 and ie-bnd-rx-7 and ie-bnd-rx-8 and ie-bnd-rx-9 and ie-bnd-rx-10 and ie-bnd-rx-11 and ie-bnd-rx-12 and ie-bnd-rx-13 and ie-bnd-rx-14



Profile: IEMpdElectronicPrescriptionGroupCrossBorder
Parent: IEMpdElectronicPrescriptionGroup
Id: ie-mpd-electronic-prescription-group-crossborder
Title: "IE MPD Electronic Prescription Group (ePG, cross-border)"
Description: "An ePrescription issued in Ireland to be dispensed in another EU Member State, or issued in another Member State to be dispensed in Ireland. A sender (NePS or the National Contact Point for eHealth) marks a cross-border prescription by claiming this profile in Bundle.meta.profile. No invented tag is used (IE Core ADR-003). It adds the legal requirements HIQA cites for cross-border prescriptions: patient date of birth (EP 1.4.1), prescriber telephone and secure email (EP 2.10.1, 2.10.2), and an electronic signature (EP 2.13)."
* ^status = #draft
* entry[provenance] 1..*
* entry[provenance] ^comment = "HIQA EP 2.13 Signature (a Provenance with a signature over every eP, ie-bnd-xb-2): a legal requirement for a prescription issued in another EU Member State to be dispensed in Ireland. Required in both directions here for symmetry (see open issues)."
* obeys ie-bnd-xb-1 and ie-bnd-xb-2



Profile: IEMpdListAllergiesAtPrescribing
Parent: List
Id: ie-mpd-list-allergies-at-prescribing
Title: "IE MPD Allergy Statement at Prescribing"
Description: "The patient's allergy and intolerance statement sent with an ePrescription (HIQA EP 1.6.1 / 1.6.2). Either it lists the allergies (entry → IEMpdAllergyIntolerance), or it states why none are recorded (emptyReason: e.g. nilknown = no known allergies, notasked, unavailable). A prescription cannot be sent without one, so a pharmacist can always tell 'no known allergies' from 'not asked' (clinical-safety hazard IE Core HZ-03)."
* ^status = #draft
* status = #current
* mode = #snapshot
* code 1..1 MS
* code = $LOINC#48765-2 "Allergies and adverse reactions Document"
* subject 1..1 MS
* subject only Reference(IEMpdPatientEPrescription)
* date 1..1 MS
* date ^comment = "When the allergy statement was confirmed."
* source MS
* source ^comment = "Who confirmed the allergy statement (HIQA EP 1.6.2.4.2 record entry author)."
* entry MS
* entry.item only Reference(IEMpdAllergyIntolerance)
* entry ^comment = "HIQA EP 1.6.2 Allergies and intolerances (Required 0..*)."
* emptyReason MS
* emptyReason from http://hl7.org/fhir/ValueSet/list-empty-reason (extensible)
* emptyReason ^comment = "HIQA EP 1.6.1 Reason for not recording allergies and intolerances (Required 0..1; only when no allergies are recorded). nilknown = the patient has no known allergies."
* obeys ie-list-allergy-1



Profile: IEMpdProvenanceEPrescriptionSignature
Parent: IEMpdProvenance
Id: ie-mpd-provenance-eprescription-signature
Title: "IE MPD Provenance (ePrescription signature)"
Description: "The prescriber's electronic signature over the electronic prescriptions (eP) (HIQA EP 2.13 Signature). A Provenance signature is used rather than Bundle.signature so that the signature survives storage in NePS and re-bundling for cross-border exchange (IE Core ADR-003). The signature format and eIDAS assurance level are Requires Clarification (IE Core OI-009)."
* ^status = #draft
* target 1..* MS
* target only Reference(IEMpdMedicationRequestEPrescription or IEMpdPrescriptionGroupHeader)
* target ^comment = "Every eP covered by the signature, and optionally the prescription group header (ADR-003). Use version-specific references where the server supports them."
* recorded 1..1 MS
* agent 1..1 MS
* agent.who 1..1 MS
* agent.who only Reference(IEMpdPractitionerRole or IEMpdPractitioner)
* agent.who ^comment = "The prescriber who signed (HIQA EP 2.13: the prescriber's legal name as written with an electronic or digital signature)."
* signature 1..* MS
* signature.type MS
* signature.when MS
* signature.who MS
* signature.who only Reference(IEMpdPractitionerRole or IEMpdPractitioner)
* signature.data MS
* signature.data ^comment = "The signature value. Format (e.g. JAdES) Requires Clarification (IE Core OI-009)."



// ╭──────────────────────────────────────────────────────────────────────╮
// │  Invariants                                                          │
// ╰──────────────────────────────────────────────────────────────────────╯

Invariant: ie-bnd-rx-1
Description: "All electronic prescriptions (eP) in the ePG SHALL share one prescription group identifier (system and value) (HIQA EP 3.1)"
Expression: "entry.resource.ofType(MedicationRequest).count() <= 1 or (entry.resource.ofType(MedicationRequest).all(groupIdentifier.exists()) and entry.resource.ofType(MedicationRequest).select(groupIdentifier.system + '|' + groupIdentifier.value).distinct().count() = 1)"
Severity: #error


Invariant: ie-bnd-rx-2
Description: "Every eP SHALL reference the allergy statement (a List coded LOINC 48765-2) in supportingInformation (HIQA EP 1.6.1 / 1.6.2)"
Expression: "entry.resource.ofType(MedicationRequest).all(supportingInformation.where(resolve() is List and resolve().code.coding.where(system = 'http://loinc.org' and code = '48765-2').exists()).exists())"
Severity: #error


Invariant: ie-bnd-rx-3
Description: "If the patient is under 12 years old at the date of prescribing, or the date of birth is not a full date, every eP SHALL record the patient's age (HIQA EP 1.4.2; a legal requirement)"
Expression: "entry.resource.ofType(MedicationRequest).all(extension('https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-patient-age-at-prescribing').exists() or ((%resource.entry.resource.ofType(Patient).first().birthDate.toString().length() = 10) and ((%resource.entry.resource.ofType(Patient).first().birthDate + 12 years).toString() <= authoredOn.toString().substring(0,10))))"
Severity: #error


Invariant: ie-bnd-rx-4
Description: "The prescriber (the requester, its practitioner, or its organisation) SHALL have a telephone number (HIQA EP 2.10 / 2.10.1, Mandatory)"
Expression: "entry.resource.ofType(MedicationRequest).all(requester.resolve().telecom.where(system = 'phone').exists() or requester.resolve().ofType(PractitionerRole).practitioner.resolve().telecom.where(system = 'phone').exists() or requester.resolve().ofType(PractitionerRole).organization.resolve().telecom.where(system = 'phone').exists())"
Severity: #error


Invariant: ie-bnd-rx-5
Description: "Every eP, the allergy statement and every allergy SHALL be about the one Patient in the Bundle (patient safety: the allergy statement must be the patient's own)"
Expression: "(entry.resource.ofType(MedicationRequest).subject.reference | entry.resource.ofType(List).subject.reference | entry.resource.ofType(AllergyIntolerance).patient.reference).all(($this = %resource.entry.where(resource is Patient).fullUrl) or ($this = ('Patient/' + %resource.entry.resource.ofType(Patient).id)))"
Severity: #error


Invariant: ie-bnd-rx-6
Description: "Every allergy listed in the allergy statement SHALL be included in the Bundle (HIQA EP 1.6.2)"
Expression: "entry.resource.ofType(List).entry.item.reference.all(($this in %resource.entry.fullUrl) or ($this.replace('AllergyIntolerance/', '') in %resource.entry.resource.ofType(AllergyIntolerance).id))"
Severity: #error


Invariant: ie-bnd-xb-1
Description: "A cross-border prescription SHALL give a secure contact email for the prescriber (the requester, its practitioner, or its organisation) (HIQA EP 2.10.2; a legal requirement cross-border)"
Expression: "entry.resource.ofType(MedicationRequest).all(requester.resolve().telecom.where(system = 'email').exists() or requester.resolve().ofType(PractitionerRole).practitioner.resolve().telecom.where(system = 'email').exists() or requester.resolve().ofType(PractitionerRole).organization.resolve().telecom.where(system = 'email').exists())"
Severity: #error


Invariant: ie-bnd-xb-2
Description: "A cross-border prescription SHALL carry a prescriber signature covering every eP, referenced by fullUrl or by relative reference (HIQA EP 2.13; a legal requirement)"
Expression: "entry.where(resource is MedicationRequest).all((fullUrl in %resource.entry.resource.ofType(Provenance).where(signature.exists()).target.reference) or (('MedicationRequest/' + resource.id) in %resource.entry.resource.ofType(Provenance).where(signature.exists()).target.reference))"
Severity: #error


Invariant: ie-list-allergy-1
Description: "The allergy statement SHALL either list allergies or give the reason none are recorded (HIQA EP 1.6.1 / 1.6.2)"
Expression: "entry.exists() or emptyReason.exists()"
Severity: #error


// ── Prescription group (ADR-003; consistency rules informed by NHS EPS prescription-order) ──

Invariant: ie-bnd-rx-7
Description: "The prescription group header SHALL list every eP in the ePG as an action, and only those (HIQA EP 3.5)"
Expression: "entry.where(resource is MedicationRequest).all((fullUrl in %resource.entry.resource.ofType(RequestGroup).action.resource.reference) or (('MedicationRequest/' + resource.id) in %resource.entry.resource.ofType(RequestGroup).action.resource.reference)) and entry.resource.ofType(RequestGroup).action.resource.reference.all(($this in %resource.entry.where(resource is MedicationRequest).fullUrl) or ($this.replace('MedicationRequest/', '') in %resource.entry.resource.ofType(MedicationRequest).id))"
Severity: #error

Invariant: ie-bnd-rx-8
Description: "Every eP SHALL carry one of the prescription group identifiers as its groupIdentifier (HIQA EP 3.1)"
Expression: "entry.resource.ofType(MedicationRequest).all((groupIdentifier.system + '|' + groupIdentifier.value) in %resource.entry.resource.ofType(RequestGroup).identifier.select(system + '|' + value))"
Severity: #error

Invariant: ie-bnd-rx-9
Description: "Every eP SHALL have the prescription group's patient, prescriber and date of issue (HIQA EP 3.2; compare NHS EPS prescription-order)"
Expression: "entry.resource.ofType(MedicationRequest).all(subject.reference = %resource.entry.resource.ofType(RequestGroup).first().subject.reference and requester.reference = %resource.entry.resource.ofType(RequestGroup).first().author.reference and authoredOn = %resource.entry.resource.ofType(RequestGroup).first().authoredOn)"
Severity: #error

Invariant: ie-bnd-rx-10
Description: "The prescription group status SHOULD agree with the eP statuses: an active group has an active eP; a revoked (cancelled) group has only cancelled or stopped eP; a completed group has no active, on-hold or draft eP (HIQA EP 3.3)"
Expression: "entry.resource.ofType(RequestGroup).all((status = 'active' implies %resource.entry.resource.ofType(MedicationRequest).where(status = 'active').exists()) and (status = 'revoked' implies %resource.entry.resource.ofType(MedicationRequest).all(status = 'cancelled' or status = 'stopped')) and (status = 'completed' implies %resource.entry.resource.ofType(MedicationRequest).all(status = 'completed' or status = 'stopped' or status = 'cancelled')))"
Severity: #warning

Invariant: ie-bnd-rx-11
Description: "The prescriber's healthcare facility (the organisation of the prescriber's role) SHALL have an address with address line, county, postcode and country (HIQA EP 2.9, 2.9.1, 2.9.2, 2.9.4, 2.9.5, Mandatory)"
Expression: "entry.resource.ofType(MedicationRequest).all(requester.resolve().ofType(PractitionerRole).organization.resolve().address.where(line.exists() and state.exists() and postalCode.exists() and country.exists()).exists())"
Severity: #error

// ── eDispensations and provenance in the ePG (ADR-003, project owner 2026-10-08) ──

Invariant: ie-bnd-rx-12
Description: "Every eDispensation in the ePG SHALL be authorised by an eP in the same ePG (HIQA EP 6.5)"
Expression: "entry.resource.ofType(MedicationDispense).all(authorizingPrescription.exists() and authorizingPrescription.reference.all(($this in %resource.entry.where(resource is MedicationRequest).fullUrl) or ($this.replace('MedicationRequest/', '') in %resource.entry.resource.ofType(MedicationRequest).id)))"
Severity: #error

Invariant: ie-bnd-rx-13
Description: "Every eDispensation in the ePG SHALL be for the ePG's patient (patient safety)"
Expression: "entry.resource.ofType(MedicationDispense).all(subject.reference = %resource.entry.resource.ofType(RequestGroup).first().subject.reference)"
Severity: #error

Invariant: ie-bnd-rx-14
Description: "Every Provenance in the ePG SHOULD target resources in the same ePG"
Expression: "entry.resource.ofType(Provenance).target.reference.all(($this in %resource.entry.fullUrl) or ($this in %resource.entry.resource.select(resourceType + '/' + id)))"
Severity: #warning

