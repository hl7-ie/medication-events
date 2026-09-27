// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECoreVitalSigns.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdVitalSigns
Parent: http://hl7.org/fhir/StructureDefinition/vitalsigns
Id: ie-mpd-vital-signs
Title: "IE MPD Vital Signs"
Description: "Base vital signs profile for the Irish healthcare context. Inherits from the FHIR Vital Signs base profile."
* ^status = #draft
* status MS
* category MS
* code MS
* subject MS
* subject only Reference(Patient)
* effective[x] MS
* value[x] MS
* dataAbsentReason MS
* component MS


// ----------------------------------------------------------------
// 4. IE Medication Events Body Height
// ----------------------------------------------------------------
Profile: IEMpdBodyHeight
Parent: IEMpdVitalSigns
Id: ie-mpd-body-height
Title: "IE MPD Body Height"
Description: "Records body height/length observations in the Irish healthcare context. Accepted UCUM units: [in_i] (inches) or cm (centimetres)."
* ^status = #draft
* code = $LOINC#8302-2 "Body height"
* value[x] only Quantity
* valueQuantity MS
* valueQuantity.value 1..1 MS
* valueQuantity.unit 1..1 MS
* valueQuantity.system 1..1
* valueQuantity.system = $UCUM
* valueQuantity.code 1..1


// ----------------------------------------------------------------
// 5. IE Medication Events Body Weight
// ----------------------------------------------------------------
Profile: IEMpdBodyWeight
Parent: IEMpdVitalSigns
Id: ie-mpd-body-weight
Title: "IE MPD Body Weight"
Description: "Records body weight observations in the Irish healthcare context. Accepted UCUM units: [lb_av] (pounds) or kg (kilograms)."
* ^status = #draft
* code = $LOINC#29463-7 "Body weight"
* value[x] only Quantity
* valueQuantity MS
* valueQuantity.value 1..1 MS
* valueQuantity.unit 1..1 MS
* valueQuantity.system 1..1
* valueQuantity.system = $UCUM
* valueQuantity.code 1..1
