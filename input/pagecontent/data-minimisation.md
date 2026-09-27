<div class="note-to-balloters" markdown="1">

**Based on a consultation draft.** The dataset below follows the HIQA draft ePrescription and eDispensation standard
(September 2026). This page explains how the IG applies it. It is not legal advice.

</div>

### Principle

Under GDPR Article 5(1)(c), personal data must be *adequate, relevant and limited to what is necessary*. Ethnicity is
also special-category data (Article 9). HIQA defines the patient dataset for an ePrescription in EP Section 1, so the
ePrescription and eDispensation profiles accept only a patient that carries that dataset:

| Profile | Used by | What it carries |
|---|---|---|
| [Patient (ePrescription)](StructureDefinition-ie-mpd-patient-eprescription.html) | ePrescription and eDispensation | **Only** the HIQA EP Section 1 dataset. Everything else is prohibited (`0..0`) |
| [Patient](StructureDefinition-ie-mpd-patient.html) | administration and medication statements | A permissive base. Sensitive elements are allowed but carry no MustSupport, so no system is obliged to send or process them |
{:.grid}

### What an ePrescription may not carry

| Data | ePrescription / eDispensation | Why |
|---|---|---|
| Ethnicity | **prohibited** | Special-category data; not needed to dispense |
| Mother's maiden or former surnames | **prohibited** | Identity matching uses the IHI, name, date of birth and address |
| Nationality, citizenship | **prohibited** | Not needed to dispense |
| Place of birth, country of affiliation | **prohibited** | Not needed to dispense |
| Religion, marital status, pronouns | **prohibited** | Not in the HIQA EP dataset |
| Photo, contacts, multiple-birth indicator | **prohibited** | Not in the HIQA EP dataset |
| Sex assigned at birth | **required** (EP 1.4.3, Mandatory) | Clinically relevant to dosing and contraindications |
| PPSN | allowed, no MustSupport | The legal basis for health use needs clarification (OI-008) |
{:.grid}

The [traceability matrix](hiqa-traceability.html) lists each prohibited element as *Prohibited (enforced)*.

### How it is checked

- **Profiles.** `IEMpdPatientEPrescription` sets each prohibited extension slice and element to `0..0`. The
  prescription and dispense profiles only accept that patient profile as their subject.
- **Tests.** `tests/features/data-minimisation.feature` checks the profile constraints and every ePrescription patient
  in the examples, including patients inside ePrescription Bundles.
- **Guard script.** `scripts/qa/check_ep_data_minimisation.py` fails the build if any ePrescription or eDispensation
  example mentions ethnicity, maiden name, nationality, citizenship, religion or marital status.

### Identity matching without the mother's maiden name

The HIQA EP dataset carries the IHI (Required), forename and surname, date of birth and address (all Mandatory), so
matching relies on the IHI plus these demographics. The IG accepts the IHI in its 18-digit and 10-digit forms
(EP 1.3.1; OI-002).
