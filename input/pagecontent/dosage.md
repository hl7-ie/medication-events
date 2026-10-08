<div class="note-to-balloters" markdown="1">

**Guidance.** How to express a dosage with the [IE MPD Dosage](StructureDefinition-ie-mpd-dosage.html) profile, used
by the ePrescription item, the eDispensation and the medication statement (ADR-004). The structure follows the UK Core
medicines implementation guide's Dosage guidance; the rules map to HIQA EP Section 5 (September 2026 draft).

</div>

### Principles

- **Always give the text.** `text` is the full instruction a person reads (HIQA EP 5.1). Structured elements add to it,
  never replace it (`ie-dos-1`).
- **Code what you can.** Routes, sites, methods and additional instructions use SNOMED CT. Quantities use a SNOMED CT
  *unit of presentation* for product-based doses (`732936001` Tablet, `732937005` Capsule, `732981002` Actuation)
  or UCUM for strength-based doses (`mg`, `mL`, `[iU]`).
- **One `Dosage` per scheme.** Use `sequence` to order schemes; schemes in force at the same time share a number.

### Elements, in order

| # | Element | HIQA EP | How to use it |
|---|---|---|---|
| 1 | `sequence` | 5.2.1 | 1, 2, 3 for consecutive schemes (e.g. a loading dose then maintenance); the same number for schemes that apply together (e.g. insulin at each meal) |
| 2 | `text` | 5.1 | The complete instruction, always present |
| 3 | `additionalInstruction` | — | Coded supplementary instructions: `311504000` With or after food; `311501008` Half to one hour before food; `421984009` Until finished |
| 4 | `patientInstruction` | 5.2.2 | Plain-language instruction for the patient (Required) |
| 5 | `timing.repeat` | 5.2.4 | `frequency` per `period` + `periodUnit` (5.2.4.3; both Mandatory, `ie-dos-2`); `boundsDuration` or `boundsPeriod` for how long (5.2.4.1); `duration` for how long each administration lasts (5.2.4.2); `dayOfWeek` (5.2.4.4); `timeOfDay` (5.2.4.5); `when` + `offset` for an event such as `ACM` before breakfast or `HS` at bedtime (5.2.4.6) |
| 6 | `asNeeded[x]` | 5.2.5 | `asNeededBoolean = true`. HL7 Europe MPD allows only the boolean, so the reason goes in `text` and `patientInstruction`; give `maxDosePerPeriod` (`ie-dos-3`) |
| 7 | `site` | 5.2.6 | SNOMED CT body structure, post-coordinated for laterality and qualifiers, or `site.text` |
| 8 | `route` | 5.2.7 | SNOMED CT route (e.g. `26643006` Oral, `34206005` Subcutaneous, `47625008` Intravenous, `447694001` Respiratory tract). EDQM binding pending |
| 9 | `method` | — | SNOMED CT administration method, when the route alone is not enough |
| 10 | `doseAndRate` | 5.2.3 | `doseQuantity` (5.2.3.1.1) or `doseRange` with both ends (5.2.3.1.2, `ie-dos-4`); `rateQuantity` or `rateRatio` for infusions (5.2.3.2) |
| 11 | `maxDosePerPeriod`, `maxDosePerAdministration` | — | Upper limits, e.g. 8 actuations in 24 hours |
{:.grid}

### Worked examples

Each example is a validated resource; the structured dosage is shown in its JSON view.

| Pattern | Instruction | Key elements | Example |
|---|---|---|---|
| Consecutive schemes | Warfarin: 2 tablets once a day for 2 days, then 1 tablet once a day | `sequence` 1 and 2; `boundsDuration` 2 d; `doseQuantity` 2 then 1 Tablet | [warfarin](MedicationStatement-ie-mpd-dosage-ex-sequential-warfarin.html) |
| Concurrent schemes | Insulin aspart: 6 units before breakfast, 4 before lunch, 8 before the evening meal | three dosages, all `sequence` 1; `when` ACM, ACD, ACV; `[iU]` | [insulin](MedicationStatement-ie-mpd-dosage-ex-concurrent-insulin.html) |
| As needed, dose range, maximum | Salbutamol: 1 to 2 puffs when required for wheeze, max 8 in 24 hours | `asNeededBoolean`; `doseRange` 1–2 Actuation; `maxDosePerPeriod` 8 / 24 h | [salbutamol](MedicationStatement-ie-mpd-dosage-ex-as-needed-salbutamol.html) |
| Time-bounded course | Amoxicillin: 1 capsule three times a day for 5 days, finish the course | `frequency` 3 / 1 d; `boundsDuration` 5 d; `421984009` Until finished | [amoxicillin](MedicationStatement-ie-mpd-dosage-ex-bounded-amoxicillin.html) |
| With food | Metformin: 1 tablet twice a day with or after food | `frequency` 2 / 1 d; `311504000` With or after food | [metformin](MedicationStatement-ie-mpd-dosage-ex-with-food-metformin.html) |
| Linked to an event | Omeprazole: 1 capsule once a day before breakfast | `when` ACM; `311501008` Half to one hour before food | [omeprazole](MedicationStatement-ie-mpd-dosage-ex-event-omeprazole.html) |
| Named weekday | Methotrexate: 4 tablets once a week on Mondays | `frequency` 1 / 1 wk; `dayOfWeek` mon; explicit `patientInstruction` | [methotrexate](MedicationStatement-ie-mpd-dosage-ex-weekly-methotrexate.html) |
{:.grid}

The scenario prescriptions also carry structured dosage, e.g. [scenario 1](MedicationRequest-hiqa-rx-s1-amoxicillin.html).

### Safety notes

- A dosage that cannot be structured safely (e.g. "as directed by the clinic", sliding scales) is given as `text` only.
- High-risk weekly medicines (e.g. methotrexate) name the day in `dayOfWeek` and in `patientInstruction`.
- Do not use UCUM annotations such as `{tablet}` for product-based doses; use the SNOMED CT unit of presentation.
- An infusion gives the rate (`rateQuantity`, e.g. mL/h) and, where relevant, the duration of each administration
  (`timing.repeat.duration`).

### Not covered

Dose calculation (per kg, per m²), titration rules and dose checking are clinical-system functions, not part of the
exchange format.
