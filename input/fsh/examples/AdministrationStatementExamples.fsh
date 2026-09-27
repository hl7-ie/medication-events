// IE MPD examples for medication administration and medication statements (scenarios 7-9). All people and
// identifiers are fictional; they reuse the HIQA scenario actors and medicines copied from IE Core.

Instance: hiqa-mad-s7-salbutamol-given
InstanceOf: IEMpdMedicationAdministration
Usage: #example
Title: "Scenario 7 – Administration: salbutamol inhaler given in the GP practice"
Description: "Dr Nolan supervises two puffs of salbutamol during an asthma review. IE-defined (HIQA's EP draft does not cover administration)."
* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:5b6e3f0e-7a2c-5c0d-9f41-2a7d3c8e1b11"
* status = #completed
* medicationReference = Reference(hiqa-med-salbutamol-inhaler)
* subject = Reference(hiqa-patient-niamh-keane)
* effectiveDateTime = "2026-09-23T11:05:00+01:00"
* performer[0].actor = Reference(hiqa-role-gp-nolan)
* request = Reference(hiqa-rx-s3-salbutamol-repeat)
* reasonCode = $SCT#195967001 "Asthma"
* dosage.text = "Two puffs inhaled via spacer"
* dosage.route = $SCT#447694001 "Respiratory tract route"
* dosage.dose = 2 '{puff}' "puffs"

Instance: hiqa-mad-s8-dose-not-given
InstanceOf: IEMpdMedicationAdministration
Usage: #example
Title: "Scenario 8 – Administration not given: patient declined the dose"
Description: "A scheduled dose recorded as not given, with the reason (invariant ie-mad-status-1)."
* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[=].value = "urn:uuid:0c9d2a47-3e5b-5f6a-8b1c-9d4e2f7a6c22"
* status = #not-done
* statusReason.text = "Patient declined the dose; prescriber informed"
* medicationReference = Reference(hiqa-med-amoxicillin-500-caps)
* subject = Reference(hiqa-patient-tomas-quinn)
* effectiveDateTime = "2026-09-21T14:00:00+01:00"
* performer[0].actor = Reference(hiqa-role-gp-nolan)
* request = Reference(hiqa-rx-s1-amoxicillin)

Instance: hiqa-mst-s9-niamh-salbutamol
InstanceOf: IEMpdMedicationStatement
Usage: #example
Title: "Scenario 9 – Medication statement: salbutamol inhaler when needed"
Description: "What the patient reports taking (HIQA PS 6.3), recorded by her GP."
* status = #active
* medicationReference = Reference(hiqa-med-salbutamol-inhaler)
* subject = Reference(hiqa-patient-niamh-keane)
* effectivePeriod.start = "2012-02-01"
* informationSource = Reference(hiqa-role-gp-nolan)
* reasonCode = $SCT#195967001 "Asthma"
* dosage[0].text = "Two puffs when required for breathlessness. Maximum 8 puffs in 24 hours"
* dosage[=].asNeededBoolean = true
* dosage[=].route = $SCT#447694001 "Respiratory tract route"
