// Electronic Prescription Group examples (ADR-003): the prescription as a whole for HIQA scenarios 1-6, and
// scenario 10, the cancellation of a whole prescription (compare NHS EPS examples B1/C1: prescription-order-update).
// All people, organisations and identifiers are fictional.

RuleSet: PrescriptionGroup(rxid, patient, authored, item)
* identifier[0].type = $V2-0203#PLAC "Placer Identifier"
* identifier[=].system = $NePS
* identifier[=].value = "{rxid}"
* intent = #order
* subject = Reference({patient})
* authoredOn = "{authored}"
* author = Reference(hiqa-role-gp-nolan)
* action[0].resource = Reference({item})

Instance: hiqa-grp-s1-acute-adult
InstanceOf: IEMpdPrescriptionGroupHeader
Usage: #example
Title: "Scenario 1 – Prescription group header: acute adult prescription"
Description: "HIQA EP Section 3 for scenario 1: identifier (3.1), date of issue (3.2), group status active (3.3) and its one eP (3.5)."
* status = #active
* insert PrescriptionGroup(9-RX-2026-000001, hiqa-patient-tomas-quinn, 2026-09-21T09:45:00+01:00, hiqa-rx-s1-amoxicillin)

Instance: hiqa-grp-s2-paediatric
InstanceOf: IEMpdPrescriptionGroupHeader
Usage: #example
Title: "Scenario 2 – Prescription group header: paediatric prescription"
Description: "HIQA EP Section 3 for scenario 2."
* status = #active
* insert PrescriptionGroup(9-RX-2026-000002, hiqa-patient-oisin-brady, 2026-09-20T10:10:00+01:00, hiqa-rx-s2-amoxicillin-paeds)

Instance: hiqa-grp-s3-repeat
InstanceOf: IEMpdPrescriptionGroupHeader
Usage: #example
Title: "Scenario 3 – Prescription group header: repeat prescription"
Description: "HIQA EP Section 3 for scenario 3. The prescription stays active while repeats remain."
* status = #active
* insert PrescriptionGroup(9-RX-2026-000003, hiqa-patient-niamh-keane, 2026-09-01T11:05:00+01:00, hiqa-rx-s3-salbutamol-repeat)

Instance: hiqa-grp-s4-controlled-drug
InstanceOf: IEMpdPrescriptionGroupHeader
Usage: #example
Title: "Scenario 4 – Prescription group header: Schedule 2 controlled drug"
Description: "HIQA EP Section 3 for scenario 4, with a rendered copy of the prescription as its presented form (HIQA EP 3.4; plain text here for brevity, typically a PDF)."
* status = #active
* insert PrescriptionGroup(9-RX-2026-000004, hiqa-patient-declan-walsh, 2026-09-15T15:10:00+01:00, hiqa-rx-s4-oxycodone)
* extension[presentedForm].valueAttachment.contentType = #text/plain
* extension[presentedForm].valueAttachment.language = #en-IE
* extension[presentedForm].valueAttachment.data = "ZVByZXNjcmlwdGlvbiA5LVJYLTIwMjYtMDAwMDA0IChwcmludGFibGUgY29weSkKUGF0aWVudDogRGVjbGFuIFdhbHNoCk94eWNvZG9uZSBoeWRyb2NobG9yaWRlIDEwIG1nIHByb2xvbmdlZC1yZWxlYXNlIHRhYmxldHMKVGhpcyBpcyBhIGZpY3Rpb25hbCBleGFtcGxlLgo="
* extension[presentedForm].valueAttachment.title = "ePrescription 9-RX-2026-000004 (printable copy)"
* extension[presentedForm].valueAttachment.creation = "2026-09-15T15:10:00+01:00"

Instance: hiqa-grp-s5-non-dispensation
InstanceOf: IEMpdPrescriptionGroupHeader
Usage: #example
Title: "Scenario 5 – Prescription group header: prescription later declined at the pharmacy"
Description: "HIQA EP Section 3 for scenario 5. The prescription itself stays active; the non-dispensation is recorded on the MedicationDispense."
* status = #active
* insert PrescriptionGroup(9-RX-2026-000005, hiqa-patient-niamh-keane, 2026-09-22T09:30:00+01:00, hiqa-rx-s5-amoxicillin)

Instance: hiqa-grp-s6-crossborder
InstanceOf: IEMpdPrescriptionGroupHeader
Usage: #example
Title: "Scenario 6 – Prescription group header: cross-border prescription with two items"
Description: "HIQA EP Section 3 for scenario 6: two electronic prescriptions (eP) issued together, sharing the prescription group identifier (HIQA EP 3.1)."
* status = #active
* insert PrescriptionGroup(9-RX-2026-000006, hiqa-patient-declan-walsh, 2026-09-16T10:00:00+01:00, hiqa-rx-s6-metformin)
* action[+].resource = Reference(hiqa-rx-s6-atorvastatin)


// ── Scenario 10: the prescriber cancels the whole prescription before it is dispensed ──

Instance: hiqa-rx-s10-amoxicillin-cancelled
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 10 – Prescription item cancelled"
Description: "The prescriber cancels the prescription before dispensing because the treatment is changed. The item is cancelled with a reason (HIQA EP 3.5.2.1 to 3.5.2.3; ie-rx-status-1)."
* identifier[0].system = $NePS
* identifier[=].value = "9-RX-2026-000010-1"
* groupIdentifier.system = $NePS
* groupIdentifier.value = "9-RX-2026-000010"
* status = #cancelled
* statusReason = http://terminology.hl7.org/CodeSystem/medicationrequest-status-reason#altchoice "Try another treatment first"
* statusReason.text = "Cancelled by the prescriber: treatment changed after review"
* intent = #order
* courseOfTherapyType = http://terminology.hl7.org/CodeSystem/medicationrequest-course-of-therapy#acute "Short course (acute) therapy"
* medicationReference = Reference(hiqa-med-amoxicillin-500-caps)
* subject = Reference(hiqa-patient-tomas-quinn)
* supportingInformation = Reference(hiqa-allergies-tomas-nilknown)
* authoredOn = "2026-09-23T10:00:00+01:00"
* requester = Reference(hiqa-role-gp-nolan)
* reasonCode = $SCTIE#15805002 "Acute sinusitis"
* dosageInstruction[0].text = "Take one capsule three times a day for 7 days"
* dosageInstruction[=].timing.repeat.frequency = 3
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].timing.repeat.boundsDuration = 7 'd' "days"
* dosageInstruction[=].route = $SCTIE#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 1 $SCT#732937005 "Capsule"
* dispenseRequest.quantity = 21 $SCT#732937005 "Capsule"
* dispenseRequest.validityPeriod.start = "2026-09-23"
* dispenseRequest.validityPeriod.end = "2026-10-23"
* dispenseRequest.numberOfRepeatsAllowed = 0
* substitution.allowedBoolean = true

Instance: hiqa-grp-s10-cancelled
InstanceOf: IEMpdPrescriptionGroupHeader
Usage: #example
Title: "Scenario 10 – Prescription group header: cancelled (revoked) prescription"
Description: "The whole prescription is cancelled: status revoked with the reason (HIQA EP 3.3.1 to 3.3.3; ie-grp-status-1). Its only eP is cancelled, so the statuses agree (ie-bnd-rx-10)."
* status = #revoked
* extension[statusReason].valueCodeableConcept = http://terminology.hl7.org/CodeSystem/medicationrequest-status-reason#altchoice "Try another treatment first"
* extension[statusReason].valueCodeableConcept.text = "Cancelled by the prescriber: treatment changed after review"
* insert PrescriptionGroup(9-RX-2026-000010, hiqa-patient-tomas-quinn, 2026-09-23T10:00:00+01:00, hiqa-rx-s10-amoxicillin-cancelled)

Instance: hiqa-bundle-s10-cancelled
InstanceOf: IEMpdElectronicPrescriptionGroup
Usage: #example
Title: "Scenario 10 – Electronic Prescription Group (ePG): cancelled prescription"
Description: "The prescription after cancellation: the group is revoked with a reason and its eP is cancelled with a reason."
* identifier.system = $NePS
* identifier.value = "9-RX-2026-000010"
* type = #collection
* timestamp = "2026-09-23T14:20:00+01:00"
* insert HIQAEntry(Patient, hiqa-patient-tomas-quinn)
* insert HIQAEntry(RequestGroup, hiqa-grp-s10-cancelled)
* insert HIQAEntry(MedicationRequest, hiqa-rx-s10-amoxicillin-cancelled)
* insert HIQAEntry(List, hiqa-allergies-tomas-nilknown)
* insert HIQAEntry(PractitionerRole, hiqa-role-gp-nolan)
* insert HIQAEntry(Practitioner, hiqa-prac-gp-nolan)
* insert HIQAEntry(Organization, hiqa-org-gp-practice)
* insert HIQAEntry(Medication, hiqa-med-amoxicillin-500-caps)
