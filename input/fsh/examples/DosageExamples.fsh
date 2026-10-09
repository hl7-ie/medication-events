// Dosage examples (ADR-004): one example per dosage pattern on the Dosage guidance page, modelled on the UK Core
// medicines Dosage guidance. Carried as medication statements so each shows the dosage alone. Medicines are coded with
// NMPC VMPs (SNOMED CT Irish Edition) verified in the NMPC Meds Catalogue (docs/hiqa-2026/nmpc-verification.csv);
// product-based doses use SNOMED CT units of presentation. All people are fictional.

RuleSet: DosageStatement(patient, nmpc, display, start)
* status = #active
* medicationCodeableConcept = $SCTIE#{nmpc} "{display}"
* medicationCodeableConcept.coding[0].version = "http://snomed.info/sct/1601000220105"
* subject = Reference({patient})
* effectivePeriod.start = "{start}"
* informationSource = Reference(hiqa-role-gp-nolan)

Instance: ie-mpd-dosage-ex-sequential-warfarin
InstanceOf: IEMpdMedicationStatement
Usage: #example
Title: "Dosage – sequential schemes (sequence 1 then 2): warfarin loading then maintenance"
Description: "Two consecutive dosaging schemes (HIQA EP 5.2.1 Sequence): 10 mg once a day for 2 days, then 5 mg once a day. Product-based dose in tablets (SNOMED CT 732936001 |Tablet|)."
* insert DosageStatement(hiqa-patient-declan-walsh, 718731000220101, Warfarin sodium 5 mg oral tablet, 2026-09-10)
* dosage[0].sequence = 1
* dosage[=].text = "Take two tablets (10 mg) once a day for 2 days"
* dosage[=].timing.repeat.boundsDuration = 2 'd' "days"
* dosage[=].timing.repeat.frequency = 1
* dosage[=].timing.repeat.period = 1
* dosage[=].timing.repeat.periodUnit = #d
* dosage[=].route = $SCTIE#26643006 "Oral route"
* dosage[=].doseAndRate[0].doseQuantity = 2 $SCT#732936001 "Tablet"
* dosage[+].sequence = 2
* dosage[=].text = "Then take one tablet (5 mg) once a day, or as directed by the anticoagulation clinic"
* dosage[=].timing.repeat.frequency = 1
* dosage[=].timing.repeat.period = 1
* dosage[=].timing.repeat.periodUnit = #d
* dosage[=].route = $SCTIE#26643006 "Oral route"
* dosage[=].doseAndRate[0].doseQuantity = 1 $SCT#732936001 "Tablet"

Instance: ie-mpd-dosage-ex-concurrent-insulin
InstanceOf: IEMpdMedicationStatement
Usage: #example
Title: "Dosage – concurrent schemes (same sequence): insulin aspart with meals"
Description: "Three dosages that apply at the same time share sequence 1: 6 units before breakfast, 4 before lunch, 8 before the evening meal (HIQA EP 5.2.4.6 event: ACM, ACD, ACV). Strength-based dose in UCUM international units."
* insert DosageStatement(hiqa-patient-declan-walsh, 525351000220105, Insulin aspart 100 units/1 mL solution for injection 3 mL cartridge, 2026-08-01)
* dosage[0].sequence = 1
* dosage[=].text = "Inject 6 units before breakfast"
* dosage[=].timing.repeat.frequency = 1
* dosage[=].timing.repeat.period = 1
* dosage[=].timing.repeat.periodUnit = #d
* dosage[=].timing.repeat.when = #ACM
* dosage[=].route = $SCTIE#34206005 "Subcutaneous route"
* dosage[=].doseAndRate[0].doseQuantity = 6 '[iU]' "units"
* dosage[+].sequence = 1
* dosage[=].text = "Inject 4 units before lunch"
* dosage[=].timing.repeat.frequency = 1
* dosage[=].timing.repeat.period = 1
* dosage[=].timing.repeat.periodUnit = #d
* dosage[=].timing.repeat.when = #ACD
* dosage[=].route = $SCTIE#34206005 "Subcutaneous route"
* dosage[=].doseAndRate[0].doseQuantity = 4 '[iU]' "units"
* dosage[+].sequence = 1
* dosage[=].text = "Inject 8 units before the evening meal"
* dosage[=].timing.repeat.frequency = 1
* dosage[=].timing.repeat.period = 1
* dosage[=].timing.repeat.periodUnit = #d
* dosage[=].timing.repeat.when = #ACV
* dosage[=].route = $SCTIE#34206005 "Subcutaneous route"
* dosage[=].doseAndRate[0].doseQuantity = 8 '[iU]' "units"

Instance: ie-mpd-dosage-ex-as-needed-salbutamol
InstanceOf: IEMpdMedicationStatement
Usage: #example
Title: "Dosage – as needed, a dose range and a maximum dose: salbutamol inhaler"
Description: "1 to 2 actuations when needed (HIQA EP 5.2.5 as needed: a boolean, because HL7 Europe MPD allows only asNeededBoolean, so the reason is in the text; 5.2.3.1.2 dose range), at most 8 actuations in 24 hours (ie-dos-3)."
* insert DosageStatement(hiqa-patient-niamh-keane, 363291000220101, Salbutamol 100 microgram/actuation pressurised suspension for inhalation, 2012-02-01)
* dosage[0].text = "Inhale 1 to 2 puffs when required for wheeze. Maximum 8 puffs in 24 hours"
* dosage[=].patientInstruction = "Use 1 or 2 puffs when you are wheezy. Do not use more than 8 puffs in a day; see your GP if you need it more often."
* dosage[=].asNeededBoolean = true
* dosage[=].route = $SCTIE#447694001 "Respiratory tract route"
* dosage[=].doseAndRate[0].doseRange.low = 1 $SCT#732981002 "Actuation"
* dosage[=].doseAndRate[0].doseRange.high = 2 $SCT#732981002 "Actuation"
* dosage[=].maxDosePerPeriod.numerator = 8 $SCT#732981002 "Actuation"
* dosage[=].maxDosePerPeriod.denominator = 24 'h' "hours"

Instance: ie-mpd-dosage-ex-bounded-amoxicillin
InstanceOf: IEMpdMedicationStatement
Usage: #example
Title: "Dosage – frequency with time bounds and an additional instruction: amoxicillin for 5 days"
Description: "One capsule three times a day for 5 days (HIQA EP 5.2.4.1.1 time bounds, 5.2.4.3 frequency and period), with the coded additional instruction 421984009 |Until finished|."
* insert DosageStatement(hiqa-patient-tomas-quinn, 716141000220105, Amoxicillin 500 mg oral capsule, 2026-09-21)
* dosage[0].text = "Take one capsule three times a day for 5 days. Finish the course"
* dosage[=].additionalInstruction = $SCTIE#421984009 "Until finished"
* dosage[=].timing.repeat.boundsDuration = 5 'd' "days"
* dosage[=].timing.repeat.frequency = 3
* dosage[=].timing.repeat.period = 1
* dosage[=].timing.repeat.periodUnit = #d
* dosage[=].route = $SCTIE#26643006 "Oral route"
* dosage[=].doseAndRate[0].doseQuantity = 1 $SCT#732937005 "Capsule"

Instance: ie-mpd-dosage-ex-with-food-metformin
InstanceOf: IEMpdMedicationStatement
Usage: #example
Title: "Dosage – twice a day with food: metformin"
Description: "One tablet twice a day with or after food (coded additional instruction 311504000 |With or after food|)."
* insert DosageStatement(hiqa-patient-declan-walsh, 718271000220105, Metformin hydrochloride 500 mg oral tablet, 2025-03-01)
* dosage[0].text = "Take one tablet twice a day with or after food"
* dosage[=].additionalInstruction = $SCTIE#311504000 "With or after food"
* dosage[=].timing.repeat.frequency = 2
* dosage[=].timing.repeat.period = 1
* dosage[=].timing.repeat.periodUnit = #d
* dosage[=].route = $SCTIE#26643006 "Oral route"
* dosage[=].doseAndRate[0].doseQuantity = 1 $SCT#732936001 "Tablet"

Instance: ie-mpd-dosage-ex-event-omeprazole
InstanceOf: IEMpdMedicationStatement
Usage: #example
Title: "Dosage – linked to an event: omeprazole before breakfast"
Description: "One capsule once a day before breakfast (HIQA EP 5.2.4.6 event: ACM), with 311501008 |Half to one hour before food|."
* insert DosageStatement(hiqa-patient-declan-walsh, 313941000220100, Omeprazole 20 mg gastro-resistant oral capsule, 2026-06-01)
* dosage[0].text = "Take one capsule once a day, half to one hour before breakfast"
* dosage[=].additionalInstruction = $SCTIE#311501008 "Half to one hour before food"
* dosage[=].timing.repeat.frequency = 1
* dosage[=].timing.repeat.period = 1
* dosage[=].timing.repeat.periodUnit = #d
* dosage[=].timing.repeat.when = #ACM
* dosage[=].route = $SCTIE#26643006 "Oral route"
* dosage[=].doseAndRate[0].doseQuantity = 1 $SCT#732937005 "Capsule"

Instance: ie-mpd-dosage-ex-weekly-methotrexate
InstanceOf: IEMpdMedicationStatement
Usage: #example
Title: "Dosage – once a week on a named day: methotrexate"
Description: "Four tablets once a week on Mondays (HIQA EP 5.2.4.4 day of the week; frequency 1 per 1 week). A high-risk weekly medicine: the patient instruction states the day. The medicine is given as text only because its NMPC code has not been verified in the NMPC Meds Catalogue for this IG."
* status = #active
* medicationCodeableConcept.text = "Methotrexate 2.5 mg tablets"
* subject = Reference(hiqa-patient-declan-walsh)
* effectivePeriod.start = "2026-01-12"
* informationSource = Reference(hiqa-role-gp-nolan)
* dosage[0].text = "Take four tablets (10 mg) ONCE A WEEK on Mondays"
* dosage[=].patientInstruction = "Take this medicine once a week only, on Monday. Never take it on any other day."
* dosage[=].timing.repeat.frequency = 1
* dosage[=].timing.repeat.period = 1
* dosage[=].timing.repeat.periodUnit = #wk
* dosage[=].timing.repeat.dayOfWeek = #mon
* dosage[=].route = $SCTIE#26643006 "Oral route"
* dosage[=].doseAndRate[0].doseQuantity = 4 $SCT#732936001 "Tablet"
