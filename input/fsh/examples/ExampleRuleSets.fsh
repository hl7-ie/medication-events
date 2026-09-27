// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/examples/ExampleRuleSets.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

RuleSet: SexAssignedAtBirth(code, display)
* extension[sexAssignedAtBirth].extension[value].valueCodeableConcept = http://hl7.org/fhir/administrative-gender#{code} "{display}"
* extension[sexAssignedAtBirth].extension[type].valueCodeableConcept = $LOINC#76689-9 "Sex assigned at birth"


// HIQA EP/PS 1.3.3 "other identifier used in health and social care": a PCRS scheme number.
// No format is enforced (HIQA gives none; IE Core ADR-006).
RuleSet: PCRSIdentifier(system, schemeCode, schemeDisplay, value)
* identifier[+].system = {system}
* identifier[=].type = IEMpdPCRSSchemeType#{schemeCode} "{schemeDisplay}"
* identifier[=].value = "{value}"
* identifier[=].assigner.display = "HSE"
