// ╭──────────────────────────────────────────────────────────────────────╮
// │  IE MPD Prescription Group Header (ADR-003)                          │
// │  The prescription-level data of an Electronic Prescription Group    │
// │  (ePG, the Bundle): HIQA EP 3.1 identifier, 3.2 date of issue,      │
// │  3.3 status, 3.4 presented form, 3.5 the eP it groups.            │
// │  An R4 Bundle cannot carry a status or extensions (it is a Resource,│
// │  not a DomainResource), so these live in this RequestGroup, one     │
// │  entry of the ePG.                                                   │
// ╰──────────────────────────────────────────────────────────────────────╯

Profile: IEMpdPrescriptionGroupHeader
Parent: RequestGroup
Id: ie-mpd-prescription-group-header
Title: "IE MPD Prescription Group Header"
Description: "The header of an Electronic Prescription Group (ePG): the group-level data HIQA EP Section 3 defines, which a Bundle cannot carry: the prescription group identifier (3.1), date and time of issue (3.2), prescription group status with reason (3.3), presented form (3.4), and the electronic prescriptions (eP) it groups (3.5, one action per MedicationRequest). One entry of the ePG Bundle (IEMpdElectronicPrescriptionGroup, ADR-003)."
* ^status = #draft
* obeys ie-grp-status-1

// ── 3.1 Electronic prescription identifier ──────────────────────────────
* identifier 1..* MS
* identifier ^short = "Prescription group identifier (HIQA EP 3.1)"
* identifier ^comment = "HIQA EP 3.1 Electronic prescription identifier (Mandatory 1..*): the prescription group identifier. Every eP in the group carries the same identifier in MedicationRequest.groupIdentifier (ie-bnd-rx-8). For a national (NePS) prescription use the NePS system; a second identifier may carry a local or long-form id (compare NHS EPS short-form and UUID prescription ids)."
* identifier.type 1..1 MS
* identifier.type ^comment = "HIQA EP 3.1.1 Electronic prescription identifier – type (Mandatory). HIQA gives no value set, so none is bound (Requires Clarification, OI-104)."
* identifier.system 1..1 MS
* identifier.value 1..1 MS
* identifier.value ^comment = "HIQA EP 3.1.2 Electronic prescription identifier – value (Mandatory)."

// ── 3.3 Prescription group status ─────────────────────────────────────────────
* status MS
* status ^comment = "HIQA EP 3.3.1 Status (Mandatory): the prescription group status. draft | active | on-hold | revoked (cancelled) | completed | entered-in-error | unknown. Kept consistent with the eP statuses (ie-bnd-rx-10)."
* extension contains IEMpdPrescriptionGroupStatusReason named statusReason 0..1 MS
* extension[statusReason] ^comment = "HIQA EP 3.3.2 Status reason (Required) and 3.3.3 free text (Optional, in CodeableConcept.text). Required unless the prescription is active, completed or draft (ie-grp-status-1)."

// ── 3.4 Presented form ──────────────────────────────────────────────────
* extension contains IEMpdPresentedForm named presentedForm 0..*
* extension[presentedForm] ^comment = "HIQA EP 3.4 Presented form (Optional): a rendered copy of the prescription, e.g. a PDF."

* intent = #order (exactly)
* intent ^comment = "An electronic prescription is an order."

// ── Patient, date of issue, prescriber ─────────────────────────────────
* subject 1..1 MS
* subject only Reference(IEMpdPatientEPrescription)
* subject ^comment = "The patient (HIQA EP Section 1). The same patient as every eP (ie-bnd-rx-9)."
* authoredOn 1..1 MS
* authoredOn ^comment = "HIQA EP 3.2 Date and time of issuing the prescription (Mandatory). Equal to authoredOn of every eP (ie-bnd-rx-9)."
* author 1..1 MS
* author only Reference(IEMpdPractitionerRole or IEMpdPractitioner)
* author ^comment = "The prescriber (HIQA EP Section 2). The same as the requester of every eP (ie-bnd-rx-9)."

// ── 3.5 The electronic prescriptions (eP) of the group ──────────────────────────────────────────────
* action 1..* MS
* action ^comment = "HIQA EP 3.5 Prescription item (Mandatory 1..*): one action per electronic prescription (eP, MedicationRequest) in the ePG, and no others (ie-bnd-rx-7)."
* action.resource 1..1 MS
* action.resource only Reference(IEMpdMedicationRequestEPrescription)
* action.action 0..0

* note ^comment = "Notes about the prescription group as a whole. Notes about one eP (HIQA EP 3.6.1) go on its MedicationRequest."

Invariant: ie-grp-status-1
Description: "A status reason SHALL be given unless the prescription is active, completed or draft (HIQA EP 3.3.2)"
Expression: "status = 'active' or status = 'completed' or status = 'draft' or extension('https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-prescription-group-status-reason').exists()"
Severity: #error


Extension: IEMpdPrescriptionGroupStatusReason
Id: ie-mpd-prescription-group-status-reason
Title: "IE MPD Prescription Group Status Reason"
Description: "Why the electronic prescription as a whole has its status, e.g. why it was cancelled (HIQA EP 3.3.2 coded reason; 3.3.3 free text in CodeableConcept.text). The R4 RequestGroup has no statusReason element, and the core request-statusReason extension does not allow RequestGroup."
Context: RequestGroup
* ^status = #draft
* value[x] only CodeableConcept
* value[x] 1..1


Extension: IEMpdPresentedForm
Id: ie-mpd-presented-form
Title: "IE MPD Presented Form"
Description: "A rendered copy of the electronic prescription as presented to people, such as a PDF (HIQA EP 3.4 Presented form, Optional)."
Context: RequestGroup
* ^status = #draft
* value[x] only Attachment
* value[x] 1..1
* valueAttachment.contentType 1..1
