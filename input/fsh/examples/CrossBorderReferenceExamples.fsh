// REFERENCE EXAMPLES. Ported from IE Core 0.2.0 (hl7-ie/ie-core @ 34ff374: examples/CrossBorderExamples.fsh,
// examples/MedicationExamples.fsh and the base examples they reference), renamed for IE Medication Events
// (ADR-001, ADR-003). Conditions and the encounter use the base FHIR resource (IE Core profiles them).
// Illustrative only: all people, organisations and identifiers are fictional.

// ═══ from IE Core examples/Examples.fsh ═══

Instance: ie-mpd-patient-example
InstanceOf: IEMpdPatientEPrescription
Usage: #example
Title: "IE MPD Patient Example"
Description: "An example IE Core Patient representing a male adult living in Dublin with an IHI and a medical card number; conforms to the HIQA ePrescription patient dataset."

* identifier[0].system = $IHI
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "210000000012345678"

* insert PCRSIdentifier($GMS, medical-card, Medical card scheme number, MC-0012345)

* active = true
* name[0].use = #official
* name[=].family = "Murphy"
* name[=].given[0] = "John"
* name[=].given[+] = "Patrick"
* name[=].prefix = "Mr."
* gender = #male
* insert SexAssignedAtBirth(male, Male)
* birthDate = "1978-05-15"

* address[0].use = #home
* address[=].type = #physical
* address[=].line[0] = "42 Pearse Street"
* address[=].city = "Dublin"
* address[=].state = "Dublin"
* address[=].postalCode = "D02 XY12"
* address[=].country = "IE"

* telecom[0].system = #phone
* telecom[=].value = "+353 1 555 0123"
* telecom[=].use = #home
* telecom[+].system = #email
* telecom[=].value = "john.murphy@example.ie"
* telecom[=].use = #home
* telecom[+].system = #phone
* telecom[=].value = "+353 87 123 4567"
* telecom[=].use = #mobile

* communication[0].language = urn:ietf:bcp:47#en "English"
* communication[=].preferred = true
* communication[+].language = urn:ietf:bcp:47#ga "Irish"

* generalPractitioner = Reference(ie-mpd-practitioner-example) "Dr. Sarah O'Brien"
* managingOrganization = Reference(ie-mpd-organization-example) "St. James's Hospital"



// ====================================================================
// 4. Practitioner – Dr. Sarah O'Brien
// ====================================================================

Instance: ie-mpd-practitioner-example
InstanceOf: IEMpdPractitioner
Usage: #example
Title: "IE MPD Practitioner Example"
Description: "An example IE Core Practitioner representing a General Practitioner with IMC registration and HPI identifier."

* identifier[IMC].system = $IMC
* identifier[IMC].type = $V2-0203#MD "Medical License number"
* identifier[IMC].value = "IMC-12345"


* active = true
* name[0].use = #official
* name[=].family = "O'Brien"
* name[=].given = "Sarah"
* name[=].prefix = "Dr."
* gender = #female

* telecom[0].system = #phone
* telecom[=].value = "+353 1 410 3456"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "sarah.obrien@sjh.ie"
* telecom[=].use = #work

* address[0].use = #work
* address[=].line = "James's Street"
* address[=].city = "Dublin"
* address[=].state = "Dublin"
* address[=].postalCode = "D08 NHY1"
* address[=].country = "IE"

* qualification[0].code = $SCT#309343006 "Physician"
* qualification[=].issuer.display = "Irish Medical Council"



// ====================================================================
// 6. Organization – St. James's Hospital
// ====================================================================

Instance: ie-mpd-organization-example
InstanceOf: IEMpdOrganization
Usage: #example
Title: "IE MPD Organization Example"
Description: "An example IE Core Organization representing St. James's Hospital, Dublin — a major acute hospital under the HSE."



* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "St. James's Hospital"

* telecom[0].system = #phone
* telecom[=].value = "+353 1 410 3000"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "info@stjames.ie"
* telecom[=].use = #work

* address[0].use = #work
* address[=].type = #physical
* address[=].line = "James's Street"
* address[=].city = "Dublin"
* address[=].state = "Dublin"
* address[=].postalCode = "D08 NHY1"
* address[=].country = "IE"



// ====================================================================
// Supporting: Location for PractitionerRole reference
// ====================================================================

Instance: ie-mpd-location-example
InstanceOf: IEMpdLocation
Usage: #example
Title: "IE MPD Location Example"
Description: "An example IE Core Location representing the GP Clinic at St. James's Hospital."

* status = #active
* name = "St. James's Hospital – GP Clinic"
* mode = #instance
* type = http://terminology.hl7.org/CodeSystem/v3-RoleCode#HOSP "Hospital"
* telecom[0].system = #phone
* telecom[=].value = "+353 1 410 3456"
* telecom[=].use = #work
* address.use = #work
* address.line = "James's Street"
* address.city = "Dublin"
* address.state = "Dublin"
* address.postalCode = "D08 NHY1"
* address.country = "IE"
* managingOrganization = Reference(ie-mpd-organization-example) "St. James's Hospital"



// ====================================================================
// 7. Encounter – Ambulatory
// ====================================================================

Instance: ie-mpd-encounter-example
InstanceOf: Encounter
Usage: #example
Title: "IE MPD Encounter Example"
Description: "An example IE Core Encounter representing a completed ambulatory consultation at St. James's Hospital."

* identifier[0].system = "http://stjames.ie/encounters"
* identifier[=].value = "ENC-2024-005678"

* status = #finished
* class = $V3-ActCode#AMB "ambulatory"
* type = $SCT#11429006 "Consultation"

* subject = Reference(ie-mpd-patient-example) "John Murphy"
* participant[0].type = http://terminology.hl7.org/CodeSystem/v3-ParticipationType#ATND "attender"
* participant[=].individual = Reference(ie-mpd-practitioner-example) "Dr. Sarah O'Brien"

* period.start = "2024-06-15T09:00:00+01:00"
* period.end = "2024-06-15T09:30:00+01:00"

* reasonCode = $SCT#185347001 "Encounter for problem"
* serviceProvider = Reference(ie-mpd-organization-example) "St. James's Hospital"
* location[0].location = Reference(ie-mpd-location-example) "St. James's Hospital – GP Clinic"
* location[=].status = #completed

// ═══ from IE Core examples/CrossBorderExamples.fsh ═══

Instance: ie-mpd-patient-sean-murphy
InstanceOf: IEMpdPatientEPrescription
Usage: #example
Title: "Patient – Seán Patrick Murphy (Irish, cross-border scenarios)"
Description: "Seán Patrick Murphy, an Irish patient with Type 2 Diabetes, Essential Hypertension, and Hypercholesterolaemia. Carries an Irish PPS number, IHI, medical card number and eIDAS identity used in cross-border ePrescription exchange via MyHealth@EU."

* identifier[0].system = $IHI
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "210000000099887766"

* insert PCRSIdentifier($GMS, medical-card, Medical card scheme number, MC-0099887)

// PPSN (HIQA EP 1.3.2): not MustSupport; legal basis Requires Clarification (OI-008)
* identifier[+].system = $PPS
* identifier[=].value = "1234567T"

// eIDAS cross-border identifiers (one per destination country)
* identifier[+].system = "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "IE/DE/1234567T"

* active = true
* name[0].use = #official
* name[=].family = "Murphy"
* name[=].given[0] = "Seán"
* name[=].given[+] = "Patrick"
* name[=].prefix = "Mr."

* gender = #male
* insert SexAssignedAtBirth(male, Male)
* birthDate = "1975-03-15"

* address[0].use = #home
* address[=].type = #physical
* address[=].line[0] = "14 Grafton Street"
* address[=].city = "Dublin 2"
* address[=].state = "Dublin"
* address[=].postalCode = "D02 XY45"
* address[=].country = "IE"

* telecom[0].system = #phone
* telecom[=].value = "+353 87 900 1234"
* telecom[=].use = #mobile
* telecom[+].system = #email
* telecom[=].value = "sean.murphy@example.ie"
* telecom[=].use = #home

* communication[0].language = urn:ietf:bcp:47#en "English"
* communication[=].preferred = true
* communication[+].language = urn:ietf:bcp:47#ga "Irish"



// ====================================================================
// GP – DR. AOIFE O'BRIEN, GRAFTON STREET MEDICAL PRACTICE
// ====================================================================

Instance: ie-mpd-practitioner-aoife-obrien
InstanceOf: IEMpdPractitioner
Usage: #example
Title: "Practitioner – Dr. Aoife O'Brien (GP, Dublin)"
Description: "Dr. Aoife O'Brien, General Practitioner at Grafton Street Medical Practice, Dublin. Prescribing physician for Seán Murphy's cross-border prescriptions."

* identifier[0].system = $IMC
* identifier[=].type = $V2-0203#MD "Medical License number"
* identifier[=].value = "GP-IE-12345"

* active = true
* name[0].use = #official
* name[=].family = "O'Brien"
* name[=].given = "Aoife"
* name[=].prefix = "Dr."
* gender = #female

* telecom[0].system = #phone
* telecom[=].value = "+353 1 677 1234"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "aoife.obrien@graftonmedical.ie"
* telecom[=].use = #work

* address[0].use = #work
* address[=].line = "14 Grafton Street"
* address[=].city = "Dublin 2"
* address[=].postalCode = "D02 XY45"
* address[=].country = "IE"

* qualification[0].code = $SCT#62247001 "General practitioner"
* qualification[=].issuer.display = "Irish Medical Council"



Instance: ie-mpd-organization-grafton-medical
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Organization – Grafton Street Medical Practice"
Description: "Grafton Street Medical Practice, Dublin 2 — GP practice from which Seán Murphy's prescriptions are issued."


* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Grafton Street Medical Practice"

* telecom[0].system = #phone
* telecom[=].value = "+353 1 677 1234"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "info@graftonmedical.ie"
* telecom[=].use = #work

* address[0].use = #work
* address[=].type = #physical
* address[=].line = "14 Grafton Street"
* address[=].city = "Dublin 2"
* address[=].postalCode = "D02 XY45"
* address[=].country = "IE"



// ====================================================================
// ALLERGY – PENICILLIN / AMOXICILLIN (ANAPHYLAXIS)
// ====================================================================

Instance: ie-mpd-allergy-penicillin-murphy
InstanceOf: IEMpdAllergyIntolerance
Usage: #example
Title: "AllergyIntolerance – Penicillin/Amoxicillin Anaphylaxis (Seán Murphy)"
Description: "CRITICAL ALLERGY: Seán Murphy has a documented severe anaphylactic reaction to Penicillin and Amoxicillin (penicillin-class antibiotics). First documented 1995. Do NOT dispense penicillin-class antibiotics."

* clinicalStatus = http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical#active "Active"
* verificationStatus = http://terminology.hl7.org/CodeSystem/allergyintolerance-verification#confirmed "Confirmed"
* type = #allergy
* category = #medication
* criticality = #high

* code = $SCT#372687004 "Amoxicillin"
* code.text = "Penicillin / Amoxicillin (ALL penicillin-class antibiotics)"

* patient = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* onsetDateTime = "1995-01-01"
* recordedDate = "2010-06-01"

* reaction[0].substance = $SCT#372687004 "Amoxicillin"
* reaction[=].manifestation = $SCT#39579001 "Anaphylaxis"
* reaction[=].severity = #severe
* reaction[=].description = "Anaphylaxis. Do NOT dispense penicillin-class antibiotics."
* reaction[=].note[0].text = "Patient carries an EpiPen. Allergy first documented 1995 following hospitalisation."



// ====================================================================
// CONDITIONS
// ====================================================================

Instance: ie-mpd-condition-t2dm-murphy
InstanceOf: Condition
Usage: #example
Title: "Condition – Type 2 Diabetes Mellitus (Seán Murphy)"
Description: "Type 2 Diabetes Mellitus (ICD-10: E11 / SNOMED: 44054006). Active since 2018. Managed with Metformin 500mg."

* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* category = http://terminology.hl7.org/CodeSystem/condition-category#problem-list-item
* severity = $SCT#6736007 "Moderate severity"
* code.coding[0].system = $SCT
* code.coding[=].code = #44054006
* code.coding[=].display = "Type 2 diabetes mellitus"
* code.coding[+].system = "http://hl7.org/fhir/sid/icd-10"
* code.coding[=].code = #E11
* code.coding[=].display = "Type 2 diabetes mellitus"
* code.text = "Type 2 Diabetes Mellitus"
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* onsetDateTime = "2018-03-10"
* recordedDate = "2018-03-10"



Instance: ie-mpd-condition-hypertension-murphy
InstanceOf: Condition
Usage: #example
Title: "Condition – Essential Hypertension (Seán Murphy)"
Description: "Essential Hypertension (ICD-10: I10 / SNOMED: 38341003). Active since 2019. Managed with Lisinopril 10mg."

* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* category = http://terminology.hl7.org/CodeSystem/condition-category#problem-list-item
* code.coding[0].system = $SCT
* code.coding[=].code = #38341003
* code.coding[=].display = "Hypertensive disorder"
* code.coding[+].system = "http://hl7.org/fhir/sid/icd-10"
* code.coding[=].code = #I10
* code.coding[=].display = "Essential (primary) hypertension"
* code.text = "Essential Hypertension"
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* onsetDateTime = "2019-05-22"
* recordedDate = "2019-05-22"



Instance: ie-mpd-condition-hypercholesterolaemia-murphy
InstanceOf: Condition
Usage: #example
Title: "Condition – Hypercholesterolaemia (Seán Murphy)"
Description: "Hypercholesterolaemia (ICD-10: E78.0 / SNOMED: 13644009). Active since 2020. Managed with Atorvastatin 20mg."

* clinicalStatus = http://terminology.hl7.org/CodeSystem/condition-clinical#active
* verificationStatus = http://terminology.hl7.org/CodeSystem/condition-ver-status#confirmed
* category = http://terminology.hl7.org/CodeSystem/condition-category#problem-list-item
* code.coding[0].system = $SCT
* code.coding[=].code = #13644009
* code.coding[=].display = "Hypercholesterolemia"
* code.coding[+].system = "http://hl7.org/fhir/sid/icd-10"
* code.coding[=].code = #E78.0
* code.coding[=].display = "Pure hypercholesterolaemia"
* code.text = "Hypercholesterolaemia"
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* onsetDateTime = "2020-01-15"
* recordedDate = "2020-01-15"



// ====================================================================
// MEDICATIONS – SEÁN MURPHY'S CHRONIC MEDICATIONS
// ====================================================================

Instance: ie-medication-lisinopril-10
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Lisinopril 10mg Tablets (ATC: C09AA03)"
Description: "Lisinopril 10mg tablets, ACE inhibitor for hypertension. The NMPC VMP code (SNOMED CT Irish Edition) is primary, the International SNOMED CT substance is secondary, and ATC code C09AA03 is included for classification."

* code.coding[0].system = $SCT
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.coding[=].code = #714701000220101
* code.coding[=].display = "Lisinopril 10 mg oral tablet"
* code.coding[+].system = $SCT
* code.coding[=].code = #386873009
* code.coding[=].display = "Lisinopril"
* code.coding[+].system = $ATC
* code.coding[=].code = #C09AA03
* code.coding[=].display = "Lisinopril"
* code.text = "Lisinopril 10mg tablets"
* form = $SCT#385055001 "Tablet"
* amount.numerator = 28 '{tablet}' "tablets"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#386873009 "Lisinopril"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 10 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{tablet}' "tablet"



Instance: ie-medication-warfarin-5
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Warfarin 5mg Tablets (ATC: B01AA03)"
Description: "Warfarin sodium 5mg tablets, anticoagulant. The NMPC VMP code (SNOMED CT Irish Edition) is primary, the International SNOMED CT substance is secondary, and ATC code B01AA03 is included for classification. Requires INR monitoring."

* code.coding[0].system = $SCT
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.coding[=].code = #718731000220101
* code.coding[=].display = "Warfarin sodium 5 mg oral tablet"
* code.coding[+].system = $SCT
* code.coding[=].code = #372756006
* code.coding[=].display = "Warfarin"
* code.coding[+].system = $ATC
* code.coding[=].code = #B01AA03
* code.coding[=].display = "Warfarin"
* code.text = "Warfarin 5mg tablets"
* form = $SCT#385055001 "Tablet"
* amount.numerator = 28 '{tablet}' "tablets"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#372756006 "Warfarin"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 5 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{tablet}' "tablet"



Instance: ie-medication-insulin-glargine
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Insulin Glargine 100u/ml Injection (ATC: A10AE04)"
Description: "Insulin glargine 100 units/ml solution for injection, long-acting basal insulin. The NMPC VMP code (SNOMED CT Irish Edition) is primary, the International SNOMED CT substance is secondary, and ATC code A10AE04 is included for classification."

* code.coding[0].system = $SCT
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.coding[=].code = #529881000220106
* code.coding[=].display = "Insulin glargine 100 units/1 mL solution for injection 3 mL pre-filled pen"
* code.coding[+].system = $SCT
* code.coding[=].code = #411529005
* code.coding[=].display = "Insulin glargine"
* code.coding[+].system = $ATC
* code.coding[=].code = #A10AE04
* code.coding[=].display = "Insulin glargine"
* code.text = "Insulin glargine 100 units/mL solution for injection 3 mL pre-filled pen"
* form = $SCT#385219001 "Solution for injection"
* amount.numerator = 5 '{pen}' "pre-filled pens"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#411529005 "Insulin glargine"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 100 'U/mL' "units/mL"
* ingredient[=].strength.denominator = 1 'mL' "mL"



Instance: ie-medication-insulin-aspart
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Insulin Aspart 100u/ml Injection (ATC: A10AB05)"
Description: "Insulin aspart 100 units/ml solution for injection, rapid-acting insulin. The NMPC VMP code (SNOMED CT Irish Edition) is primary, the International SNOMED CT substance is secondary, and ATC code A10AB05 is included for classification."

* code.coding[0].system = $SCT
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.coding[=].code = #525351000220105
* code.coding[=].display = "Insulin aspart 100 units/1 mL solution for injection 3 mL cartridge"
* code.coding[+].system = $SCT
* code.coding[=].code = #325072002
* code.coding[=].display = "Insulin aspart"
* code.coding[+].system = $ATC
* code.coding[=].code = #A10AB05
* code.coding[=].display = "Insulin aspart"
* code.text = "Insulin aspart 100 units/mL solution for injection 3 mL cartridge"
* form = $SCT#385219001 "Solution for injection"
* amount.numerator = 5 '{cartridge}' "cartridges"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#325072002 "Insulin aspart"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 100 'U/mL' "units/mL"
* ingredient[=].strength.denominator = 1 'mL' "mL"



Instance: ie-medication-sertraline-50
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Sertraline 50mg Tablets (ATC: N06AB06)"
Description: "Sertraline hydrochloride 50mg tablets, SSRI antidepressant. The NMPC VMP code (SNOMED CT Irish Edition) is primary, the International SNOMED CT substance is secondary, and ATC code N06AB06 is included for classification."

* code.coding[0].system = $SCT
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.coding[=].code = #268301000220104
* code.coding[=].display = "Sertraline 50 mg oral tablet"
* code.coding[+].system = $SCT
* code.coding[=].code = #372594008
* code.coding[=].display = "Sertraline"
* code.coding[+].system = $ATC
* code.coding[=].code = #N06AB06
* code.coding[=].display = "Sertraline"
* code.text = "Sertraline 50mg tablets"
* form = $SCT#385055001 "Tablet"
* amount.numerator = 28 '{tablet}' "tablets"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#372594008 "Sertraline"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 50 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{tablet}' "tablet"



Instance: ie-medication-omeprazole-20
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Omeprazole 20mg Capsules (ATC: A02BC01)"
Description: "Omeprazole 20mg gastro-resistant capsules, proton pump inhibitor. The NMPC VMP code (SNOMED CT Irish Edition) is primary, the International SNOMED CT substance is secondary, and ATC code A02BC01 is included for classification."

* code.coding[0].system = $SCT
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.coding[=].code = #313941000220100
* code.coding[=].display = "Omeprazole 20 mg gastro-resistant oral capsule"
* code.coding[+].system = $SCT
* code.coding[=].code = #317291008
* code.coding[=].display = "Omeprazole 20 mg oral capsule"
* code.coding[+].system = $ATC
* code.coding[=].code = #A02BC01
* code.coding[=].display = "Omeprazole"
* code.text = "Omeprazole 20mg gastro-resistant capsules"
* form = $SCT#385049006 "Capsule"
* amount.numerator = 28 '{capsule}' "capsules"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#387137007 "Omeprazole"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 20 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{capsule}' "capsule"



Instance: ie-medication-atorvastatin-80
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Atorvastatin 80mg Tablets (ATC: C10AA05)"
Description: "Atorvastatin 80mg film-coated tablets (high-intensity statin). The NMPC VMP code (SNOMED CT Irish Edition) is primary, the International SNOMED CT substance is secondary, and ATC code C10AA05 is included for classification."

* code.coding[0].system = $SCT
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.coding[=].code = #254341000220103
* code.coding[=].display = "Atorvastatin 80 mg oral tablet"
* code.coding[+].system = $SCT
* code.coding[=].code = #373444002
* code.coding[=].display = "Atorvastatin"
* code.coding[+].system = $ATC
* code.coding[=].code = #C10AA05
* code.coding[=].display = "Atorvastatin"
* code.text = "Atorvastatin 80mg tablets"
* form = $SCT#385055001 "Tablet"
* amount.numerator = 28 '{tablet}' "tablets"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#373444002 "Atorvastatin"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 80 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{tablet}' "tablet"



Instance: ie-medication-ramipril-10
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Ramipril 10mg Capsules (ATC: C09AA05)"
Description: "Ramipril 10mg capsules, ACE inhibitor. The NMPC VMP code (SNOMED CT Irish Edition) is primary, the International SNOMED CT substance is secondary, and ATC code C09AA05 is included for classification."

* code.coding[0].system = $SCT
* code.coding[=].version = "http://snomed.info/sct/1601000220105"
* code.coding[=].code = #720061000220100
* code.coding[=].display = "Ramipril 10 mg oral capsule"
* code.coding[+].system = $SCT
* code.coding[=].code = #386872004
* code.coding[=].display = "Ramipril"
* code.coding[+].system = $ATC
* code.coding[=].code = #C09AA05
* code.coding[=].display = "Ramipril"
* code.text = "Ramipril 10mg capsules"
* form = $SCT#385049006 "Capsule"
* amount.numerator = 28 '{capsule}' "capsules"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#386872004 "Ramipril"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 10 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{capsule}' "capsule"



// ====================================================================
// SCENARIO 1: IE → GERMANY (BERLIN) – Metformin + Lisinopril
// Date: 2025-01-20 | Apotheke am Brandenburger Tor
// ====================================================================

Instance: ie-org-de-apotheke-brandenburger
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Pharmacy – Apotheke am Brandenburger Tor, Berlin (DE)"
Description: "German pharmacy in Berlin where Seán Murphy's Irish ePrescription for Metformin and Lisinopril was dispensed on 20 January 2025."

* identifier[0].assigner.display = "Issuing authority in Germany (illustrative)"
* identifier[=].value = "DE-APO-10117-001"
* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Apotheke am Brandenburger Tor"
* address[0].use = #work
* address[=].line = "Pariser Platz 1"
* address[=].city = "Berlin"
* address[=].postalCode = "10117"
* address[=].country = "DE"
* telecom[0].system = #phone
* telecom[=].value = "+49 30 202 64 14"
* telecom[=].use = #work



Instance: ie-rx-sean-de-metformin
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 1 (IE→DE) – Prescription: Metformin 500mg for Germany"
Description: "Irish ePrescription for Metformin 500mg for Seán Murphy, transmitted via MyHealth@EU to Germany. Carries PCRS identifier and eIDAS cross-border identifier."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2025-IE-DE-001"
* identifier[+].system = "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
* identifier[=].value = "IE/DE/1234567T"

* groupIdentifier.system = $NePS
* groupIdentifier.value = "IE-GP-RX-GROUP-20250120-DE"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"

* medicationReference = Reference(ie-mpd-medication-metformin-500)
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* requester = Reference(ie-mpd-practitioner-aoife-obrien) "Dr. Aoife O'Brien"
* authoredOn = "2025-01-15"

* reasonCode = $SCT#44054006 "Type 2 diabetes mellitus"
* reasonCode.coding[+].system = $ATC
* reasonCode.coding[=].code = #A10BA02
* reasonCode.coding[=].display = "Metformin"

* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* dosageInstruction[=].timing.repeat.frequency = 2
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 500 'mg' "mg"

* dispenseRequest.validityPeriod.start = "2025-01-15"
* dispenseRequest.validityPeriod.end = "2025-04-15"
* dispenseRequest.numberOfRepeatsAllowed = 0
* dispenseRequest.quantity = 60 '{tablet}' "tablets"
* dispenseRequest.expectedSupplyDuration = 30 'd' "days"

* substitution.allowedBoolean = true



Instance: ie-rx-sean-de-lisinopril
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 1 (IE→DE) – Prescription: Lisinopril 10mg for Germany"
Description: "Irish ePrescription for Lisinopril 10mg for Seán Murphy, transmitted via MyHealth@EU to Germany."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2025-IE-DE-002"
* identifier[+].system = "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
* identifier[=].value = "IE/DE/1234567T"

* groupIdentifier.system = $NePS
* groupIdentifier.value = "IE-GP-RX-GROUP-20250120-DE"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"

* medicationReference = Reference(ie-medication-lisinopril-10)
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* requester = Reference(ie-mpd-practitioner-aoife-obrien) "Dr. Aoife O'Brien"
* authoredOn = "2025-01-15"

* reasonCode = $SCT#38341003 "Hypertensive disorder"
* reasonCode.coding[+].system = $ATC
* reasonCode.coding[=].code = #C09AA03
* reasonCode.coding[=].display = "Lisinopril"

* dosageInstruction[0].text = "Take one 10mg tablet once daily in the morning"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].timing.repeat.when = #MORN
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 10 'mg' "mg"

* dispenseRequest.validityPeriod.start = "2025-01-15"
* dispenseRequest.validityPeriod.end = "2025-04-15"
* dispenseRequest.numberOfRepeatsAllowed = 0
* dispenseRequest.quantity = 28 '{tablet}' "tablets"
* dispenseRequest.expectedSupplyDuration = 28 'd' "days"

* substitution.allowedBoolean = true



Instance: ie-dispense-de-metformin
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 1 (IE→DE) – German Dispensation: Metformin (PZN 04823246)"
Description: "German pharmacy dispensation of Metformin 500mg Filmtabletten (Ratiopharm, PZN 04823246) against the Irish cross-border ePrescription. Generic substitution performed."

* identifier[0].assigner.display = "Issuing authority in Germany (illustrative)"
* identifier[=].value = "DE-DISP-2025-XB-001-MET"
* status = #completed
* extension[recorded].valueDateTime = "2025-01-20T10:15:00+01:00"

* medicationReference = Reference(ie-medication-dispensed-de-metformin) "Metformin 500mg Filmtabletten (Ratiopharm)"

* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* performer[0].actor = Reference(ie-org-de-apotheke-brandenburger) "Apotheke am Brandenburger Tor"

* authorizingPrescription = Reference(ie-rx-sean-de-metformin) "PCRS-RX-2025-IE-DE-001"

* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 60 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"
* whenPrepared = "2025-01-20T10:00:00+01:00"
* whenHandedOver = "2025-01-20T10:15:00+01:00"

* dosageInstruction[0].text = "Zweimal täglich 1 Tablette zu den Mahlzeiten einnehmen (Take one 500mg tablet twice daily with meals)"

* substitution.wasSubstituted = true
* substitution.type = http://terminology.hl7.org/CodeSystem/v3-substanceAdminSubstitution#G "Generic composition"
* substitution.reason = $SCT#373873005 "Pharmaceutical / biologic product"



Instance: ie-dispense-de-lisinopril
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 1 (IE→DE) – German Dispensation: Lisinopril (PZN 03990693)"
Description: "German pharmacy dispensation of Lisinopril 10mg Tabletten (Hexal, PZN 03990693) against the Irish cross-border ePrescription. Generic substitution performed."

* identifier[0].assigner.display = "Issuing authority in Germany (illustrative)"
* identifier[=].value = "DE-DISP-2025-XB-001-LIS"
* status = #completed
* extension[recorded].valueDateTime = "2025-01-20T10:15:00+01:00"

* medicationReference = Reference(ie-medication-dispensed-de-lisinopril) "Lisinopril 10mg Tabletten (Hexal)"

* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* performer[0].actor = Reference(ie-org-de-apotheke-brandenburger) "Apotheke am Brandenburger Tor"

* authorizingPrescription = Reference(ie-rx-sean-de-lisinopril) "PCRS-RX-2025-IE-DE-002"

* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 28 '{tablet}' "tablets"
* daysSupply = 28 'd' "days"
* whenPrepared = "2025-01-20T10:00:00+01:00"
* whenHandedOver = "2025-01-20T10:15:00+01:00"

* dosageInstruction[0].text = "Einmal täglich 1 Tablette morgens (Take one 10mg tablet once daily in the morning)"

* substitution.wasSubstituted = true
* substitution.type = http://terminology.hl7.org/CodeSystem/v3-substanceAdminSubstitution#G "Generic composition"
* substitution.reason = $SCT#373873005 "Pharmaceutical / biologic product"



// ====================================================================
// SCENARIO 5 (IE→LV) – Metformin + Lisinopril in Latvia
// ====================================================================

Instance: ie-org-lv-mes-aptieka
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Pharmacy – Mēs atdot Aptieka, Riga (LV)"
Description: "Latvian pharmacy in Riga where Seán Murphy's Irish ePrescription was dispensed (15 June 2025)."

* identifier[0].assigner.display = "Issuing authority in Latvia (illustrative)"
* identifier[=].value = "LV-APT-RIGA-001"
* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Mēs atdot Aptieka"
* address[0].use = #work
* address[=].city = "Riga"
* address[=].country = "LV"



Instance: ie-rx-sean-lv-metformin
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 5 (IE→LV) – Prescription: Metformin 500mg for Latvia"
Description: "Irish ePrescription for Metformin 500mg for Seán Murphy, transmitted via MyHealth@EU to Latvia."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2025-IE-LV-001"
* identifier[+].system = "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
* identifier[=].value = "IE/LV/1234567T"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"
* medicationReference = Reference(ie-mpd-medication-metformin-500)
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* requester = Reference(ie-mpd-practitioner-aoife-obrien) "Dr. Aoife O'Brien"
* authoredOn = "2025-06-10"
* reasonCode = $SCT#44054006 "Type 2 diabetes mellitus"
* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* dosageInstruction[=].timing.repeat.frequency = 2
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dispenseRequest.validityPeriod.start = "2025-06-10"
* dispenseRequest.validityPeriod.end = "2025-09-10"
* dispenseRequest.numberOfRepeatsAllowed = 0
* dispenseRequest.quantity = 60 '{tablet}' "tablets"
* substitution.allowedBoolean = true



Instance: ie-dispense-lv-metformin
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 5 (IE→LV) – Latvian Dispensation: Metformin (ZRA-00098432)"
Description: "Latvian pharmacy dispensation of Metformins 500mg tabletes (ZRA code ZRA-00098432) against the Irish cross-border ePrescription."

* identifier[0].assigner.display = "Issuing authority in Latvia (illustrative)"
* identifier[=].value = "LV-DISP-2025-XB-001"
* status = #completed
* extension[recorded].valueDateTime = "2025-06-15T11:00:00+03:00"

* medicationReference = Reference(ie-medication-dispensed-lv-metformin) "Metformins 500mg tabletes"

* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* performer[0].actor = Reference(ie-org-lv-mes-aptieka) "Mēs atdot Aptieka"
* authorizingPrescription = Reference(ie-rx-sean-lv-metformin) "PCRS-RX-2025-IE-LV-001"
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 60 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"
* whenHandedOver = "2025-06-15T11:00:00+03:00"
* dosageInstruction[0].text = "Lietot vienu 500mg tableti divas reizes dienā ēdienreizēs (Take one 500mg tablet twice daily with meals)"
* substitution.wasSubstituted = true
* substitution.type = http://terminology.hl7.org/CodeSystem/v3-substanceAdminSubstitution#G "Generic composition"



// ====================================================================
// SCENARIO 6 (IE→PT) – Sertraline + Omeprazole in Portugal
// ====================================================================

Instance: ie-org-pt-farmacia-central-lisbon
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Pharmacy – Farmácia Central, Lisbon (PT)"
Description: "Portuguese pharmacy in Lisbon where Seán Murphy's Irish ePrescription for Sertraline and Omeprazole was dispensed (20 June 2025)."

* identifier[0].assigner.display = "Issuing authority in Portugal (illustrative)"
* identifier[=].value = "PT-FAR-LIS-001"
* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Farmácia Central"
* address[0].use = #work
* address[=].city = "Lisbon"
* address[=].country = "PT"



Instance: ie-rx-sean-pt-sertraline
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 6 (IE→PT) – Prescription: Sertraline 50mg for Portugal"
Description: "Irish ePrescription for Sertraline 50mg for Seán Murphy, transmitted via MyHealth@EU to Portugal."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2025-IE-PT-001"
* identifier[+].system = "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
* identifier[=].value = "IE/PT/1234567T"

* groupIdentifier.system = $NePS
* groupIdentifier.value = "IE-GP-RX-GROUP-20250620-PT"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"
* medicationReference = Reference(ie-medication-sertraline-50)
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* requester = Reference(ie-mpd-practitioner-aoife-obrien) "Dr. Aoife O'Brien"
* authoredOn = "2025-06-15"
* reasonCode = $SCT#35489007 "Depressive disorder"
* dosageInstruction[0].text = "Take one 50mg tablet once daily in the morning"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].timing.repeat.when = #MORN
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dispenseRequest.validityPeriod.start = "2025-06-15"
* dispenseRequest.validityPeriod.end = "2025-09-15"
* dispenseRequest.quantity = 28 '{tablet}' "tablets"
* substitution.allowedBoolean = false


* substitution.reason.text = "Patient stabilised on this product; switching risks loss of symptom control."

Instance: ie-dispense-pt-sertraline
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 6 (IE→PT) – Portuguese Dispensation: Sertraline (INF-00012345)"
Description: "Portuguese pharmacy dispensation of Sertralina 50mg Comprimidos (INFARMED code INF-00012345)."

* identifier[0].assigner.display = "Issuing authority in Portugal (illustrative)"
* identifier[=].value = "PT-DISP-2025-XB-001"
* status = #completed
* extension[recorded].valueDateTime = "2025-06-20T10:30:00+01:00"
* medicationReference = Reference(ie-medication-dispensed-pt-sertraline) "Sertralina 50mg Comprimidos"
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* performer[0].actor = Reference(ie-org-pt-farmacia-central-lisbon) "Farmácia Central"
* authorizingPrescription = Reference(ie-rx-sean-pt-sertraline) "PCRS-RX-2025-IE-PT-001"
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 28 '{tablet}' "tablets"
* daysSupply = 28 'd' "days"
* whenHandedOver = "2025-06-20T10:30:00+01:00"
* dosageInstruction[0].text = "Tomar um comprimido de 50mg uma vez ao dia de manhã (Take one 50mg tablet once daily in the morning)"
* substitution.wasSubstituted = false



// ====================================================================
// SCENARIO 7 (IE→DK) – Warfarin 5mg in Denmark
// ====================================================================

Instance: ie-org-dk-apoteket-copenhagen
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Pharmacy – Apoteket, Copenhagen (DK)"
Description: "Danish pharmacy in Copenhagen where Seán Murphy's Irish ePrescription for Warfarin 5mg was dispensed (1 July 2025)."

* identifier[0].assigner.display = "Issuing authority in Denmark (illustrative)"
* identifier[=].value = "DK-APO-CPH-001"
* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Apoteket"
* address[0].use = #work
* address[=].city = "Copenhagen"
* address[=].country = "DK"



Instance: ie-rx-sean-dk-warfarin
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 7 (IE→DK) – Prescription: Warfarin 5mg for Denmark"
Description: "Irish ePrescription for Warfarin 5mg for Seán Murphy, transmitted via MyHealth@EU to Denmark. Includes critical INR monitoring note."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2025-IE-DK-001"
* identifier[+].system = "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
* identifier[=].value = "IE/DK/1234567T"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"
* medicationReference = Reference(ie-medication-warfarin-5)
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* requester = Reference(ie-mpd-practitioner-aoife-obrien) "Dr. Aoife O'Brien"
* authoredOn = "2025-06-25"
* reasonCode = $SCT#49436004 "Atrial fibrillation"

* dosageInstruction[0].text = "Take one 5mg tablet once daily. INR target 2.0-3.0. Requires INR monitoring — contact local anticoagulation service."
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].patientInstruction = "⚠️ Requires regular INR blood tests. Target INR 2.0–3.0. Consult local anticoagulation clinic."

* dispenseRequest.validityPeriod.start = "2025-06-25"
* dispenseRequest.validityPeriod.end = "2025-09-25"
* dispenseRequest.quantity = 28 '{tablet}' "tablets"
* substitution.allowedBoolean = false


* substitution.reason.text = "Narrow therapeutic index: product continuity required to keep INR stable."

// ====================================================================
// SCENARIO 8 (IE→SE) – Insulin Glargine + Aspart in Sweden
// ====================================================================

Instance: ie-org-se-apoteket-hjartat
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Pharmacy – Apoteket Hjärtat, Stockholm (SE)"
Description: "Swedish pharmacy in Stockholm where Seán Murphy's Irish ePrescription for insulin was dispensed (10 July 2025)."

* identifier[0].assigner.display = "Issuing authority in Sweden (illustrative)"
* identifier[=].value = "SE-APT-STO-001"
* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Apoteket Hjärtat"
* address[0].use = #work
* address[=].city = "Stockholm"
* address[=].country = "SE"



Instance: ie-rx-sean-se-insulin-glargine
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 8 (IE→SE) – Prescription: Insulin Glargine for Sweden"
Description: "Irish ePrescription for Insulin Glargine 100u/ml for Seán Murphy, transmitted via MyHealth@EU to Sweden."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2025-IE-SE-001"
* identifier[+].system = "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
* identifier[=].value = "IE/SE/1234567T"

* groupIdentifier.system = $NePS
* groupIdentifier.value = "IE-GP-RX-GROUP-20250710-SE"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"
* medicationReference = Reference(ie-medication-insulin-glargine)
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* requester = Reference(ie-mpd-practitioner-aoife-obrien) "Dr. Aoife O'Brien"
* authoredOn = "2025-07-05"
* reasonCode = $SCT#44054006 "Type 2 diabetes mellitus"
* dosageInstruction[0].text = "Inject 20 units subcutaneously once daily at bedtime"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].timing.repeat.when = #HS
* dosageInstruction[=].route = $SCT#34206005 "Subcutaneous route"
* dispenseRequest.validityPeriod.start = "2025-07-05"
* dispenseRequest.validityPeriod.end = "2025-10-05"
* dispenseRequest.quantity = 5 '{cartridge}' "cartridges"
* substitution.allowedBoolean = false


* substitution.reason.text = "Biological medicine: excluded from the HPRA List of Interchangeable Medicines (HIQA EP 3.5.10)."

// ====================================================================
// SCENARIO 9 (IE→AT) – Atorvastatin 80mg + Ramipril 10mg in Austria
// ====================================================================

Instance: ie-org-at-apotheke-goldene-kugel
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Pharmacy – Apotheke zur goldenen Kugel, Vienna (AT)"
Description: "Austrian pharmacy in Vienna where Seán Murphy's Irish ePrescription was dispensed (15 July 2025)."

* identifier[0].assigner.display = "Issuing authority in Austria (illustrative)"
* identifier[=].value = "AT-APO-WIE-001"
* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Apotheke zur goldenen Kugel"
* address[0].use = #work
* address[=].city = "Vienna"
* address[=].country = "AT"



Instance: ie-rx-sean-at-atorvastatin80
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 9 (IE→AT) – Prescription: Atorvastatin 80mg for Austria"
Description: "Irish ePrescription for Atorvastatin 80mg for Seán Murphy, transmitted via MyHealth@EU to Austria."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2025-IE-AT-001"
* identifier[+].system = "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
* identifier[=].value = "IE/AT/1234567T"

* groupIdentifier.system = $NePS
* groupIdentifier.value = "IE-GP-RX-GROUP-20250715-AT"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"
* medicationReference = Reference(ie-medication-atorvastatin-80)
* subject = Reference(ie-mpd-patient-sean-murphy) "Seán Murphy"
* requester = Reference(ie-mpd-practitioner-aoife-obrien) "Dr. Aoife O'Brien"
* authoredOn = "2025-07-10"
* reasonCode = $SCT#13644009 "Hypercholesterolemia"
* dosageInstruction[0].text = "Take one 80mg tablet once daily at night"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].timing.repeat.when = #CV
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dispenseRequest.validityPeriod.start = "2025-07-10"
* dispenseRequest.validityPeriod.end = "2025-10-10"
* dispenseRequest.quantity = 28 '{tablet}' "tablets"
* substitution.allowedBoolean = true



// ====================================================================
// INBOUND SCENARIO 10 – FINLAND → IRELAND (Mikko Korhonen via NePS)
// ====================================================================

Instance: ie-patient-fi-mikko-korhonen
InstanceOf: IEMpdPatientEPrescription
Usage: #example
Title: "Patient – Mikko Korhonen (Finnish citizen visiting Ireland)"
Description: "Finnish patient Mikko Korhonen visiting Dublin. His Finnish prescription for Metformin 500mg is dispensed at Hickey's Pharmacy, O'Connell Street via NePS."

* identifier[0].assigner.display = "Issuing authority in Finland (illustrative)"
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "FI-123456-7890"
* identifier[+].system = "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
* identifier[=].value = "FI/IE/123456-7890"

* active = true
* name[0].use = #official
* name[=].family = "Korhonen"
* name[=].given[0] = "Mikko"
* name[=].given[+] = "Tapani"
* gender = #male
* insert SexAssignedAtBirth(male, Male)
* birthDate = "1982-07-20"
* address[0].use = #home
* address[=].line = "Mannerheimintie 100 A 12"
* address[=].city = "Helsinki"
* address[=].state = "Uusimaa"
* address[=].country = "FI"
* communication[0].language = urn:ietf:bcp:47#fi "Finnish"
* communication[=].preferred = true
* communication[+].language = urn:ietf:bcp:47#en "English"



Instance: ie-org-ie-hickeys-pharmacy
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Pharmacy – Hickey's Pharmacy, O'Connell Street, Dublin"
Description: "Irish community pharmacy dispensing a Finnish cross-border prescription for Mikko Korhonen via NePS."

* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Hickey's Pharmacy"
* address[0].use = #work
* address[=].line = "O'Connell Street"
* address[=].city = "Dublin"
* address[=].country = "IE"



Instance: ie-rx-fi-metformin-neps
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 10 (FI→IE via NePS) – Finnish Prescription: Metformin 500mg"
Description: "Finnish ePrescription for Metformin 500mg for Mikko Korhonen, received via NePS for cross-border dispensation in Ireland."

* identifier[0].assigner.display = "Issuing authority in Finland (illustrative)"
* identifier[=].value = "FI-RX-2025-NEPS-001"
* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"
* medicationReference = Reference(ie-mpd-medication-metformin-500)
* subject = Reference(ie-patient-fi-mikko-korhonen) "Mikko Korhonen"
* requester = Reference(ie-mpd-practitioner-aoife-obrien) "Dr. Aoife O'Brien"
* authoredOn = "2025-07-20"
* reasonCode = $SCT#44054006 "Type 2 diabetes mellitus"
* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* dosageInstruction[=].timing.repeat.frequency = 2
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 500 'mg' "mg"
* dispenseRequest.validityPeriod.start = "2025-07-20"
* dispenseRequest.validityPeriod.end = "2025-10-20"
* dispenseRequest.quantity = 60 '{tablet}' "tablets"
* substitution.allowedBoolean = true



Instance: ie-dispense-fi-to-ie-neps
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 10 (FI→IE via NePS) – Irish Dispensation for Finnish Patient"
Description: "Hickey's Pharmacy, Dublin dispenses Metformin 500mg for Finnish patient Mikko Korhonen against a Finnish prescription received via NePS. The Finnish medication code (Kela/FIN) is mapped to an Irish NMPC code."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:aeae5757-1e8e-5c6a-884d-c6ce6dfffc37"
* identifier[+].assigner.display = "Issuing authority in Finland (illustrative)"
* identifier[=].value = "FI-RX-2025-NEPS-001"
* status = #completed
* extension[recorded].valueDateTime = "2025-08-01T14:00:00+01:00"

* medicationReference = Reference(ie-medication-dispensed-fi-to-ie-neps) "Metformin 500mg tablets"

* subject = Reference(ie-patient-fi-mikko-korhonen) "Mikko Korhonen"
* performer[0].actor = Reference(ie-org-ie-hickeys-pharmacy) "Hickey's Pharmacy"
* authorizingPrescription = Reference(ie-rx-fi-metformin-neps) "FI-RX-2025-NEPS-001"

* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 60 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"
* whenHandedOver = "2025-08-01T14:00:00+01:00"
* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* substitution.wasSubstituted = false



// ====================================================================
// INBOUND SCENARIO 11 – BELGIUM → IRELAND (Lars Janssen via NePS)
// ====================================================================

Instance: ie-patient-be-lars-janssen
InstanceOf: IEMpdPatientEPrescription
Usage: #example
Title: "Patient – Lars Janssen (Belgian citizen visiting Ireland)"
Description: "Belgian patient Lars Janssen visiting Dublin. His Belgian prescription for Atorvastatin 40mg is dispensed at McCauley's Pharmacy via NePS."

* identifier[0].assigner.display = "Issuing authority in Belgium (illustrative)"
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "BE-12345678901"
* identifier[+].system = "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
* identifier[=].value = "BE/IE/12345678901"

* active = true
* name[0].use = #official
* name[=].family = "Janssen"
* name[=].given = "Lars"
* name[=].prefix = "Mr."
* gender = #male
* insert SexAssignedAtBirth(male, Male)
* birthDate = "1970-05-10"
* address[0].use = #home
* address[=].line = "Rue de la Loi 200"
* address[=].city = "Brussels"
* address[=].state = "Brussels-Capital"
* address[=].country = "BE"
* communication[0].language = urn:ietf:bcp:47#nl "Dutch"
* communication[=].preferred = true
* communication[+].language = urn:ietf:bcp:47#en "English"



Instance: ie-org-ie-mccauleys-pharmacy
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Pharmacy – McCauley's Pharmacy, Grafton Street, Dublin"
Description: "Irish community pharmacy dispensing a Belgian cross-border prescription for Lars Janssen via NePS."

* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "McCauley's Pharmacy"
* address[0].use = #work
* address[=].line = "Grafton Street"
* address[=].city = "Dublin 2"
* address[=].country = "IE"



Instance: ie-rx-be-atorvastatin-neps
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 11 (BE→IE via NePS) – Belgian Prescription: Atorvastatin 40mg"
Description: "Belgian ePrescription for Atorvastatin 40mg for Lars Janssen, received via NePS for cross-border dispensation in Ireland."

* identifier[0].assigner.display = "Issuing authority in Belgium (illustrative)"
* identifier[=].value = "BE-RX-2025-NEPS-001"
* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"
* medicationReference = Reference(ie-medication-atorvastatin-40)
* subject = Reference(ie-patient-be-lars-janssen) "Lars Janssen"
* requester = Reference(ie-mpd-practitioner-aoife-obrien) "Dr. Aoife O'Brien"
* authoredOn = "2025-07-25"
* reasonCode = $SCT#13644009 "Hypercholesterolemia"
* dosageInstruction[0].text = "Take one 40mg tablet once daily at night"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].timing.repeat.when = #CV
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 40 'mg' "mg"
* dispenseRequest.validityPeriod.start = "2025-07-25"
* dispenseRequest.validityPeriod.end = "2025-10-25"
* dispenseRequest.quantity = 28 '{tablet}' "tablets"
* substitution.allowedBoolean = true



Instance: ie-dispense-be-to-ie-neps
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 11 (BE→IE via NePS) – Irish Dispensation for Belgian Patient"
Description: "McCauley's Pharmacy, Dublin dispenses Atorvastatin 40mg for Belgian patient Lars Janssen against a Belgian prescription received via NePS. Belgian CNPV medication code is mapped to an Irish NMPC code."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:586ef3ee-1f3f-5794-b912-88bfc8bd8a83"
* identifier[+].assigner.display = "Issuing authority in Belgium (illustrative)"
* identifier[=].value = "BE-RX-2025-NEPS-001"
* status = #completed
* extension[recorded].valueDateTime = "2025-08-05T11:30:00+01:00"

* medicationReference = Reference(ie-medication-dispensed-be-to-ie-neps) "Atorvastatin 40mg tablets"

* subject = Reference(ie-patient-be-lars-janssen) "Lars Janssen"
* performer[0].actor = Reference(ie-org-ie-mccauleys-pharmacy) "McCauley's Pharmacy"
* authorizingPrescription = Reference(ie-rx-be-atorvastatin-neps) "BE-RX-2025-NEPS-001"

* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 28 '{tablet}' "tablets"
* daysSupply = 28 'd' "days"
* whenHandedOver = "2025-08-05T11:30:00+01:00"
* dosageInstruction[0].text = "Take one 40mg tablet once daily at night"
* substitution.wasSubstituted = false


Instance: ie-medication-dispensed-de-metformin
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Metformin 500mg Filmtabletten (Ratiopharm) (as dispensed)"
Description: "The product actually dispensed in ie-dispense-de-metformin. HL7 Europe MPD requires a dispense to reference a Medication resource."
* code = $SCT#718271000220105 "Metformin hydrochloride 500 mg oral tablet"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.text = "Metformin 500mg Filmtabletten (Ratiopharm)"
* ingredient[0].itemCodeableConcept = $SCT#372567009 "Metformin"
* ingredient[=].isActive = true



Instance: ie-medication-dispensed-de-lisinopril
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Lisinopril 10mg Tabletten (Hexal) (as dispensed)"
Description: "The product actually dispensed in ie-dispense-de-lisinopril. HL7 Europe MPD requires a dispense to reference a Medication resource."
* code = $SCT#714701000220101 "Lisinopril 10 mg oral tablet"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.text = "Lisinopril 10mg Tabletten (Hexal)"
* ingredient[0].itemCodeableConcept = $SCT#386873009 "Lisinopril"
* ingredient[=].isActive = true



Instance: ie-medication-dispensed-lv-metformin
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Metformins 500mg tabletes (as dispensed)"
Description: "The product actually dispensed in ie-dispense-lv-metformin. HL7 Europe MPD requires a dispense to reference a Medication resource."
* code = $SCT#718271000220105 "Metformin hydrochloride 500 mg oral tablet"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.text = "Metformins 500mg tabletes"
* ingredient[0].itemCodeableConcept = $SCT#372567009 "Metformin"
* ingredient[=].isActive = true



Instance: ie-medication-dispensed-pt-sertraline
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Sertralina 50mg Comprimidos (as dispensed)"
Description: "The product actually dispensed in ie-dispense-pt-sertraline. HL7 Europe MPD requires a dispense to reference a Medication resource."
* code = $SCT#268301000220104 "Sertraline 50 mg oral tablet"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.text = "Sertralina 50mg Comprimidos"
* ingredient[0].itemCodeableConcept = $SCT#372594008 "Sertraline"
* ingredient[=].isActive = true



Instance: ie-medication-dispensed-fi-to-ie-neps
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Metformin 500mg tablets (as dispensed)"
Description: "The product actually dispensed in ie-dispense-fi-to-ie-neps. HL7 Europe MPD requires a dispense to reference a Medication resource."
* code = $SCT#718271000220105 "Metformin hydrochloride 500 mg oral tablet"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.text = "Metformin 500mg tablets"
* ingredient[0].itemCodeableConcept = $SCT#372567009 "Metformin"
* ingredient[=].isActive = true



Instance: ie-medication-dispensed-be-to-ie-neps
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Atorvastatin 40mg tablets (as dispensed)"
Description: "The product actually dispensed in ie-dispense-be-to-ie-neps. HL7 Europe MPD requires a dispense to reference a Medication resource."
* code = $SCT#254331000220107 "Atorvastatin 40 mg oral tablet"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.text = "Atorvastatin 40mg tablets"
* ingredient[0].itemCodeableConcept = $SCT#373444002 "Atorvastatin"
* ingredient[=].isActive = true



Instance: ie-medication-atorvastatin-40
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Atorvastatin 40mg tablets"
Description: "The product prescribed in ie-rx-be-atorvastatin-neps. The NMPC code is the NMPC VMP (SNOMED CT Irish Edition), verified in the NMPC Meds Catalogue."
* code = $SCT#254331000220107 "Atorvastatin 40 mg oral tablet"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.coding[+] = $SCT#373444002 "Atorvastatin"
* code.text = "Atorvastatin 40mg tablets"
* form = $SCT#385055001 "Tablet"
* ingredient[0].itemCodeableConcept = $SCT#373444002 "Atorvastatin"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 40 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{tablet}' "tablet"

// ═══ from IE Core examples/MedicationExamples.fsh ═══



Instance: ie-mpd-medication-ramipril-5
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Ramipril 5mg Capsules"
Description: "Ramipril 5mg capsules (generic), coded with the NMPC VMP (SNOMED CT Irish Edition) as the primary code and the International SNOMED CT substance as a secondary code."

* code = $SCT#716371000220101 "Ramipril 5 mg oral capsule"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.coding[+] = $SCT#386872004 "Ramipril"
* code.text = "Ramipril 5mg capsules"
* form = $SCT#385049006 "Capsule"
* amount.numerator = 28 '{capsule}' "capsules"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#386872004 "Ramipril"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 5 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{capsule}' "capsule"



Instance: ie-mpd-medication-amlodipine-5
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Amlodipine 5mg Tablets"
Description: "Amlodipine 5mg tablets (generic), coded with the NMPC VMP (SNOMED CT Irish Edition) as the primary code and the International SNOMED CT substance as a secondary code. Used in cross-border dispensing scenario."

* code = $SCT#267451000220105 "Amlodipine 5 mg oral tablet"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.coding[+] = $SCT#386864001 "Amlodipine"
* code.text = "Amlodipine 5mg tablets"
* form = $SCT#385055001 "Tablet"
* amount.numerator = 30 '{tablet}' "tablets"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#386864001 "Amlodipine"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 5 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{tablet}' "tablet"



// ====================================================================
// SUPPORTING RESOURCES – IRISH PHARMACY
// ====================================================================

Instance: ie-mpd-organization-pharmacy-example
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Irish Pharmacy – Boots Pharmacy Grafton Street"
Description: "An example Irish community pharmacy (Boots Pharmacy, Dublin), acting as dispenser."


* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Boots Pharmacy – Grafton Street"

* telecom[0].system = #phone
* telecom[=].value = "+353 1 677 6462"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "grafton@boots.ie"
* telecom[=].use = #work

* address[0].use = #work
* address[=].type = #physical
* address[=].line[0] = "14 Grafton Street"
* address[=].city = "Dublin"
* address[=].state = "Dublin"
* address[=].postalCode = "D02 HH74"
* address[=].country = "IE"



Instance: ie-mpd-practitioner-pharmacist-example
InstanceOf: IEMpdPractitioner
Usage: #example
Title: "IE MPD Practitioner – Pharmacist Niamh Brennan"
Description: "An example Irish registered pharmacist dispensing medication in Dublin."

* identifier[0].system = "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/psi"
* identifier[=].type = $V2-0203#MD "Medical License number"
* identifier[=].value = "PSI-54321"

* active = true
* name[0].use = #official
* name[=].family = "Brennan"
* name[=].given = "Niamh"
* name[=].prefix = "Ms."
* gender = #female

* telecom[0].system = #phone
* telecom[=].value = "+353 1 677 6462"
* telecom[=].use = #work
* telecom[+].system = #email
* telecom[=].value = "niamh.brennan@boots.ie"
* telecom[=].use = #work

* address[0].use = #work
* address[=].line = "14 Grafton Street"
* address[=].city = "Dublin"
* address[=].postalCode = "D02 HH74"
* address[=].country = "IE"

* qualification[0].code = $SCT#46255001 "Pharmacist"
* qualification[=].issuer.display = "Pharmaceutical Society of Ireland"



// ====================================================================
// SUPPORTING RESOURCES – CROSS-BORDER (SPAIN)
// ====================================================================

Instance: ie-mpd-patient-es-maria-garcia
InstanceOf: IEMpdPatientEPrescription
Usage: #example
Title: "Spanish Patient – María García López (visiting Ireland)"
Description: "A Spanish patient visiting Ireland. Carries a Spanish CIP identifier and European Health Insurance Card (EHIC). Holds a prescription from a Spanish GP to be dispensed in Ireland."

* identifier[0].assigner.display = "Issuing authority in Spain (illustrative)"
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "ES280000000000000012"

* identifier[+].assigner.display = "Issuing authority in Spain (illustrative)"
* identifier[=].type = $V2-0203#PN "Person number"
* identifier[=].value = "ES-28-12345678X"

* active = true
* name[0].use = #official
* name[=].family = "García López"
* name[=].given[0] = "María"
* name[=].given[+] = "Concepción"
* name[=].prefix = "Sra."
* gender = #female
* insert SexAssignedAtBirth(female, Female)
* birthDate = "1975-08-22"

* address[0].use = #home
* address[=].type = #physical
* address[=].line = "Calle Gran Vía 45, 2º A"
* address[=].city = "Madrid"
* address[=].state = "Madrid"
* address[=].postalCode = "28013"
* address[=].country = "ES"

* telecom[0].system = #phone
* telecom[=].value = "+34 91 555 1234"
* telecom[=].use = #home
* telecom[+].system = #email
* telecom[=].value = "maria.garcia@example.es"
* telecom[=].use = #home

* communication[0].language = urn:ietf:bcp:47#es "Spanish"
* communication[=].preferred = true
* communication[+].language = urn:ietf:bcp:47#en "English"



Instance: ie-mpd-practitioner-es-example
InstanceOf: IEMpdPractitioner
Usage: #example
Title: "Spanish Practitioner – Dr. Alejandro Martínez Ruiz"
Description: "A Spanish GP who issued a prescription for a Spanish patient, to be dispensed cross-border in Ireland via MyHealth@EU."

* identifier[0].assigner.display = "Issuing authority in Spain (illustrative)"
* identifier[=].type = $V2-0203#MD "Medical License number"
* identifier[=].value = "ES-COL-28-001234"

* active = true
* name[0].use = #official
* name[=].family = "Martínez Ruiz"
* name[=].given[0] = "Alejandro"
* name[=].prefix = "Dr."
* gender = #male

* telecom[0].system = #phone
* telecom[=].value = "+34 91 555 6789"
* telecom[=].use = #work

* address[0].use = #work
* address[=].line = "Centro de Salud Las Águilas, Calle Serrano 12"
* address[=].city = "Madrid"
* address[=].postalCode = "28006"
* address[=].country = "ES"

* qualification[0].code = $SCT#62247001 "General practitioner"
* qualification[=].issuer.display = "Consejo General de Colegios Oficiales de Médicos de España"



Instance: ie-mpd-organization-es-health-centre
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Spanish Health Centre – Centro de Salud Las Águilas, Madrid"
Description: "The Spanish primary care centre where the Spanish GP practises and issued the cross-border prescription."

* identifier[0].assigner.display = "Issuing authority in Spain (illustrative)"
* identifier[=].value = "ES-CS-28-001234"

* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Centro de Salud Las Águilas"

* telecom[0].system = #phone
* telecom[=].value = "+34 91 555 6789"
* telecom[=].use = #work

* address[0].use = #work
* address[=].type = #physical
* address[=].line = "Calle Serrano 12"
* address[=].city = "Madrid"
* address[=].postalCode = "28006"
* address[=].country = "ES"



Instance: ie-mpd-organization-es-pharmacy
InstanceOf: IEMpdOrganization
Usage: #example
Title: "Spanish Pharmacy – Farmacia Avenida de América, Madrid"
Description: "A Spanish community pharmacy in Madrid that dispenses a cross-border prescription for an Irish patient traveling in Spain."

* identifier[0].assigner.display = "Issuing authority in Spain (illustrative)"
* identifier[=].value = "ES-OF-28-009876"

* active = true
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* name = "Farmacia Avenida de América"

* telecom[0].system = #phone
* telecom[=].value = "+34 91 555 3456"
* telecom[=].use = #work

* address[0].use = #work
* address[=].type = #physical
* address[=].line = "Avenida de América 34"
* address[=].city = "Madrid"
* address[=].postalCode = "28028"
* address[=].country = "ES"



Instance: ie-mpd-practitioner-es-pharmacist
InstanceOf: IEMpdPractitioner
Usage: #example
Title: "Spanish Pharmacist – Dra. Carmen Vega Soto"
Description: "A Spanish pharmacist dispensing a cross-border prescription from Ireland (Scenario 4: IE→ES)."

* identifier[0].assigner.display = "Issuing authority in Spain (illustrative)"
* identifier[=].type = $V2-0203#MD "Medical License number"
* identifier[=].value = "ES-CF-28-005678"

* active = true
* name[0].use = #official
* name[=].family = "Vega Soto"
* name[=].given = "Carmen"
* name[=].prefix = "Dra."
* gender = #female

* qualification[0].code = $SCT#46255001 "Pharmacist"
* qualification[=].issuer.display = "Consejo General de Colegios Oficiales de Farmacéuticos"



// ====================================================================
// SCENARIO 1 – Local IE: Full Dispensing of a Single Prescription
// Patient: John Murphy | Rx: Metformin 500mg (60 tabs, 30-day supply)
// ====================================================================

Instance: ie-prescription-scenario1-full
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 1 – IE Local Prescription: Metformin (Full Dispense)"
Description: "A standard Irish GP prescription for Metformin 500mg tablets. Authorised via PCRS. Intended for a single full dispensation."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2024-001001"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"

* medicationReference = Reference(ie-mpd-medication-metformin-500)

* subject = Reference(ie-mpd-patient-example) "John Murphy"
* encounter = Reference(ie-mpd-encounter-example) "Ambulatory encounter 2024-06-15"
* authoredOn = "2024-06-15"
* requester = Reference(ie-mpd-practitioner-example) "Dr. Sarah O'Brien"

* reasonCode = $SCT#44054006 "Type 2 diabetes mellitus"

* dosageInstruction[0].sequence = 1
* dosageInstruction[=].text = "Take one 500mg tablet twice daily with meals"
* dosageInstruction[=].timing.repeat.frequency = 2
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 500 'mg' "mg"

* dispenseRequest.validityPeriod.start = "2024-06-15"
* dispenseRequest.validityPeriod.end = "2024-07-15"
* dispenseRequest.numberOfRepeatsAllowed = 0
* dispenseRequest.quantity = 60 '{tablet}' "tablets"
* dispenseRequest.expectedSupplyDuration = 30 'd' "days"

* substitution.allowedBoolean = true



Instance: ie-dispense-scenario1-full
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 1 – IE Local Dispense: Metformin Full Dispensation"
Description: "Full dispensation of 60 Metformin 500mg tablets against Scenario 1 prescription. Dispensed in full at Boots Pharmacy Dublin."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:a9dc5d22-9f2a-572c-a80d-9a0e1fa7095a"

* status = #completed
* extension[recorded].valueDateTime = "2024-06-15T14:15:00+01:00"
* medicationReference = Reference(ie-mpd-medication-metformin-500)

* subject = Reference(ie-mpd-patient-example) "John Murphy"
* context = Reference(ie-mpd-encounter-example) "Ambulatory encounter 2024-06-15"

* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"

* authorizingPrescription = Reference(ie-prescription-scenario1-full) "PCRS-RX-2024-001001"

* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 60 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"

* whenPrepared = "2024-06-15T14:00:00+01:00"
* whenHandedOver = "2024-06-15T14:15:00+01:00"

* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* dosageInstruction[=].timing.repeat.frequency = 2
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"

* substitution.wasSubstituted = false



// ====================================================================
// SCENARIO 2 – Local IE: Partial Dispensing (Atorvastatin 20mg, 90 tabs)
// 3 dispensations of 30 tabs each over 3 months
// ====================================================================

Instance: ie-prescription-scenario2-partial
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 2 – IE Local Prescription: Atorvastatin (Partial Dispense)"
Description: "An Irish GP prescription for Atorvastatin 20mg tablets (90 days supply). Intended to be dispensed in three partial dispensations of 30 tablets each, reflecting typical Irish community pharmacy dispensing for long-term medication."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2024-002001"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"

* medicationReference = Reference(ie-mpd-medication-atorvastatin-20)

* subject = Reference(ie-mpd-patient-example) "John Murphy"
* encounter = Reference(ie-mpd-encounter-example) "Ambulatory encounter 2024-06-15"
* authoredOn = "2024-06-15"
* requester = Reference(ie-mpd-practitioner-example) "Dr. Sarah O'Brien"

* reasonCode = $SCT#55822004 "Hyperlipidemia"

* dosageInstruction[0].sequence = 1
* dosageInstruction[=].text = "Take one 20mg tablet once daily at night"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].timing.repeat.when = #CV
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 20 'mg' "mg"

* dispenseRequest.validityPeriod.start = "2024-06-15"
* dispenseRequest.validityPeriod.end = "2024-09-15"
* dispenseRequest.numberOfRepeatsAllowed = 2
* dispenseRequest.quantity = 90 '{tablet}' "tablets"
* dispenseRequest.expectedSupplyDuration = 90 'd' "days"

* substitution.allowedBoolean = true



Instance: ie-dispense-scenario2-partial-1
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 2 – Partial Dispense 1 of 3: Atorvastatin 30 tabs (Month 1)"
Description: "First partial dispensation of 30 Atorvastatin 20mg tablets (of 90 prescribed) on 15 June 2024."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:78c02acf-0df9-5ce5-9817-faf4bd1822f8"

* status = #completed
* extension[recorded].valueDateTime = "2024-06-15T14:45:00+01:00"
* medicationReference = Reference(ie-mpd-medication-atorvastatin-20)
* subject = Reference(ie-mpd-patient-example) "John Murphy"

* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"

* authorizingPrescription = Reference(ie-prescription-scenario2-partial) "PCRS-RX-2024-002001"

* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#FFP "First Fill - Part Fill"
* quantity = 30 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"

* whenPrepared = "2024-06-15T14:30:00+01:00"
* whenHandedOver = "2024-06-15T14:45:00+01:00"

* dosageInstruction[0].text = "Take one 20mg tablet once daily at night"
* substitution.wasSubstituted = false



Instance: ie-dispense-scenario2-partial-2
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 2 – Partial Dispense 2 of 3: Atorvastatin 30 tabs (Month 2)"
Description: "Second partial dispensation of 30 Atorvastatin 20mg tablets on 15 July 2024."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:b7060eb6-2321-5acb-8a54-2e7b5cc24e9e"

* status = #completed
* extension[recorded].valueDateTime = "2024-07-15T10:10:00+01:00"
* medicationReference = Reference(ie-mpd-medication-atorvastatin-20)
* subject = Reference(ie-mpd-patient-example) "John Murphy"

* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"

* authorizingPrescription = Reference(ie-prescription-scenario2-partial) "PCRS-RX-2024-002001"

* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#FFP "First Fill - Part Fill"
* quantity = 30 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"

* whenPrepared = "2024-07-15T10:00:00+01:00"
* whenHandedOver = "2024-07-15T10:10:00+01:00"

* dosageInstruction[0].text = "Take one 20mg tablet once daily at night"
* substitution.wasSubstituted = false



Instance: ie-dispense-scenario2-partial-3
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 2 – Partial Dispense 3 of 3: Atorvastatin 30 tabs (Month 3 – Final)"
Description: "Third and final partial dispensation of 30 Atorvastatin 20mg tablets on 15 August 2024. Completes the full 90-tablet prescription."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:bad0b4fb-68aa-5cb2-92ad-1505112c1699"

* status = #completed
* extension[recorded].valueDateTime = "2024-08-15T11:10:00+01:00"
* medicationReference = Reference(ie-mpd-medication-atorvastatin-20)
* subject = Reference(ie-mpd-patient-example) "John Murphy"

* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"

* authorizingPrescription = Reference(ie-prescription-scenario2-partial) "PCRS-RX-2024-002001"

* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#FFP "First Fill - Part Fill"
* quantity = 30 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"

* whenPrepared = "2024-08-15T11:00:00+01:00"
* whenHandedOver = "2024-08-15T11:10:00+01:00"

* dosageInstruction[0].text = "Take one 20mg tablet once daily at night"
* substitution.wasSubstituted = false



// ====================================================================
// SCENARIO 3 – Multiple Prescriptions in a Single Bundle
// Patient: John Murphy | Rx: Metformin + Atorvastatin + Ramipril
// ====================================================================

Instance: ie-prescription-scenario3-multi-metformin
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 3 – Multi-Rx Bundle: Metformin 500mg"
Description: "First of three prescriptions in a multi-prescription bundle for John Murphy. Metformin for Type 2 Diabetes."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2024-003001"

* groupIdentifier.system = $NePS
* groupIdentifier.value = "IE-GP-RX-GROUP-20240620"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"

* medicationReference = Reference(ie-mpd-medication-metformin-500)

* subject = Reference(ie-mpd-patient-example) "John Murphy"
* authoredOn = "2024-06-20"
* requester = Reference(ie-mpd-practitioner-example) "Dr. Sarah O'Brien"

* reasonCode = $SCT#44054006 "Type 2 diabetes mellitus"

* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* dosageInstruction[=].timing.repeat.frequency = 2
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 500 'mg' "mg"

* dispenseRequest.validityPeriod.start = "2024-06-20"
* dispenseRequest.validityPeriod.end = "2024-07-20"
* dispenseRequest.numberOfRepeatsAllowed = 5
* dispenseRequest.quantity = 60 '{tablet}' "tablets"
* dispenseRequest.expectedSupplyDuration = 30 'd' "days"

* substitution.allowedBoolean = true



Instance: ie-prescription-scenario3-multi-atorvastatin
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 3 – Multi-Rx Bundle: Atorvastatin 20mg"
Description: "Second of three prescriptions in a multi-prescription bundle for John Murphy. Atorvastatin for hyperlipidaemia."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2024-003002"

* groupIdentifier.system = $NePS
* groupIdentifier.value = "IE-GP-RX-GROUP-20240620"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"

* medicationReference = Reference(ie-mpd-medication-atorvastatin-20)

* subject = Reference(ie-mpd-patient-example) "John Murphy"
* authoredOn = "2024-06-20"
* requester = Reference(ie-mpd-practitioner-example) "Dr. Sarah O'Brien"

* reasonCode = $SCT#55822004 "Hyperlipidemia"

* dosageInstruction[0].text = "Take one 20mg tablet once daily at night"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 20 'mg' "mg"

* dispenseRequest.validityPeriod.start = "2024-06-20"
* dispenseRequest.validityPeriod.end = "2024-09-20"
* dispenseRequest.numberOfRepeatsAllowed = 2
* dispenseRequest.quantity = 30 '{tablet}' "tablets"
* dispenseRequest.expectedSupplyDuration = 30 'd' "days"

* substitution.allowedBoolean = true



Instance: ie-prescription-scenario3-multi-ramipril
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 3 – Multi-Rx Bundle: Ramipril 5mg"
Description: "Third of three prescriptions in a multi-prescription bundle for John Murphy. Ramipril for hypertension/cardiac protection."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2024-003003"

* groupIdentifier.system = $NePS
* groupIdentifier.value = "IE-GP-RX-GROUP-20240620"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"

* medicationReference = Reference(ie-mpd-medication-ramipril-5)

* subject = Reference(ie-mpd-patient-example) "John Murphy"
* authoredOn = "2024-06-20"
* requester = Reference(ie-mpd-practitioner-example) "Dr. Sarah O'Brien"

* reasonCode = $SCT#38341003 "Hypertensive disorder"

* dosageInstruction[0].text = "Take one 5mg capsule once daily in the morning"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].timing.repeat.when = #MORN
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 5 'mg' "mg"

* dispenseRequest.validityPeriod.start = "2024-06-20"
* dispenseRequest.validityPeriod.end = "2024-07-20"
* dispenseRequest.numberOfRepeatsAllowed = 5
* dispenseRequest.quantity = 28 '{capsule}' "capsules"
* dispenseRequest.expectedSupplyDuration = 28 'd' "days"

* substitution.allowedBoolean = true



Instance: ie-dispense-scenario3-metformin
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 3 – Multi-Rx Bundle Dispense: Metformin"
Description: "Full dispensation of Metformin 60 tablets from the multi-prescription bundle."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:01e9a85d-dda3-5e89-be48-1d11c15f1fbb"

* status = #completed
* extension[recorded].valueDateTime = "2024-06-20T16:15:00+01:00"
* medicationReference = Reference(ie-mpd-medication-metformin-500)
* subject = Reference(ie-mpd-patient-example) "John Murphy"
* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"
* authorizingPrescription = Reference(ie-prescription-scenario3-multi-metformin)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 60 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"
* whenPrepared = "2024-06-20T16:00:00+01:00"
* whenHandedOver = "2024-06-20T16:15:00+01:00"
* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* substitution.wasSubstituted = false



Instance: ie-dispense-scenario3-atorvastatin
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 3 – Multi-Rx Bundle Dispense: Atorvastatin"
Description: "Full dispensation of Atorvastatin 30 tablets from the multi-prescription bundle."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:c6fc7058-03f4-588b-b422-146e8b270306"

* status = #completed
* extension[recorded].valueDateTime = "2024-06-20T16:15:00+01:00"
* medicationReference = Reference(ie-mpd-medication-atorvastatin-20)
* subject = Reference(ie-mpd-patient-example) "John Murphy"
* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"
* authorizingPrescription = Reference(ie-prescription-scenario3-multi-atorvastatin)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 30 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"
* whenPrepared = "2024-06-20T16:00:00+01:00"
* whenHandedOver = "2024-06-20T16:15:00+01:00"
* dosageInstruction[0].text = "Take one 20mg tablet once daily at night"
* substitution.wasSubstituted = false



Instance: ie-dispense-scenario3-ramipril
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 3 – Multi-Rx Bundle Dispense: Ramipril"
Description: "Full dispensation of Ramipril 28 capsules from the multi-prescription bundle."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:ef574470-9c37-575b-9bd2-8ffffea92e24"

* status = #completed
* extension[recorded].valueDateTime = "2024-06-20T16:15:00+01:00"
* medicationReference = Reference(ie-mpd-medication-ramipril-5)
* subject = Reference(ie-mpd-patient-example) "John Murphy"
* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"
* authorizingPrescription = Reference(ie-prescription-scenario3-multi-ramipril)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 28 '{capsule}' "capsules"
* daysSupply = 28 'd' "days"
* whenPrepared = "2024-06-20T16:00:00+01:00"
* whenHandedOver = "2024-06-20T16:15:00+01:00"
* dosageInstruction[0].text = "Take one 5mg capsule once daily in the morning"
* substitution.wasSubstituted = false



// ====================================================================
// SCENARIO 4 – Cross-border IE → ES
// Irish patient Ciarán Walsh travels to Spain, presents his Irish
// repeat prescription for Amlodipine to a Spanish pharmacy.
// Cross-border via MyHealth@EU / eHDSI NCP
// ====================================================================

Instance: ie-mpd-patient-ciaran-walsh
InstanceOf: IEMpdPatientEPrescription
Usage: #example
Title: "Irish Patient – Ciarán Walsh (traveling in Spain)"
Description: "An Irish patient with a chronic prescription for Amlodipine who is visiting Spain and seeks dispensation at a Spanish pharmacy via MyHealth@EU."

* identifier[0].system = $IHI
* identifier[=].type = $V2-0203#NI "National unique individual identifier"
* identifier[=].value = "210000000055667788"

* insert PCRSIdentifier($GMS, medical-card, Medical card scheme number, MC-0055667)

* active = true
* name[0].use = #official
* name[=].family = "Walsh"
* name[=].given[0] = "Ciarán"
* name[=].given[+] = "Seamus"
* name[=].prefix = "Mr."
* gender = #male
* insert SexAssignedAtBirth(male, Male)
* birthDate = "1968-11-03"

* address[0].use = #home
* address[=].type = #physical
* address[=].line = "22 Clontarf Road"
* address[=].city = "Dublin"
* address[=].state = "Dublin"
* address[=].postalCode = "D03 YP78"
* address[=].country = "IE"

* telecom[0].system = #phone
* telecom[=].value = "+353 87 654 3210"
* telecom[=].use = #mobile

* communication[0].language = urn:ietf:bcp:47#en "English"
* communication[=].preferred = true
* communication[+].language = urn:ietf:bcp:47#ga "Irish"



Instance: ie-prescription-scenario4-ie-to-es
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 4 – Cross-border IE→ES: Amlodipine Repeat Prescription"
Description: "An Irish ePrescription for Amlodipine 5mg (chronic hypertension, repeat prescription) issued by an Irish GP. This prescription is transmitted via the MyHealth@EU infrastructure (IE NCP → ES NCP) for dispensation at a Spanish pharmacy. The prescription is tagged as cross-border eligible."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2024-004001"

* identifier[+].system = "urn:oid:2.16.840.1.113883.19.1.4.1"
* identifier[=].value = "IE-EHIC-XB-2024-004001"

* status = #active
* intent = #order
* category[0] = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"

* medicationReference = Reference(ie-mpd-medication-amlodipine-5)

* subject = Reference(ie-mpd-patient-ciaran-walsh) "Ciarán Walsh"
* authoredOn = "2024-07-10"
* requester = Reference(ie-mpd-practitioner-example) "Dr. Sarah O'Brien"

* reasonCode = $SCT#38341003 "Hypertensive disorder"

* dosageInstruction[0].text = "Take one 5mg tablet once daily"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 5 'mg' "mg"

* dispenseRequest.validityPeriod.start = "2024-07-10"
* dispenseRequest.validityPeriod.end = "2024-10-10"
* dispenseRequest.numberOfRepeatsAllowed = 2
* dispenseRequest.quantity = 30 '{tablet}' "tablets"
* dispenseRequest.expectedSupplyDuration = 30 'd' "days"

* substitution.allowedBoolean = true
* substitution.reason = $SCT#373873005 "Pharmaceutical / biologic product"



Instance: ie-dispense-scenario4-es-pharmacy
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 4 – Cross-border IE→ES: Spanish Dispensation of Irish Prescription"
Description: "A Spanish pharmacy dispenses Amlodipine 5mg (30 tablets) against the Irish cross-border ePrescription for Ciarán Walsh, via MyHealth@EU. The Spanish pharmacist substituted with a locally available generic equivalent (Norvasc generic, ES market)."

* identifier[0].assigner.display = "Issuing authority in Spain (illustrative)"
* identifier[=].value = "ES-DISP-2024-XB-004001"

* status = #completed
* extension[recorded].valueDateTime = "2024-07-28T11:45:00+02:00"
* medicationReference = Reference(ie-mpd-medication-amlodipine-5)

* subject = Reference(ie-mpd-patient-ciaran-walsh) "Ciarán Walsh"

* performer[0].actor = Reference(ie-mpd-practitioner-es-pharmacist) "Dra. Carmen Vega Soto"

* authorizingPrescription = Reference(ie-prescription-scenario4-ie-to-es) "PCRS-RX-2024-004001"

* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 30 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"

* whenPrepared = "2024-07-28T11:30:00+02:00"
* whenHandedOver = "2024-07-28T11:45:00+02:00"

* dosageInstruction[0].text = "Tomar un comprimido de 5mg una vez al día (Take one 5mg tablet once daily)"

* substitution.wasSubstituted = true
* substitution.type = http://terminology.hl7.org/CodeSystem/v3-substanceAdminSubstitution#G "Generic composition"
* substitution.reason = $SCT#373873005 "Pharmaceutical / biologic product"
* substitution.responsibleParty = Reference(ie-mpd-practitioner-es-pharmacist) "Dra. Carmen Vega Soto"



// ====================================================================
// SCENARIO 5 – Cross-border ES → IE
// Spanish patient María García López visits Ireland and presents her
// Spanish prescription for Amlodipine to an Irish pharmacy.
// ====================================================================

Instance: ie-prescription-scenario5-es-to-ie
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 5 – Cross-border ES→IE: Spanish Prescription for Amlodipine"
Description: "A Spanish ePrescription for Amlodipine 5mg issued by a Spanish GP for María García López. This prescription has been converted to FHIR format by the Spanish NCP (Punto de Contacto Nacional) for cross-border dispensation in Ireland via MyHealth@EU."

* identifier[0].assigner.display = "Issuing authority in Spain (illustrative)"
* identifier[=].value = "ES-RX-2024-28-987654321"

* identifier[+].system = "urn:oid:2.16.840.1.113883.19.1.4.1"
* identifier[=].value = "ES-EHIC-XB-2024-005001"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"

* medicationReference = Reference(ie-mpd-medication-amlodipine-5)

* subject = Reference(ie-mpd-patient-es-maria-garcia) "María García López"
* authoredOn = "2024-08-01"
* requester = Reference(ie-mpd-practitioner-es-example) "Dr. Alejandro Martínez Ruiz"

* reasonCode = $SCT#38341003 "Hypertensive disorder"

* dosageInstruction[0].text = "Take one 5mg tablet once daily (Tomar un comprimido de 5mg una vez al día)"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 5 'mg' "mg"

* dispenseRequest.validityPeriod.start = "2024-08-01"
* dispenseRequest.validityPeriod.end = "2024-11-01"
* dispenseRequest.numberOfRepeatsAllowed = 2
* dispenseRequest.quantity = 30 '{tablet}' "tablets"
* dispenseRequest.expectedSupplyDuration = 30 'd' "days"

* substitution.allowedBoolean = true



Instance: ie-dispense-scenario5-ie-pharmacy
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 5 – Cross-border ES→IE: Irish Dispensation of Spanish Prescription"
Description: "An Irish pharmacy (Boots, Grafton St.) dispenses Amlodipine 5mg tablets against the Spanish cross-border ePrescription for María García López, via MyHealth@EU. Equivalent Irish-licensed generic dispensed."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:5e1bdde6-bcfa-5b15-a743-a84cc30cb567"

* status = #completed
* extension[recorded].valueDateTime = "2024-08-12T14:15:00+01:00"
* medicationReference = Reference(ie-mpd-medication-amlodipine-5)

* subject = Reference(ie-mpd-patient-es-maria-garcia) "María García López"

* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"

* authorizingPrescription = Reference(ie-prescription-scenario5-es-to-ie) "ES-RX-2024-28-987654321"

* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#DF "Daily Fill"
* quantity = 30 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"

* whenPrepared = "2024-08-12T14:00:00+01:00"
* whenHandedOver = "2024-08-12T14:15:00+01:00"

* dosageInstruction[0].text = "Take one 5mg tablet once daily"
* dosageInstruction[=].timing.repeat.frequency = 1
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"

* substitution.wasSubstituted = false



// ====================================================================
// SCENARIO 6 – Repeat Prescription with Multiple Sequential Dispensations
// Patient: John Murphy | Rx: Metformin 500mg | 6-month GMS repeat
// ====================================================================

Instance: ie-prescription-scenario6-repeat
InstanceOf: IEMpdMedicationRequestEPrescription
Usage: #example
Title: "Scenario 6 – Repeat Prescription: Metformin 500mg (6-month GMS)"
Description: "A GMS repeat prescription for Metformin 500mg tablets, valid for 6 months with up to 6 dispensation events (once monthly). Represents a typical Irish GMS chronic disease management prescription under the Drugs Payment Scheme."

* identifier[0].system = $NePS
* identifier[=].value = "PCRS-RX-2024-006001"

* status = #active
* intent = #order
* category = http://terminology.hl7.org/CodeSystem/medicationrequest-category#community "Community"

* medicationReference = Reference(ie-mpd-medication-metformin-500)

* subject = Reference(ie-mpd-patient-example) "John Murphy"
* authoredOn = "2024-01-10"
* requester = Reference(ie-mpd-practitioner-example) "Dr. Sarah O'Brien"

* reasonCode = $SCT#44054006 "Type 2 diabetes mellitus"

* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* dosageInstruction[=].timing.repeat.frequency = 2
* dosageInstruction[=].timing.repeat.period = 1
* dosageInstruction[=].timing.repeat.periodUnit = #d
* dosageInstruction[=].route = $SCT#26643006 "Oral route"
* dosageInstruction[=].doseAndRate[0].doseQuantity = 500 'mg' "mg"

* dispenseRequest.validityPeriod.start = "2024-01-10"
* dispenseRequest.validityPeriod.end = "2024-07-10"
* dispenseRequest.numberOfRepeatsAllowed = 5
* dispenseRequest.quantity = 60 '{tablet}' "tablets"
* dispenseRequest.expectedSupplyDuration = 30 'd' "days"

* substitution.allowedBoolean = true



Instance: ie-dispense-scenario6-repeat-month1
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 6 – Repeat Dispense Month 1: Metformin January 2024"
Description: "First monthly dispensation of Metformin under the 6-month GMS repeat prescription."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:4bce74bd-d3e9-5abe-bd68-e8f4f2948235"
* status = #completed
* extension[recorded].valueDateTime = "2024-01-10T10:00:00+00:00"
* medicationReference = Reference(ie-mpd-medication-metformin-500)
* subject = Reference(ie-mpd-patient-example) "John Murphy"
* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"
* authorizingPrescription = Reference(ie-prescription-scenario6-repeat)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#FF "First Fill"
* quantity = 60 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"
* whenHandedOver = "2024-01-10T10:00:00+00:00"
* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* substitution.wasSubstituted = false



Instance: ie-dispense-scenario6-repeat-month2
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 6 – Repeat Dispense Month 2: Metformin February 2024"
Description: "Second monthly dispensation of Metformin under the 6-month GMS repeat prescription."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:588df126-7401-5a6a-a093-2614f9004cfa"
* status = #completed
* extension[recorded].valueDateTime = "2024-02-10T10:30:00+00:00"
* medicationReference = Reference(ie-mpd-medication-metformin-500)
* subject = Reference(ie-mpd-patient-example) "John Murphy"
* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"
* authorizingPrescription = Reference(ie-prescription-scenario6-repeat)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#RF "Refill"
* quantity = 60 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"
* whenHandedOver = "2024-02-10T10:30:00+00:00"
* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* substitution.wasSubstituted = false



Instance: ie-dispense-scenario6-repeat-month3
InstanceOf: IEMpdMedicationDispenseEDispensation
Usage: #example
Title: "Scenario 6 – Repeat Dispense Month 3: Metformin March 2024"
Description: "Third monthly dispensation of Metformin under the 6-month GMS repeat prescription."

* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:99b94ff3-f0f5-5dac-969e-6da879f7a856"
* status = #completed
* extension[recorded].valueDateTime = "2024-03-10T09:15:00+00:00"
* medicationReference = Reference(ie-mpd-medication-metformin-500)
* subject = Reference(ie-mpd-patient-example) "John Murphy"
* performer[0].actor = Reference(ie-mpd-practitioner-pharmacist-example) "Niamh Brennan"
* authorizingPrescription = Reference(ie-prescription-scenario6-repeat)
* type = http://terminology.hl7.org/CodeSystem/v3-ActCode#RF "Refill"
* quantity = 60 '{tablet}' "tablets"
* daysSupply = 30 'd' "days"
* whenHandedOver = "2024-03-10T09:15:00+00:00"
* dosageInstruction[0].text = "Take one 500mg tablet twice daily with meals"
* substitution.wasSubstituted = false
