// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/terminology/ValueSets.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.



// ============================================================================
// 1. Ireland Counties
// ============================================================================
ValueSet: IEMpdCounties
Id: ie-mpd-county
Title: "Ireland Counties"
Description: "The 26 counties of the Republic of Ireland."
* ^experimental = false
* include codes from system $IE-COUNTY


// ============================================================================
// 2. IE Medication Events Ethnicity
// ============================================================================
ValueSet: IEMpdEthnicityVS
Id: ie-mpd-ethnicity
Title: "IE MPD Ethnicity"
Description: "Ethnic group/background per the CSO Data Standard for Ethnicity v1.0 (7 Feb 2025). HIQA PS 1.4.10 only (GDPR Art. 9); prohibited in ePrescription (IE Core ADR-002). Grouping codes (white, black, asian, arab, mixed, other) SHOULD NOT be used when a specific category is known."
* ^experimental = false
* include codes from system $IE-ETHNICITY


// ============================================================================
// 7. Allergy Intolerance Set
// ============================================================================
ValueSet: IEMpdAllergyIntoleranceSet
Id: ie-mpd-allergy-intolerance-set
Title: "IE MPD Allergy Intolerance Set"
Description: "Codes for substances and clinical findings related to allergies and intolerances."
* ^experimental = false
* include codes from system $SCT where concept is-a #105590001 "Substance"
* include codes from system $SCT where concept is-a #418038007 "Propensity to adverse reactions to substance"
* include codes from system $SCT where concept is-a #373873005 "Pharmaceutical / biologic product"


// ============================================================================
// 12. Medication Codes
// ============================================================================
ValueSet: IEMpdMedicationCodes
Id: ie-mpd-medication-codes
Title: "IE MPD Medication Codes"
Description: "Medication codes for the Irish healthcare system. NMPC (via the SNOMED CT Irish Edition hosted on the HSE Central Terminology Server) is the preferred primary medication code wherever available. SNOMED CT Irish Edition is the preferred secondary clinical terminology wherever available, and ATC (WHO) codes are included for international classification and EU cross-border interoperability (EHDS/MyHealth@EU). Query the HSE CTS with system http://snomed.info/sct and version http://snomed.info/sct/1601000220105 (the SNOMED CT Irish Edition) for real medication codes."
* ^experimental = false
* include codes from system $SCT|http://snomed.info/sct/1601000220105 where concept is-a #373873005 "Pharmaceutical / biologic product (product)"
* include codes from system $ATC


// ============================================================================
// 32. Healthcare Provider Taxonomy
// ============================================================================
ValueSet: IEMpdHealthcareProviderTaxonomy
Id: ie-mpd-healthcare-provider-taxonomy
Title: "IE MPD Healthcare Provider Taxonomy"
Description: "Healthcare provider taxonomy codes for categorising provider specialties and roles."
* ^experimental = false
* include codes from system $SCT where concept is-a #223366009 "Healthcare professional"
* include codes from system $SCT where concept is-a #394658006 "Clinical specialty"


// ============================================================================
// 33. Provenance Participant Type
// ============================================================================
ValueSet: IEMpdProvenanceParticipantType
Id: ie-mpd-provenance-participant-type
Title: "IE MPD Provenance Participant Type"
Description: "Provenance participant type codes including IE Medication Events specific types."
* ^experimental = false
* include codes from system $PROVENANCE-PARTICIPANT-TYPE
* $IE-PROVENANCE#transmitter "Transmitter"
