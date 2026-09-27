// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/terminology/CodeSystems.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.


// ----------------------------------------------------------------------------
// 3. IE Medication Events Provenance Participant Type
// ----------------------------------------------------------------------------
CodeSystem: IEMpdProvenanceParticipantTypeCodes
Id: ie-mpd-provenance-participant-type-codes
Title: "IE MPD Provenance Participant Type"
Description: "Codes for provenance participant types specific to the IE Medication Events Implementation Guide."
* ^status = #draft
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #transmitter "Transmitter" "The entity that provided the copy to your system."


// ----------------------------------------------------------------------------
// 7. IE Medication Events County Codes
// ----------------------------------------------------------------------------
CodeSystem: IEMpdCountyCodes
Id: ie-mpd-county-codes
Title: "IE MPD County Codes"
Description: "Codes representing the 26 counties of the Republic of Ireland."
* ^status = #draft
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #CW "Carlow" "County Carlow"
* #CN "Cavan" "County Cavan"
* #CE "Clare" "County Clare"
* #CO "Cork" "County Cork"
* #DL "Donegal" "County Donegal"
* #D  "Dublin" "County Dublin"
* #G  "Galway" "County Galway"
* #KY "Kerry" "County Kerry"
* #KE "Kildare" "County Kildare"
* #KK "Kilkenny" "County Kilkenny"
* #LS "Laois" "County Laois"
* #LM "Leitrim" "County Leitrim"
* #LK "Limerick" "County Limerick"
* #LD "Longford" "County Longford"
* #LH "Louth" "County Louth"
* #MO "Mayo" "County Mayo"
* #MH "Meath" "County Meath"
* #MN "Monaghan" "County Monaghan"
* #OY "Offaly" "County Offaly"
* #RN "Roscommon" "County Roscommon"
* #SO "Sligo" "County Sligo"
* #TA "Tipperary" "County Tipperary"
* #WD "Waterford" "County Waterford"
* #WH "Westmeath" "County Westmeath"
* #WX "Wexford" "County Wexford"
* #WW "Wicklow" "County Wicklow"


// ----------------------------------------------------------------------------
// 8. IE Medication Events Ethnicity Codes
// ----------------------------------------------------------------------------
CodeSystem: IEMpdEthnicityCodes
Id: ie-mpd-ethnicity-codes
Title: "IE MPD Ethnicity Codes (CSO Data Standard for Ethnicity v1.0)"
Description: "Ethnic group/background categories and codes of the Central Statistics Office (CSO) Data Standard for Ethnicity, version 1.0 (released 7 February 2025): https://www.cso.ie/en/methods/classifications/csodatastandardsandclassifications/csodatastandards/csodatastandardforethnicity/ . Codes and category names are the CSO's; groupings (White, Black, Asian, Arab, Mixed, Other) are expressed as a hierarchy. Open categories ('please specify') carry the patient's own description in CodeableConcept.text. GDPR Art. 9 special-category data: used only in the Patient Summary (HIQA PS 1.4.10), never in ePrescription/eDispensation (IE Core ADR-002). This IE Medication Events representation will be replaced if the CSO publishes a FHIR CodeSystem."
* ^status = #draft
* ^experimental = false
* ^version = "CSO-1.0-2025-02-07"
* ^caseSensitive = true
* ^content = #complete
* ^hierarchyMeaning = #grouped-by
* #white "White" "Grouping: White (CSO)."
  * #10 "White Irish" "CSO code 10."
  * #12 "Irish Traveller" "CSO code 12."
  * #14 "Roma" "CSO code 14."
  * #16 "Any other White background" "CSO code 16 (please specify)."
* #black "Black" "Grouping: Black (CSO)."
  * #18 "Black Irish" "CSO code 18."
  * #20 "Black African" "CSO code 20."
  * #22 "Any other Black background" "CSO code 22 (please specify)."
* #asian "Asian" "Grouping: Asian (CSO)."
  * #24 "Asian Irish" "CSO code 24."
  * #26 "Asian Indian" "CSO code 26."
  * #28 "Chinese" "CSO code 28."
  * #30 "Any other Asian background" "CSO code 30 (please specify)."
* #arab "Arab" "Grouping: Arab (CSO)."
  * #32 "Arab" "CSO code 32."
* #mixed "Mixed" "Grouping: Mixed (CSO)."
  * #34 "Mixed group/background" "CSO code 34 (please specify)."
* #other "Other" "Grouping: Other (CSO)."
  * #36 "Other group/background" "CSO code 36 (please specify)."
* #99 "Not applicable" "CSO reference classification code 99."
