// ╭──────────────────────────────────────────────────────────────────────╮
// │  IE MPD Dosage (ADR-004)                                             │
// │  One dosage profile for prescription, dispense and statement,        │
// │  on HL7 Europe MPD Dosage-eu-mpd. Maps HIQA EP Section 5; guidance   │
// │  on the Dosage page follows the structure of the UK Core medicines   │
// │  Dosage guidance (sequence, text, instructions, timing, as needed,   │
// │  site, route, method, dose and rate, maximum dose).                  │
// ╰──────────────────────────────────────────────────────────────────────╯

Profile: IEMpdDosage
Parent: $EUMPDDosage
Id: ie-mpd-dosage
Title: "IE MPD Dosage"
Description: "How a medicine is to be taken or given (HIQA EP Section 5 Dosaging). Used by the ePrescription item, the eDispensation and the medication statement. Structured dosage always comes with human-readable text, a frequency always has its period, and doses use SNOMED CT units of presentation or UCUM. See the Dosage guidance page."
* ^status = #draft
* obeys ie-dos-1 and ie-dos-2 and ie-dos-3 and ie-dos-4

* sequence MS
* sequence ^comment = "HIQA EP 5.2.1 Sequence (Optional; when there is more than one dosaging scheme). Consecutive schemes take increasing numbers (1, 2, 3); schemes that apply at the same time share a number."
* text MS
* text ^comment = "HIQA EP 5.1 Rendered dosage instruction. Always the full instruction a person would read, even when the dosage is structured (ie-dos-1)."
* additionalInstruction MS
* additionalInstruction ^comment = "Supplementary instructions or warnings, coded in SNOMED CT where possible (e.g. 311504000 |With or after food|, 421984009 |Until finished|)."
* patientInstruction MS
* patientInstruction ^comment = "HIQA EP 5.2.2 Note for patient (Required): instructions in plain language for the patient."

* timing MS
* timing ^comment = "HIQA EP 5.2.4 Repeat administration of medication item (Required)."
* timing.repeat.bounds[x] MS
* timing.repeat.bounds[x] ^comment = "HIQA EP 5.2.4.1 Time bounds: a duration (5.2.4.1.1, e.g. 5 days) or a period with dates (5.2.4.1.2)."
* timing.repeat.duration ^comment = "HIQA EP 5.2.4.2 Duration of administration (e.g. an infusion over 30 minutes), with durationUnit."
* timing.repeat.frequency MS
* timing.repeat.frequency ^comment = "HIQA EP 5.2.4.3.1 Frequency of administration (Mandatory within the frequency cluster): how many times per period."
* timing.repeat.period MS
* timing.repeat.period ^comment = "HIQA EP 5.2.4.3.2 Period (Mandatory within the frequency cluster), with periodUnit (ie-dos-2)."
* timing.repeat.periodUnit MS
* timing.repeat.dayOfWeek ^comment = "HIQA EP 5.2.4.4 Day of the week (Optional), e.g. a weekly medicine taken on Mondays."
* timing.repeat.timeOfDay ^comment = "HIQA EP 5.2.4.5 Time of the day (Optional)."
* timing.repeat.when ^comment = "HIQA EP 5.2.4.6 Event or time period for administration (Optional), e.g. ACM before breakfast, HS at bedtime; offset in minutes."

* asNeeded[x] ^comment = "HIQA EP 5.2.5 Administer as needed (Optional). HL7 Europe MPD allows only asNeededBoolean, so the reason (e.g. for wheeze) is given in text and patientInstruction; give a maximum dose per period (ie-dos-3)."
* site ^comment = "HIQA EP 5.2.6 Body site or structure (Optional): morphology, location, qualifier and laterality post-coordinated in SNOMED CT, or free text in site.text (5.2.6.5)."
* route MS
* route ^comment = "HIQA EP 5.2.7 Route of administration (Required). SNOMED CT route concepts (e.g. 26643006 |Oral route|); EDQM Standard Terms when bound (Requires Clarification)."
* method ^comment = "The technique of administration (e.g. inhale, apply); SNOMED CT."

* doseAndRate MS
* doseAndRate ^comment = "HIQA EP 5.2.3 Dose and rate (Required)."
* doseAndRate.dose[x] MS
* doseAndRate.dose[x] ^comment = "HIQA EP 5.2.3.1 Dose of medication item: a quantity (5.2.3.1.1) or a range (5.2.3.1.2). Product-based doses use a SNOMED CT unit of presentation (e.g. 732936001 |Tablet|); strength-based doses use UCUM (e.g. mg, [iU]). Both ends of a range are given (ie-dos-4)."
* doseAndRate.rate[x] ^comment = "HIQA EP 5.2.3.2 Rate of administration (Optional): a quantity (5.2.3.2.1, e.g. mL/h) or a ratio (5.2.3.2.2)."
* maxDosePerPeriod MS
* maxDosePerPeriod ^comment = "Maximum dose per period (e.g. 8 actuations in 24 hours). Not a distinct HIQA element; expected with as-needed dosing (ie-dos-3)."
* maxDosePerAdministration ^comment = "Maximum dose per administration."

Invariant: ie-dos-1
Description: "A structured dosage SHALL be accompanied by a human-readable dosage text (HIQA EP 5.1; safety fallback)"
Expression: "(timing.exists() or doseAndRate.exists() or route.exists() or asNeeded.exists()) implies text.exists()"
Severity: #error

Invariant: ie-dos-2
Description: "A frequency SHALL have its period and period unit (HIQA EP 5.2.4.3.1 and 5.2.4.3.2 are both Mandatory in the frequency cluster)"
Expression: "timing.repeat.frequency.exists() implies (timing.repeat.period.exists() and timing.repeat.periodUnit.exists())"
Severity: #error

Invariant: ie-dos-3
Description: "An as-needed dosage SHOULD state a maximum dose per period"
Expression: "asNeeded.ofType(boolean) = true implies maxDosePerPeriod.exists()"
Severity: #warning

Invariant: ie-dos-4
Description: "A dose range SHALL give both a low and a high value (HIQA EP 5.2.3.1.2)"
Expression: "doseAndRate.dose.ofType(Range).all(low.exists() and high.exists())"
Severity: #error
