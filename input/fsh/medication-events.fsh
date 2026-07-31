Alias: $SCT = http://snomed.info/sct
Alias: $LNC = http://loinc.org
Alias: $v3-ActCode = http://terminology.hl7.org/CodeSystem/v3-ActCode

CodeSystem: IEMedicationEventTypeCS
Id: ie-medication-event-type
Title: "IE Medication Event Type CodeSystem"
Description: "Placeholder codes describing medication workflow events for HL7 Ireland."
* ^status = #draft
* ^experimental = true
* #prescribed "Prescribed"
* #dispensed "Dispensed"
* #administered "Administered"
* #recorded "Recorded"

ValueSet: IEMedicationEventTypeVS
Id: ie-medication-event-type
Title: "IE Medication Event Type ValueSet"
Description: "Starter value set for medication event workflow classifications."
* ^status = #draft
* ^experimental = true
* include codes from system IEMedicationEventTypeCS

Extension: IEEPrescriptionReference
Id: ie-eprescription-reference
Title: "IE ePrescription Reference"
Description: "Carries a national ePrescription or NePS workflow reference identifier."
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "MedicationRequest"
* value[x] only Identifier
* valueIdentifier 1..1 MS

Profile: IEMedicationRequest
Parent: MedicationRequest
Id: ie-medication-request
Title: "IE Medication Request"
Description: "Starter profile for Irish medication prescribing and medication event exchange."
* ^status = #draft
* extension contains IEEPrescriptionReference named eprescriptionReference 0..1 MS
* status MS
* intent MS
* subject 1..1 MS
* encounter 0..1 MS
* authoredOn 1..1 MS
* medication[x] 1..1 MS
* category 0..* MS
* category from IEMedicationEventTypeVS (preferred)

Profile: IEMedicationObservation
Parent: Observation
Id: ie-medication-observation
Title: "IE Medication Observation"
Description: "Starter observation profile for medication administration or adherence events."
* ^status = #draft
* status 1..1 MS
* code 1..1 MS
* code from IEMedicationEventTypeVS (example)
* subject 1..1 MS
* encounter 0..1 MS
* effective[x] 1..1 MS

Instance: ExampleIEPatient
InstanceOf: Patient
Usage: #example
* id = "example-ie-patient"
* identifier.system = "https://hl7-ie.github.io/medication-events/fhir/NamingSystem/national-health-identifier"
* identifier.value = "9999999999"
* name[0].family = "Murphy"
* name[0].given[0] = "Aoife"
* gender = #female
* birthDate = "1984-03-19"

Instance: ExampleIEEncounter
InstanceOf: Encounter
Usage: #example
* id = "example-ie-encounter"
* status = #finished
* class = $v3-ActCode#AMB "ambulatory"
* subject = Reference(ExampleIEPatient)
* period.start = "2026-07-23T09:00:00+00:00"
* period.end = "2026-07-23T09:15:00+00:00"

Instance: ExampleIEMedicationRequest
InstanceOf: IEMedicationRequest
Usage: #example
* id = "example-ie-medicationrequest"
* status = #active
* intent = #order
* category[0] = IEMedicationEventTypeCS#prescribed "Prescribed"
* subject = Reference(ExampleIEPatient)
* encounter = Reference(ExampleIEEncounter)
* authoredOn = "2026-07-23"
* medicationCodeableConcept = $SCT#387517004 "Paracetamol"
* dosageInstruction[0].text = "Take one tablet twice daily as needed for pain."
* extension[eprescriptionReference].valueIdentifier.system = "https://hl7-ie.github.io/medication-events/fhir/NamingSystem/eprescription-reference"
* extension[eprescriptionReference].valueIdentifier.value = "NEPS-0001"

Instance: ExampleIEMedicationObservation
InstanceOf: IEMedicationObservation
Usage: #example
* id = "example-ie-medication-observation"
* status = #final
* code = IEMedicationEventTypeCS#administered "Administered"
* subject = Reference(ExampleIEPatient)
* encounter = Reference(ExampleIEEncounter)
* effectiveDateTime = "2026-07-23T10:00:00+00:00"
* valueString = "First supervised dose administered in clinic."
