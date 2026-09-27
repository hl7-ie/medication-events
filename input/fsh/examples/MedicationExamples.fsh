// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/examples/MedicationExamples.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Instance: ie-mpd-medication-metformin-500
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Metformin 500mg Tablets"
Description: "Metformin hydrochloride 500mg film-coated tablets (generic), coded with the NMPC VMP (SNOMED CT Irish Edition) as the primary code and the International SNOMED CT substance as a secondary code."

* code = $SCT#718271000220105 "Metformin hydrochloride 500 mg oral tablet"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.coding[+] = $SCT#372567009 "Metformin"
* code.text = "Metformin 500mg tablets"
* form = $SCT#385055001 "Tablet"
* amount.numerator = 60 '{tablet}' "tablets"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#372567009 "Metformin"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 500 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{tablet}' "tablet"



Instance: ie-mpd-medication-atorvastatin-20
InstanceOf: IEMpdMedicationEPrescription
Usage: #example
Title: "Medication – Atorvastatin 20mg Tablets"
Description: "Atorvastatin 20mg film-coated tablets (generic), coded with the NMPC VMP (SNOMED CT Irish Edition) as the primary code and the International SNOMED CT substance as a secondary code."

* code = $SCT#254311000220102 "Atorvastatin 20 mg oral tablet"
* code.coding[0].version = "http://snomed.info/sct/1601000220105"
* code.coding[+] = $SCT#373444002 "Atorvastatin"
* code.text = "Atorvastatin 20mg tablets"
* form = $SCT#385055001 "Tablet"
* amount.numerator = 30 '{tablet}' "tablets"
* amount.denominator = 1 '{pack}' "pack"
* ingredient[0].itemCodeableConcept = $SCT#373444002 "Atorvastatin"
* ingredient[=].isActive = true
* ingredient[=].strength.numerator = 20 'mg' "mg"
* ingredient[=].strength.denominator = 1 '{tablet}' "tablet"
