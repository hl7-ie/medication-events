// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/examples/HIQAScenarios.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

RuleSet: HIQAEntry(type, id)
* entry[+].fullUrl = "http://example.org/fhir/{type}/{id}"
* entry[=].resource = {id}



// ====================================================================
// SHARED ACTORS: GP practice, prescriber, pharmacy, pharmacist
// ====================================================================

Instance: hiqa-prac-gp-nolan
InstanceOf: IEMpdPractitioner
Usage: #example
Title: "HIQA scenarios – Dr Clodagh Nolan (GP, fictional)"
Description: "Fictional general practitioner, the prescriber in the HIQA scenarios (HIQA EP Section 2)."
* identifier[IMC].value = "999001"
* active = true
* name[0].use = #official
* name[=].family = "Nolan"
* name[=].given = "Clodagh"
* name[=].prefix = "Dr"
* telecom[0].system = #phone
* telecom[=].value = "+353 90 000 0001"
* telecom[=].use = #work


Instance: hiqa-org-gp-practice
InstanceOf: IEMpdOrganization
Usage: #example
Title: "HIQA scenarios – Riverside Family Practice (fictional)"
Description: "Fictional GP practice: the prescriber's facility (HIQA EP 2.7–2.12), with a GMS Panel ID (EP 2.12)."
* identifier[GMSPanel].value = "99001"
* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Riverside Family Practice"
* telecom[0].system = #phone
* telecom[=].value = "+353 90 000 0000"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "prescriptions@riverside-practice.example.org"
* telecom[=].use = #work
* address[0].use = #work
* address[=].type = #physical
* address[=].line = "1 River Road"
* address[=].city = "Athlone"
* address[=].state = "Westmeath"
* address[=].postalCode = "N37 XX01"
* address[=].country = "IE"


Instance: hiqa-role-gp-nolan
InstanceOf: IEMpdPractitionerRole
Usage: #example
Title: "HIQA scenarios – Dr Clodagh Nolan at Riverside Family Practice"
Description: "The prescriber's role and contact details (HIQA EP 2.5, 2.10.1 telephone, 2.10.2 secure email)."
* active = true
* practitioner = Reference(hiqa-prac-gp-nolan) "Dr Clodagh Nolan"
* organization = Reference(hiqa-org-gp-practice) "Riverside Family Practice"
* telecom[0].system = #phone
* telecom[=].value = "+353 90 000 0001"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "clodagh.nolan@riverside-practice.example.org"
* telecom[=].use = #work


Instance: hiqa-org-pharmacy
InstanceOf: IEMpdOrganization
Usage: #example
Title: "HIQA scenarios – Bridge Street Pharmacy (fictional)"
Description: "Fictional community pharmacy with a PSI Retail Pharmacy Business registration number (HIQA EP 2.8)."
* identifier[PSIRPB].value = "9991"
* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Bridge Street Pharmacy"
* telecom[0].system = #phone
* telecom[=].value = "+353 90 000 0100"
* telecom[=].use = #work
* address[0].use = #work
* address[=].line = "5 Bridge Street"
* address[=].city = "Athlone"
* address[=].state = "Westmeath"
* address[=].postalCode = "N37 XX02"
* address[=].country = "IE"


Instance: hiqa-prac-pharmacist-farrell
InstanceOf: IEMpdPractitioner
Usage: #example
Title: "HIQA scenarios – Eoin Farrell (pharmacist, fictional)"
Description: "Fictional registered pharmacist with a PSI registration number (HIQA EP 2.6.2)."
* identifier[PSI].value = "99901"
* active = true
* name[0].use = #official
* name[=].family = "Farrell"
* name[=].given = "Eoin"
* telecom[0].system = #phone
* telecom[=].value = "+353 90 000 0100"
* telecom[=].use = #work



// ====================================================================
// PATIENTS (ePrescription dataset only: IE Core ADR-002)
// ====================================================================

Instance: hiqa-patient-tomas-quinn
InstanceOf: IEMpdPatientEPrescription
Usage: #example
Title: "HIQA scenarios – Tomás Quinn (adult, fictional)"
Description: "Adult patient for scenario 1 (acute prescription). Only the HIQA EP Section 1 dataset: no ethnicity, nationality or mother's maiden name."
* identifier[0].system = $IHI
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "999000000000000001"
* insert PCRSIdentifier($GMS, medical-card, Medical card scheme number, 9900001A)
* name[0].use = #official
* name[=].family = "Quinn"
* name[=].given = "Tomás"
* gender = #male
* insert SexAssignedAtBirth(male, Male)
* birthDate = "1979-06-21"
* address[0].use = #home
* address[=].line = "12 Shannon View"
* address[=].city = "Athlone"
* address[=].state = "Westmeath"
* address[=].postalCode = "N37 XX10"
* address[=].country = "IE"


Instance: hiqa-patient-oisin-brady
InstanceOf: IEMpdPatientEPrescription
Usage: #example
Title: "HIQA scenarios – Oisín Brady (5 years old, fictional)"
Description: "Paediatric patient for scenario 2. Under 12 at the date of prescribing, so the prescription must state the age (HIQA EP 1.4.2)."
* identifier[0].system = $IHI
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "999000000000000002"
* name[0].use = #official
* name[=].family = "Brady"
* name[=].given = "Oisín"
* gender = #male
* insert SexAssignedAtBirth(male, Male)
* birthDate = "2021-03-02"
* address[0].use = #home
* address[=].line = "3 Church Lane"
* address[=].city = "Moate"
* address[=].state = "Westmeath"
* address[=].postalCode = "N37 XX11"
* address[=].country = "IE"


Instance: hiqa-patient-niamh-keane
InstanceOf: IEMpdPatientEPrescription
Usage: #example
Title: "HIQA scenarios – Niamh Keane (adult with asthma and penicillin allergy, fictional)"
Description: "Adult patient for scenarios 3 (repeat) and 5 (non-dispensation)."
* identifier[0].system = $IHI
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "999000000000000003"
* name[0].use = #official
* name[=].family = "Keane"
* name[=].given = "Niamh"
* gender = #female
* insert SexAssignedAtBirth(female, Female)
* birthDate = "1990-11-08"
* address[0].use = #home
* address[=].line = "27 Abbey Road"
* address[=].city = "Athlone"
* address[=].state = "Westmeath"
* address[=].postalCode = "N37 XX12"
* address[=].country = "IE"
* telecom[0].system = #phone
* telecom[=].value = "+353 87 000 0003"
* telecom[=].use = #mobile


Instance: hiqa-patient-declan-walsh
InstanceOf: IEMpdPatientEPrescription
Usage: #example
Title: "HIQA scenarios – Declan Walsh (adult, fictional)"
Description: "Adult patient for scenarios 4 (controlled drug) and 6 (cross-border)."
* identifier[0].system = $IHI
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "999000000000000004"
* name[0].use = #official
* name[=].family = "Walsh"
* name[=].given = "Declan"
* gender = #male
* insert SexAssignedAtBirth(male, Male)
* birthDate = "1961-11-30"
* address[0].use = #home
* address[=].line = "8 Mill Street"
* address[=].city = "Athlone"
* address[=].state = "Westmeath"
* address[=].postalCode = "N37 XX13"
* address[=].country = "IE"



// ====================================================================
// MEDICINAL PRODUCTS (HIQA EP Section 4)
// ====================================================================

Instance: hiqa-med-amoxicillin-500-caps
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "HIQA scenarios – Amoxicillin 500 mg oral capsule"
Description: "International SNOMED CT product code and the NMPC VMP (SNOMED CT Irish Edition, verified in the NMPC Meds Catalogue); ATC classification and supply legal status (HIQA EP 4.2)."
* code = $SCTIE#323510009 "Amoxicillin 500 mg oral capsule"
* code.coding[+] = $SCTIE#716141000220105 "Amoxicillin 500 mg oral capsule"
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.text = "Amoxicillin 500 mg capsules"
* extension[classification][0].valueCodeableConcept = $ATC#J01CA04 "amoxicillin"
* extension[classification][+].valueCodeableConcept = IEMpdSupplyLegalStatus#prescription-only "Prescription only medicine"
* form = $SCTIE#385049006 "Capsule"
* ingredient[0].itemCodeableConcept = $SCTIE#372687004 "Amoxicillin"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 500 'mg' "mg"
* ingredient[=].strength.denominator = 1 $SCT#732937005 "Capsule"


Instance: hiqa-med-amoxicillin-50mgml-susp
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "HIQA scenarios – Amoxicillin 50 mg/mL oral suspension"
Description: "Paediatric oral suspension (scenario 2)."
* code = $SCTIE#1148466008 "Amoxicillin 50 mg/mL oral suspension"
* code.coding[+] = $SCTIE#462991000220107 "Amoxicillin 250 mg/5 mL powder for oral suspension"
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.text = "Amoxicillin 250 mg/5 mL oral suspension"
* extension[classification][0].valueCodeableConcept = $ATC#J01CA04 "amoxicillin"
* extension[classification][+].valueCodeableConcept = IEMpdSupplyLegalStatus#prescription-only "Prescription only medicine"
* form = $SCTIE#385024007 "Oral suspension"
* ingredient[0].itemCodeableConcept = $SCTIE#372687004 "Amoxicillin"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 50 'mg' "mg"
* ingredient[=].strength.denominator = 1 'mL' "mL"


Instance: hiqa-med-salbutamol-inhaler
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "HIQA scenarios – Salbutamol 100 micrograms/actuation pressurised inhaler"
Description: "Repeat medication (scenarios 3 and 7). SNOMED CT uses the USAN name albuterol."
* code = $SCTIE#770300007 "Albuterol (as albuterol sulfate) 100 microgram/actuation pressurized suspension for inhalation"
* code.coding[+] = $SCTIE#363291000220101 "Salbutamol 100 microgram/actuation pressurised suspension for inhalation"
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.text = "Salbutamol 100 micrograms/dose pressurised inhalation suspension"
* extension[classification][0].valueCodeableConcept = $ATC#R03AC02 "salbutamol"
* form = $SCTIE#385205001 "Pressurized suspension for inhalation"
* amount.numerator = 200 $SCT#732981002 "Actuation"
* amount.denominator = 1 '{inhaler}' "inhaler"
* ingredient[0].itemCodeableConcept = $SCTIE#372897005 "Albuterol"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 100 'ug' "microgram"
* ingredient[=].strength.denominator = 1 $SCT#732981002 "Actuation"


Instance: hiqa-med-oxycodone-10-pr
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "HIQA scenarios – Oxycodone hydrochloride 10 mg prolonged-release tablet (Schedule 2)"
Description: "Controlled drug (scenario 4). The MDA schedule (HIQA EP 4.2.3) uses the IEMpdMDASchedule placeholder code system (Requires Clarification, IE Core OI-007); it drives invariants ie-rx-cd-1 and ie-rx-cd-2."
* code = $SCTIE#765706002 "Oxycodone hydrochloride 10 mg prolonged-release oral tablet"
* code.coding[+] = $SCTIE#720411000220105 "Oxycodone hydrochloride 10 mg prolonged-release oral tablet"
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.text = "Oxycodone hydrochloride 10 mg prolonged-release tablets"
* extension[classification][0].valueCodeableConcept = $ATC#N02AA05 "oxycodone"
* extension[classification][+].valueCodeableConcept = IEMpdMDASchedule#schedule-2 "Schedule 2"
* extension[classification][+].valueCodeableConcept = IEMpdSupplyLegalStatus#prescription-only "Prescription only medicine"
* form = $SCTIE#385060002 "Prolonged-release oral tablet"
* ingredient[0].itemCodeableConcept = $SCTIE#387024006 "Oxycodone hydrochloride"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 10 'mg' "mg"
* ingredient[=].strength.denominator = 1 $SCT#732936001 "Tablet"



// ====================================================================
// ALLERGY STATEMENTS (HIQA EP 1.6.1 / 1.6.2)
// ====================================================================

Instance: hiqa-allergies-tomas-nilknown
InstanceOf: IEMpdListAllergiesAtPrescribing
Usage: #example
Title: "HIQA scenarios – Allergy statement: no known allergies (Tomás Quinn)"
Description: "HIQA EP 1.6.1: no allergies recorded because the patient has none known (nilknown), which is different from 'not asked'."
* status = #current
* mode = #snapshot
* subject = Reference(hiqa-patient-tomas-quinn)
* date = "2026-09-21T09:40:00+01:00"
* source = Reference(hiqa-role-gp-nolan)
* emptyReason = http://terminology.hl7.org/CodeSystem/list-empty-reason#nilknown "Nil Known"


Instance: hiqa-allergies-oisin-nilknown
InstanceOf: IEMpdListAllergiesAtPrescribing
Usage: #example
Title: "HIQA scenarios – Allergy statement: no known allergies (Oisín Brady)"
Description: "HIQA EP 1.6.1, confirmed with the child's parent at the consultation."
* status = #current
* mode = #snapshot
* subject = Reference(hiqa-patient-oisin-brady)
* date = "2026-09-20T10:05:00+01:00"
* source = Reference(hiqa-role-gp-nolan)
* emptyReason = http://terminology.hl7.org/CodeSystem/list-empty-reason#nilknown "Nil Known"


Instance: hiqa-allergy-niamh-penicillin
InstanceOf: IEMpdAllergyIntolerance
Usage: #example
Title: "HIQA scenarios – Allergy to penicillin (Niamh Keane)"
Description: "HIQA EP 1.6.2 / PS 5.3: confirmed penicillin allergy with anaphylaxis."
* clinicalStatus = http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical#active "Active"
* verificationStatus = http://terminology.hl7.org/CodeSystem/allergyintolerance-verification#confirmed "Confirmed"
* type = #allergy
* category = #medication
* criticality = #high
* code = $SCTIE#91936005 "Allergy to penicillin"
* patient = Reference(hiqa-patient-niamh-keane)
* recordedDate = "2015-04-10"
* recorder = Reference(hiqa-prac-gp-nolan)
* reaction[0].manifestation = $SCTIE#39579001 "Anaphylaxis"
* reaction[=].severity = #severe


Instance: hiqa-allergies-niamh
InstanceOf: IEMpdListAllergiesAtPrescribing
Usage: #example
Title: "HIQA scenarios – Allergy statement listing penicillin allergy (Niamh Keane)"
Description: "HIQA EP 1.6.2: the allergy statement lists the recorded allergies."
* status = #current
* mode = #snapshot
* subject = Reference(hiqa-patient-niamh-keane)
* date = "2026-09-01T11:00:00+01:00"
* source = Reference(hiqa-role-gp-nolan)
* entry[0].item = Reference(hiqa-allergy-niamh-penicillin)


Instance: hiqa-allergies-declan-nilknown
InstanceOf: IEMpdListAllergiesAtPrescribing
Usage: #example
Title: "HIQA scenarios – Allergy statement: no known allergies (Declan Walsh)"
Description: "HIQA EP 1.6.1."
* status = #current
* mode = #snapshot
* subject = Reference(hiqa-patient-declan-walsh)
* date = "2026-09-15T15:00:00+01:00"
* source = Reference(hiqa-role-gp-nolan)
* emptyReason = http://terminology.hl7.org/CodeSystem/list-empty-reason#nilknown "Nil Known"



// ====================================================================
// SCENARIO 1: acute adult prescription and dispense
// ====================================================================

Instance: hiqa-rx-s1-amoxicillin
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 1 – Acute prescription: amoxicillin 500 mg for acute sinusitis"
Description: "Single-item acute prescription (HIQA EP Section 3)."
* identifier[0].system = $NePS
* identifier[=].value = "9-RX-2026-000001-1"
* groupIdentifier.system = $NePS
* groupIdentifier.value = "9-RX-2026-000001"
* status = #active
* intent = #order
* courseOfTherapyType = http://terminology.hl7.org/CodeSystem/medicationrequest-course-of-therapy#acute "Short course (acute) therapy"
* medicationReference = Reference(hiqa-med-amoxicillin-500-caps)
* subject = Reference(hiqa-patient-tomas-quinn)
* supportingInformation = Reference(hiqa-allergies-tomas-nilknown)
* authoredOn = "2026-09-21T09:45:00+01:00"
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
* dispenseRequest.validityPeriod.start = "2026-09-21"
* dispenseRequest.validityPeriod.end = "2026-10-21"
* dispenseRequest.numberOfRepeatsAllowed = 0
* substitution.allowedBoolean = true


Instance: hiqa-md-s1-amoxicillin
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 1 – Dispense: amoxicillin 500 mg, completed"
Description: "Completed dispensation (HIQA EP Section 6) handed to the patient."
* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:180c4a4b-b747-5d0d-8816-2323dc03cc87"
* extension[recorded].valueDateTime = "2026-09-21T11:20:00+01:00"
* status = #completed
* medicationReference = Reference(hiqa-med-amoxicillin-500-caps)
* subject = Reference(hiqa-patient-tomas-quinn)
* performer[0].actor = Reference(hiqa-prac-pharmacist-farrell)
* performer[+].actor = Reference(hiqa-org-pharmacy)
* authorizingPrescription = Reference(hiqa-rx-s1-amoxicillin)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#FF "First Fill"
* quantity = 21 $SCT#732937005 "Capsule"
* whenHandedOver = "2026-09-21T11:15:00+01:00"
* receiver = Reference(hiqa-patient-tomas-quinn)
* dosageInstruction[0].text = "Take one capsule three times a day for 7 days"
* substitution.wasSubstituted = false


Instance: hiqa-provenance-s1-dispense
InstanceOf: IEMpdProvenance
Usage: #example
Title: "Scenario 1 – Dispensing provenance"
Description: "Who dispensed scenario 1, on behalf of which pharmacy, and when: carried in the ePG with the eDispensation it describes (ADR-003)."
* target = Reference(hiqa-md-s1-amoxicillin)
* recorded = "2026-09-21T11:16:00+01:00"
* activity = http://terminology.hl7.org/CodeSystem/v3-DataOperation#CREATE "create"
* agent[0].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#performer "Performer"
* agent[=].who = Reference(hiqa-prac-pharmacist-farrell)
* agent[=].onBehalfOf = Reference(hiqa-org-pharmacy)


Instance: hiqa-bundle-s1-acute-adult
InstanceOf: IEMpdElectronicPrescriptionGroup
Usage: #example
Title: "Scenario 1 – Electronic Prescription Group (ePG): acute adult prescription"
Description: "HIQA EP: patient, prescriber, facility, medicinal product, allergy statement (nilknown) and one prescription item."
* identifier.system = $NePS
* identifier.value = "9-RX-2026-000001"
* type = #collection
* timestamp = "2026-09-21T09:45:00+01:00"
* insert HIQAEntry(Patient, hiqa-patient-tomas-quinn)
* insert HIQAEntry(RequestGroup, hiqa-grp-s1-acute-adult)
* insert HIQAEntry(MedicationRequest, hiqa-rx-s1-amoxicillin)
* insert HIQAEntry(List, hiqa-allergies-tomas-nilknown)
* insert HIQAEntry(PractitionerRole, hiqa-role-gp-nolan)
* insert HIQAEntry(Practitioner, hiqa-prac-gp-nolan)
* insert HIQAEntry(Organization, hiqa-org-gp-practice)
* insert HIQAEntry(Medication, hiqa-med-amoxicillin-500-caps)
* insert HIQAEntry(MedicationDispense, hiqa-md-s1-amoxicillin)
* insert HIQAEntry(Provenance, hiqa-provenance-s1-dispense)
* insert HIQAEntry(Practitioner, hiqa-prac-pharmacist-farrell)
* insert HIQAEntry(Organization, hiqa-org-pharmacy)


// ====================================================================
// SCENARIO 2: paediatric (under 12) prescription
// ====================================================================

Instance: hiqa-weight-oisin
InstanceOf: IEMpdBodyWeight
Usage: #example
Title: "Scenario 2 – Body weight 19 kg (Oisín Brady)"
Description: "HIQA EP 1.6.3 Weight: supports weight-based paediatric dosing."
* status = #final
* subject = Reference(hiqa-patient-oisin-brady)
* effectiveDateTime = "2026-09-20T10:00:00+01:00"
* performer = Reference(hiqa-role-gp-nolan)
* valueQuantity = 19 'kg' "kg"


Instance: hiqa-rx-s2-amoxicillin-paeds
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 2 – Paediatric prescription: amoxicillin suspension for acute otitis media"
Description: "The patient is 5 years old: the age at prescribing is recorded (HIQA EP 1.4.2; legal requirement under 12; invariants ie-rx-age-1 and ie-bnd-rx-3). The weight is referenced as supporting information (EP 1.6.3)."
* identifier[0].system = $NePS
* identifier[=].value = "9-RX-2026-000002-1"
* groupIdentifier.system = $NePS
* groupIdentifier.value = "9-RX-2026-000002"
* extension[ageAtPrescribing].valueAge = 5 'a' "years"
* status = #active
* intent = #order
* courseOfTherapyType = http://terminology.hl7.org/CodeSystem/medicationrequest-course-of-therapy#acute "Short course (acute) therapy"
* medicationReference = Reference(hiqa-med-amoxicillin-50mgml-susp)
* subject = Reference(hiqa-patient-oisin-brady)
* supportingInformation[0] = Reference(hiqa-allergies-oisin-nilknown)
* supportingInformation[+] = Reference(hiqa-weight-oisin)
* authoredOn = "2026-09-20T10:10:00+01:00"
* requester = Reference(hiqa-role-gp-nolan)
* reasonCode = $SCTIE#3110003 "Acute otitis media"
* dosageInstruction[0].text = "Give 5 mL (250 mg) three times a day for 5 days"
* dosageInstruction[=].patientInstruction = "Shake the bottle well. Use the oral syringe provided."
* dosageInstruction[=].timing.repeat.frequency = 3
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].timing.repeat.boundsDuration = 5 'd' "days"
* dosageInstruction[=].route = $SCTIE#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 5 'mL' "mL"
* dispenseRequest.quantity = 100 'mL' "mL"
* dispenseRequest.validityPeriod.start = "2026-09-20"
* dispenseRequest.validityPeriod.end = "2026-10-20"
* substitution.allowedBoolean = true


Instance: hiqa-bundle-s2-paediatric
InstanceOf: IEMpdElectronicPrescriptionGroup
Usage: #example
Title: "Scenario 2 – Electronic Prescription Group (ePG): paediatric prescription (under 12)"
Description: "Enforces the legal requirement to state the age of a child under 12 (ie-bnd-rx-3)."
* identifier.system = $NePS
* identifier.value = "9-RX-2026-000002"
* type = #collection
* timestamp = "2026-09-20T10:10:00+01:00"
* insert HIQAEntry(Patient, hiqa-patient-oisin-brady)
* insert HIQAEntry(RequestGroup, hiqa-grp-s2-paediatric)
* insert HIQAEntry(MedicationRequest, hiqa-rx-s2-amoxicillin-paeds)
* insert HIQAEntry(List, hiqa-allergies-oisin-nilknown)
* insert HIQAEntry(Observation, hiqa-weight-oisin)
* insert HIQAEntry(PractitionerRole, hiqa-role-gp-nolan)
* insert HIQAEntry(Practitioner, hiqa-prac-gp-nolan)
* insert HIQAEntry(Organization, hiqa-org-gp-practice)
* insert HIQAEntry(Medication, hiqa-med-amoxicillin-50mgml-susp)



// ====================================================================
// SCENARIO 3: repeat prescription with part fill, balance and repeat
// ====================================================================

Instance: hiqa-rx-s3-salbutamol-repeat
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 3 – Repeat prescription: salbutamol inhaler (5 repeats)"
Description: "Continuous therapy with repeats (HIQA EP 3.5.11), a minimum dispense interval (EP 3.5.13) and the overall prescribed quantity (EP 3.5.7.1). Repeats already dispensed are derived from the MedicationDispense records (IE Core ADR-003)."
* identifier[0].system = $NePS
* identifier[=].value = "9-RX-2026-000003-1"
* groupIdentifier.system = $NePS
* groupIdentifier.value = "9-RX-2026-000003"
* status = #active
* intent = #order
* courseOfTherapyType = http://terminology.hl7.org/CodeSystem/medicationrequest-course-of-therapy#continuous "Continuous long term therapy"
* medicationReference = Reference(hiqa-med-salbutamol-inhaler)
* subject = Reference(hiqa-patient-niamh-keane)
* supportingInformation = Reference(hiqa-allergies-niamh)
* authoredOn = "2026-09-01T11:05:00+01:00"
* requester = Reference(hiqa-role-gp-nolan)
* reasonCode = $SCTIE#195967001 "Asthma"
* extension[effectiveDosePeriod].valuePeriod.start = "2026-09-01"
* extension[effectiveDosePeriod].valuePeriod.end = "2027-02-28"
* dosageInstruction[0].text = "Inhale two puffs when required for breathlessness. Maximum 8 puffs in 24 hours"
* dosageInstruction[=].asNeededBoolean = true
* dosageInstruction[=].route = $SCTIE#447694001 "Respiratory tract route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 2 $SCT#732981002 "Actuation"
* dosageInstruction[=].maxDosePerPeriod.numerator = 8 $SCT#732981002 "Actuation"
* dosageInstruction[=].maxDosePerPeriod.denominator = 24 'h' "hours"
* dispenseRequest.extension[prescribedQuantity].valueQuantity = 12 '{inhaler}' "inhalers"
* dispenseRequest.quantity = 2 '{inhaler}' "inhalers"
* dispenseRequest.numberOfRepeatsAllowed = 5
* dispenseRequest.dispenseInterval = 21 'd' "days"
* dispenseRequest.validityPeriod.start = "2026-09-01"
* dispenseRequest.validityPeriod.end = "2027-02-28"
* substitution.allowedBoolean = true


Instance: hiqa-md-s3-part-fill
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 3 – Dispense 1: part fill (1 of 2 inhalers)"
Description: "First supply, part filled because of stock (v3-ActCode FFP)."
* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:9c2571bf-6251-50cd-9a49-d5e545fdc6ae"
* extension[recorded].valueDateTime = "2026-09-01T16:00:00+01:00"
* status = #completed
* medicationReference = Reference(hiqa-med-salbutamol-inhaler)
* subject = Reference(hiqa-patient-niamh-keane)
* performer[0].actor = Reference(hiqa-prac-pharmacist-farrell)
* authorizingPrescription = Reference(hiqa-rx-s3-salbutamol-repeat)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#FFP "First Fill - Part Fill"
* quantity = 1 '{inhaler}' "inhaler"
* whenHandedOver = "2026-09-01T15:55:00+01:00"
* dosageInstruction[0].text = "Inhale two puffs when required for breathlessness. Maximum 8 puffs in 24 hours"
* note.text = "Part supply: 1 of 2 inhalers. Balance owed to the patient."


Instance: hiqa-md-s3-balance
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 3 – Dispense 2: balance of the first supply"
Description: "Completes the first supply (v3-ActCode FFC)."
* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:b5ed5f15-a819-5839-943f-9ad861c2e7ae"
* extension[recorded].valueDateTime = "2026-09-03T10:30:00+01:00"
* status = #completed
* medicationReference = Reference(hiqa-med-salbutamol-inhaler)
* subject = Reference(hiqa-patient-niamh-keane)
* performer[0].actor = Reference(hiqa-prac-pharmacist-farrell)
* authorizingPrescription = Reference(hiqa-rx-s3-salbutamol-repeat)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#FFC "First Fill - Complete"
* quantity = 1 '{inhaler}' "inhaler"
* whenHandedOver = "2026-09-03T10:25:00+01:00"
* dosageInstruction[0].text = "Inhale two puffs when required for breathlessness. Maximum 8 puffs in 24 hours"


Instance: hiqa-md-s3-repeat-1
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 3 – Dispense 3: first repeat"
Description: "First repeat, after the minimum dispense interval (v3-ActCode RF). Repeats dispensed so far: 1 of 5 (derived)."
* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:18dc416f-384b-51b4-a91d-b688c67c9840"
* extension[recorded].valueDateTime = "2026-09-23T12:00:00+01:00"
* status = #completed
* medicationReference = Reference(hiqa-med-salbutamol-inhaler)
* subject = Reference(hiqa-patient-niamh-keane)
* performer[0].actor = Reference(hiqa-prac-pharmacist-farrell)
* authorizingPrescription = Reference(hiqa-rx-s3-salbutamol-repeat)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#RF "Refill"
* quantity = 2 '{inhaler}' "inhalers"
* whenHandedOver = "2026-09-23T11:55:00+01:00"
* dosageInstruction[0].text = "Inhale two puffs when required for breathlessness. Maximum 8 puffs in 24 hours"


Instance: hiqa-bundle-s3-repeat
InstanceOf: IEMpdElectronicPrescriptionGroup
Usage: #example
Title: "Scenario 3 – Electronic Prescription Group (ePG): repeat prescription"
Description: "The allergy statement lists a confirmed penicillin allergy (EP 1.6.2)."
* identifier.system = $NePS
* identifier.value = "9-RX-2026-000003"
* type = #collection
* timestamp = "2026-09-01T11:05:00+01:00"
* insert HIQAEntry(Patient, hiqa-patient-niamh-keane)
* insert HIQAEntry(RequestGroup, hiqa-grp-s3-repeat)
* insert HIQAEntry(MedicationRequest, hiqa-rx-s3-salbutamol-repeat)
* insert HIQAEntry(List, hiqa-allergies-niamh)
* insert HIQAEntry(AllergyIntolerance, hiqa-allergy-niamh-penicillin)
* insert HIQAEntry(PractitionerRole, hiqa-role-gp-nolan)
* insert HIQAEntry(Practitioner, hiqa-prac-gp-nolan)
* insert HIQAEntry(Organization, hiqa-org-gp-practice)
* insert HIQAEntry(Medication, hiqa-med-salbutamol-inhaler)
* insert HIQAEntry(MedicationDispense, hiqa-md-s3-part-fill)
* insert HIQAEntry(MedicationDispense, hiqa-md-s3-balance)
* insert HIQAEntry(MedicationDispense, hiqa-md-s3-repeat-1)
* insert HIQAEntry(Practitioner, hiqa-prac-pharmacist-farrell)
* insert HIQAEntry(Organization, hiqa-org-pharmacy)


// ====================================================================
// SCENARIO 4: controlled drug (Schedule 2), instalments
// ====================================================================

Instance: hiqa-rx-s4-oxycodone
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 4 – Controlled drug: oxycodone 10 mg prolonged-release (Schedule 2)"
Description: "Misuse of Drugs Regulations 2017 requirements as cited by HIQA: quantity in words and figures (EP 3.5.7.2), number of instalments (EP 3.5.12) and validity of no more than 14 days (EP 3.5.9.1). Invariants ie-rx-cd-1 and ie-rx-cd-2. 'Do Not Substitute' with a reason (EP 3.5.10.2/3)."
* identifier[0].system = $NePS
* identifier[=].value = "9-RX-2026-000004-1"
* groupIdentifier.system = $NePS
* groupIdentifier.value = "9-RX-2026-000004"
* extension[quantityInWordsAndFigures].valueString = "Twenty-eight (28) tablets"
* status = #active
* intent = #order
* courseOfTherapyType = http://terminology.hl7.org/CodeSystem/medicationrequest-course-of-therapy#continuous "Continuous long term therapy"
* medicationReference = Reference(hiqa-med-oxycodone-10-pr)
* subject = Reference(hiqa-patient-declan-walsh)
* supportingInformation = Reference(hiqa-allergies-declan-nilknown)
* authoredOn = "2026-09-15T15:10:00+01:00"
* requester = Reference(hiqa-role-gp-nolan)
* reasonCode = $SCTIE#82423001 "Chronic pain"
* dosageInstruction[0].text = "Take one tablet every 12 hours. Swallow whole; do not crush or chew"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 12
* dosageInstruction[=].timing.repeat.periodUnit = #h
* dosageInstruction[=].route = $SCTIE#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 1 $SCT#732936001 "Tablet"
* dispenseRequest.extension[prescribedQuantity].valueQuantity = 28 $SCT#732936001 "Tablet"
* dispenseRequest.extension[numberOfInstalments].valuePositiveInt = 2
* dispenseRequest.quantity = 14 $SCT#732936001 "Tablet"
* dispenseRequest.dispenseInterval = 7 'd' "days"
* dispenseRequest.validityPeriod.start = "2026-09-15"
* dispenseRequest.validityPeriod.end = "2026-09-29"
* dispenseRequest.numberOfRepeatsAllowed = 0
* substitution.allowedBoolean = false
* substitution.reason.text = "Prolonged-release opioid: keep the same brand to avoid differences in release profile"


Instance: hiqa-md-s4-instalment-1
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 4 – Dispense: instalment 1 of 2 (14 tablets)"
Description: "First instalment of a Schedule 2 controlled drug."
* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:d8cf455d-96e1-501f-bc6e-c77571385620"
* extension[recorded].valueDateTime = "2026-09-15T17:30:00+01:00"
* status = #completed
* medicationReference = Reference(hiqa-med-oxycodone-10-pr)
* subject = Reference(hiqa-patient-declan-walsh)
* performer[0].actor = Reference(hiqa-prac-pharmacist-farrell)
* authorizingPrescription = Reference(hiqa-rx-s4-oxycodone)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#FFP "First Fill - Part Fill"
* quantity = 14 $SCT#732936001 "Tablet"
* whenHandedOver = "2026-09-15T17:25:00+01:00"
* dosageInstruction[0].text = "Take one tablet every 12 hours. Swallow whole; do not crush or chew"
* substitution.wasSubstituted = false
* note.text = "Instalment 1 of 2. Next instalment due on or after 22/09/2026."


Instance: hiqa-bundle-s4-controlled-drug
InstanceOf: IEMpdElectronicPrescriptionGroup
Usage: #example
Title: "Scenario 4 – Electronic Prescription Group (ePG): controlled drug"
Description: "Schedule 2 controlled-drug prescription."
* identifier.system = $NePS
* identifier.value = "9-RX-2026-000004"
* type = #collection
* timestamp = "2026-09-15T15:10:00+01:00"
* insert HIQAEntry(Patient, hiqa-patient-declan-walsh)
* insert HIQAEntry(RequestGroup, hiqa-grp-s4-controlled-drug)
* insert HIQAEntry(MedicationRequest, hiqa-rx-s4-oxycodone)
* insert HIQAEntry(List, hiqa-allergies-declan-nilknown)
* insert HIQAEntry(PractitionerRole, hiqa-role-gp-nolan)
* insert HIQAEntry(Practitioner, hiqa-prac-gp-nolan)
* insert HIQAEntry(Organization, hiqa-org-gp-practice)
* insert HIQAEntry(Medication, hiqa-med-oxycodone-10-pr)
* insert HIQAEntry(MedicationDispense, hiqa-md-s4-instalment-1)
* insert HIQAEntry(Practitioner, hiqa-prac-pharmacist-farrell)
* insert HIQAEntry(Organization, hiqa-org-pharmacy)


// ====================================================================
// SCENARIO 5: non-dispensation (declined, with reason)
// ====================================================================

Instance: hiqa-rx-s5-amoxicillin
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 5 – Prescription the pharmacist declines: amoxicillin for a patient with penicillin allergy"
Description: "The allergy statement sent with the prescription records a penicillin allergy. The pharmacist declines to dispense (scenario 5)."
* identifier[0].system = $NePS
* identifier[=].value = "9-RX-2026-000005-1"
* groupIdentifier.system = $NePS
* groupIdentifier.value = "9-RX-2026-000005"
* status = #active
* intent = #order
* courseOfTherapyType = http://terminology.hl7.org/CodeSystem/medicationrequest-course-of-therapy#acute "Short course (acute) therapy"
* medicationReference = Reference(hiqa-med-amoxicillin-500-caps)
* subject = Reference(hiqa-patient-niamh-keane)
* supportingInformation = Reference(hiqa-allergies-niamh)
* authoredOn = "2026-09-22T09:30:00+01:00"
* requester = Reference(hiqa-role-gp-nolan)
* reasonCode = $SCTIE#15805002 "Acute sinusitis"
* dosageInstruction[0].text = "Take one capsule three times a day for 7 days"
* dosageInstruction[=].timing.repeat.frequency = 3
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCTIE#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 1 $SCT#732937005 "Capsule"
* dispenseRequest.quantity = 21 $SCT#732937005 "Capsule"
* dispenseRequest.validityPeriod.start = "2026-09-22"
* dispenseRequest.validityPeriod.end = "2026-10-22"
* substitution.allowedBoolean = true


Instance: hiqa-md-s5-declined
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 5 – Non-dispensation: declined because of a recorded penicillin allergy"
Description: "HIQA EP 6.3.1 status (declined) and 6.3.2.2 reason (free text); invariant ie-md-status-1. No medication is handed over, so the dispensed quantity (EP 6.7, Mandatory) is zero."
* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:2df5c229-1bc6-55d4-aa2e-7fa0b6ae1adf"
* extension[recorded].valueDateTime = "2026-09-22T12:10:00+01:00"
* status = #declined
* statusReasonCodeableConcept.text = "Not dispensed: the patient has a confirmed penicillin allergy (anaphylaxis). Prescriber contacted to cancel and review."
* medicationReference = Reference(hiqa-med-amoxicillin-500-caps)
* subject = Reference(hiqa-patient-niamh-keane)
* performer[0].actor = Reference(hiqa-prac-pharmacist-farrell)
* authorizingPrescription = Reference(hiqa-rx-s5-amoxicillin)
* quantity = 0 $SCT#732937005 "Capsule"


Instance: hiqa-bundle-s5-non-dispensation
InstanceOf: IEMpdElectronicPrescriptionGroup
Usage: #example
Title: "Scenario 5 – Electronic Prescription Group (ePG): prescription later declined"
Description: "The prescription as sent. The declined dispense is hiqa-md-s5-declined."
* identifier.system = $NePS
* identifier.value = "9-RX-2026-000005"
* type = #collection
* timestamp = "2026-09-22T09:30:00+01:00"
* insert HIQAEntry(Patient, hiqa-patient-niamh-keane)
* insert HIQAEntry(RequestGroup, hiqa-grp-s5-non-dispensation)
* insert HIQAEntry(MedicationRequest, hiqa-rx-s5-amoxicillin)
* insert HIQAEntry(List, hiqa-allergies-niamh)
* insert HIQAEntry(AllergyIntolerance, hiqa-allergy-niamh-penicillin)
* insert HIQAEntry(PractitionerRole, hiqa-role-gp-nolan)
* insert HIQAEntry(Practitioner, hiqa-prac-gp-nolan)
* insert HIQAEntry(Organization, hiqa-org-gp-practice)
* insert HIQAEntry(Medication, hiqa-med-amoxicillin-500-caps)
* insert HIQAEntry(MedicationDispense, hiqa-md-s5-declined)
* insert HIQAEntry(Practitioner, hiqa-prac-pharmacist-farrell)
* insert HIQAEntry(Organization, hiqa-org-pharmacy)


// ====================================================================
// SCENARIO 6: cross-border IE → EU with prescriber signature
// ====================================================================

Instance: hiqa-rx-s6-metformin
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 6 – Cross-border item 1: metformin 500 mg"
Description: "Item 1 of a two-item prescription to be dispensed in another EU Member State."
* identifier[0].system = $NePS
* identifier[=].value = "9-RX-2026-000006-1"
* groupIdentifier.system = $NePS
* groupIdentifier.value = "9-RX-2026-000006"
* status = #active
* intent = #order
* courseOfTherapyType = http://terminology.hl7.org/CodeSystem/medicationrequest-course-of-therapy#continuous "Continuous long term therapy"
* medicationReference = Reference(ie-mpd-medication-metformin-500)
* subject = Reference(hiqa-patient-declan-walsh)
* supportingInformation = Reference(hiqa-allergies-declan-nilknown)
* authoredOn = "2026-09-16T10:00:00+01:00"
* requester = Reference(hiqa-role-gp-nolan)
* reasonCode = $SCTIE#44054006 "Type 2 diabetes mellitus"
* dosageInstruction[0].text = "Take one tablet twice a day with meals"
* dosageInstruction[=].timing.repeat.frequency = 2
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCTIE#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 1 $SCT#732936001 "Tablet"
* dispenseRequest.quantity = 56 $SCT#732936001 "Tablet"
* dispenseRequest.validityPeriod.start = "2026-09-16"
* dispenseRequest.validityPeriod.end = "2027-03-15"
* substitution.allowedBoolean = true


Instance: hiqa-rx-s6-atorvastatin
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 6 – Cross-border item 2: atorvastatin 20 mg"
Description: "Item 2 of the cross-border prescription; same group identifier (EP 3.1)."
* identifier[0].system = $NePS
* identifier[=].value = "9-RX-2026-000006-2"
* groupIdentifier.system = $NePS
* groupIdentifier.value = "9-RX-2026-000006"
* status = #active
* intent = #order
* courseOfTherapyType = http://terminology.hl7.org/CodeSystem/medicationrequest-course-of-therapy#continuous "Continuous long term therapy"
* medicationReference = Reference(ie-mpd-medication-atorvastatin-20)
* subject = Reference(hiqa-patient-declan-walsh)
* supportingInformation = Reference(hiqa-allergies-declan-nilknown)
* authoredOn = "2026-09-16T10:00:00+01:00"
* requester = Reference(hiqa-role-gp-nolan)
* dosageInstruction[0].text = "Take one tablet once a day at night"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCTIE#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 1 $SCT#732936001 "Tablet"
* dispenseRequest.quantity = 28 $SCT#732936001 "Tablet"
* dispenseRequest.validityPeriod.start = "2026-09-16"
* dispenseRequest.validityPeriod.end = "2027-03-15"
* substitution.allowedBoolean = true


Instance: hiqa-provenance-s6-signature
InstanceOf: IEMpdProvenanceEPrescriptionSignature
Usage: #example
Title: "Scenario 6 – Prescriber signature over both items"
Description: "HIQA EP 2.13 Signature. The signature value is a SYNTHETIC placeholder, not a real signature. The format (e.g. JAdES) and eIDAS assurance level are Requires Clarification (IE Core OI-009)."
* target[0] = Reference(hiqa-rx-s6-metformin)
* target[+] = Reference(hiqa-rx-s6-atorvastatin)
* recorded = "2026-09-16T10:01:00+01:00"
* agent[0].who = Reference(hiqa-role-gp-nolan)
* signature[0].type = urn:iso-astm:E1762-95:2013#1.2.840.10065.1.12.1.1 "Author's Signature"
* signature[=].when = "2026-09-16T10:01:00+01:00"
* signature[=].who = Reference(hiqa-role-gp-nolan)
* signature[=].sigFormat = #application/jose
// base64 of "SYNTHETIC-EXAMPLE-SIGNATURE-NOT-VALID"
* signature[=].data = "U1lOVEhFVElDLUVYQU1QTEUtU0lHTkFUVVJFLU5PVC1WQUxJRA=="


Instance: hiqa-bundle-s6-crossborder
InstanceOf: IEMpdElectronicPrescriptionGroupCrossBorder
Usage: #example
Title: "Scenario 6 – Cross-border Electronic Prescription Group (ePG, IE → EU) with signature"
Description: "Claims IEMpdElectronicPrescriptionGroupCrossBorder (no invented tag; IE Core ADR-003): patient date of birth, prescriber telephone and secure email (EP 2.10.1/2.10.2; ie-bnd-xb-1) and a signature covering every item (EP 2.13; ie-bnd-xb-2)."
* identifier.system = $NePS
* identifier.value = "9-RX-2026-000006"
* type = #collection
* timestamp = "2026-09-16T10:01:00+01:00"
* insert HIQAEntry(Patient, hiqa-patient-declan-walsh)
* insert HIQAEntry(RequestGroup, hiqa-grp-s6-crossborder)
* insert HIQAEntry(MedicationRequest, hiqa-rx-s6-metformin)
* insert HIQAEntry(MedicationRequest, hiqa-rx-s6-atorvastatin)
* insert HIQAEntry(List, hiqa-allergies-declan-nilknown)
* insert HIQAEntry(Provenance, hiqa-provenance-s6-signature)
* insert HIQAEntry(PractitionerRole, hiqa-role-gp-nolan)
* insert HIQAEntry(Practitioner, hiqa-prac-gp-nolan)
* insert HIQAEntry(Organization, hiqa-org-gp-practice)
* insert HIQAEntry(Medication, ie-mpd-medication-metformin-500)
* insert HIQAEntry(Medication, ie-mpd-medication-atorvastatin-20)
