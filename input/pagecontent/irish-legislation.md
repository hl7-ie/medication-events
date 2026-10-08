<div class="note-to-balloters" markdown="1">

**Reference examples, for illustration only.** This material was first published in IE Core 0.2.0 and moved here
with the ePrescription and eDispensation profiles (IE Core ADR-009). The scenarios, payloads and foreign product
codes are illustrative: all people, organisations and identifiers are fictional, and the cross-border flows are not
specified by HIQA. They show how the IE MPD profiles can be used; they are not normative.

</div>

### Irish ePrescription and eDispensation — Legislative and Regulatory Framework

This page documents the primary Irish and EU legislative instruments and HIQA standards that underpin electronic prescribing and dispensing in Ireland, and their relevance to IE MPD FHIR profiles.

---

### Primary Irish Legislation

#### Medicinal Products (Prescription and Control of Supply) Regulations 2003

**Citation**: S.I. No. 540 of 2003 — Medicinal Products (Prescription and Control of Supply) Regulations 2003, as amended by S.I. No. 512 of 2019 (European Union (Falsified Medicines) (Amendment) Regulations 2019).

This is the **primary legal basis for electronic prescribing in Ireland**. Key provisions relevant to IE MPD:

| Provision | Relevance to IE MPD |
|-----------|---------------------|
| Schedule 1 — Prescription requirements | Defines the mandatory elements of a valid prescription; maps to required fields in `IEMpdMedicationRequestEPrescription` |
| Regulation 5 — Electronic prescriptions | Permits electronic prescriptions where certain conditions are met; basis for the National ePrescription Service (NePS) |
| Regulation 7 — Prescription validity | Defines prescription validity periods (generally 6 months for non-controlled, shorter for Schedule 2/3 controlled drugs); maps to `MedicationRequest.dispenseRequest.validityPeriod` |
| Schedule 2/3/4/5 controlled drugs | Impose additional constraints on prescribing authority, format, and dispensing; implementers must apply appropriate constraints to `IEMpdMedicationRequestEPrescription.category` |
| Cross-border prescriptions | S.I. 512/2019 implements EU Directive 2011/24/EU on patients' rights in cross-border healthcare; prescriptions issued in other EU Member States must be honoured in Ireland |

**FHIR Mapping Notes:**

- `MedicationRequest.requester` must reference a practitioner with a valid IMC (Irish Medical Council) registration or equivalent EU prescribing authority
- `MedicationRequest.dispenseRequest.validityPeriod.end` must not exceed the legally mandated validity period for the drug category
- Controlled drug prescriptions (Schedule 2–5) must include additional prescriber information; implementers should consult the HPRA for specific requirements

#### Health (Pricing and Supply of Medical Goods) Act 2013

**Citation**: Health (Pricing and Supply of Medical Goods) Act 2013, No. 14/2013.

Governs **generic substitution** and **reference pricing** for medicines dispensed in Ireland:

| Provision | Relevance to IE MPD |
|-----------|---------------------|
| Section 10 — Generic substitution | Pharmacists are required to offer the lowest-cost interchangeable medicine unless the prescriber has indicated no substitution; maps to `MedicationRequest.substitution.allowed[x]` |
| Section 11 — Substitution prohibition | Prescribers may prohibit substitution for clinical or patient-safety reasons; maps to `MedicationRequest.substitution.allowed[x] = false` and `substitution.reason` |
| Section 24 — Reference pricing | Sets reimbursement reference prices for interchangeable medicines; relevant to PCRS claim processing in `MedicationRequest.identifier` |

**FHIR Mapping Notes:**

- `IEMpdMedicationRequestEPrescription.substitution.allowed[x]`: `true` = generic substitution permitted; `false` = prescriber-mandated no substitution
- `IEMpdMedicationRequestEPrescription.substitution.reason`: **SHOULD** be populated when `allowed[x] = false`, citing the clinical reason (e.g. narrow therapeutic index, patient tolerance, biological product)
- `IEMpdMedicationDispenseEDispensation.substitution.wasSubstituted`: **SHALL** be populated by the dispensing pharmacist to indicate whether a substitution was made

#### Pharmacy Act 2007

**Citation**: Pharmacy Act 2007, No. 20/2007, as amended.

Governs the registration and practice of pharmacists and pharmacy businesses in Ireland:

| Provision | Relevance to IE MPD |
|-----------|---------------------|
| Part 3 — Registration of pharmacists | Only registered pharmacists may dispense; maps to `MedicationDispense.performer.actor` requiring a PSI registration number (HIQA EP 2.6.2; `Practitioner.identifier:PSI`) |
| Section 18 — Pharmacy premises | Only registered pharmacy premises may dispense; maps to `MedicationDispense.location` and `Organization` profiles |
| Code of Conduct (PSI) | Professional obligations of pharmacists when dispensing, including verification of prescriptions and allergy checking |

**FHIR Mapping Notes:**

- `IEMpdMedicationDispenseEDispensation.performer.actor` **SHALL** reference a practitioner with a valid **PSI (Pharmaceutical Society of Ireland)** registration, represented via the practitioner's `identifier` with the PSI system URI

#### Health Act 1970

**Citation**: Health Act 1970, No. 1/1970, as amended.

Establishes the **General Medical Services (GMS)** scheme, which underpins the Medical Card programme and free prescription entitlements:

| Provision | Relevance to IE MPD |
|-----------|---------------------|
| Section 58 — GMS entitlement | Defines eligibility for the GMS scheme; maps to `Patient.identifier` with PCRS scheme type `medical-card` (HIQA EP/PS 1.3.3) and `MedicationRequest.insurance` (Coverage) |
| GMS Panel ID | The prescriber's GMS Panel ID (HIQA EP/PS 2.12) maps to `Organization.identifier:GMSPanel` |

See: [IE MPD Organization](StructureDefinition-ie-mpd-organization.html) and [General Requirements: Irish identifiers](https://hl7-ie.github.io/ie-core/general-requirements.html#irish-healthcare-identifiers)

#### Health Act 2007

**Citation**: Health Act 2007, No. 23/2007.

Establishes the **Health Information and Quality Authority (HIQA)** and provides the statutory basis for national health information governance:

| Provision | Relevance to IE MPD |
|-----------|---------------------|
| Part 7 — Health information | Empowers HIQA to develop national standards for health information, including terminology and data quality standards |
| HIQA as standards body | HIQA's standards on terminology (SNOMED CT, LOINC, NMPC) are mandated; see [General Guidance](https://hl7-ie.github.io/ie-core/general-guidance.html) for details |

#### Health Information and Patient Safety (HIPS) Bill

**Status**: Pre-legislative scrutiny completed; Bill is anticipated to be enacted in 2025–2026, subject to the Oireachtas legislative process.

The HIPS Bill will be Ireland's primary legislation for health information governance and data sharing. Key anticipated provisions:

| Provision (Anticipated) | Relevance to IE MPD |
|------------------------|---------------------|
| National Health Information Framework | Mandates interoperability standards for health information systems; expected to formally adopt FHIR-based exchange standards |
| Individual Health Identifier (IHI) mandate | Codifies the IHI as the national patient identifier for all health information systems |
| Secondary use of health data | Governs research, public health, and planning use of health data; aligned with EHDS Regulation 2025/327 |
| Patient rights (access, correction, restriction) | Maps to FHIR `Patient` rights and consent patterns |

Implementers should monitor the HIPS Bill's progress at [oireachtas.ie](https://www.oireachtas.ie).

---

### HIQA Standards for ePrescription and eHealth

#### HIQA Guidance on Terminology Standards for Ireland (2017)

**Citation**: [HIQA — Guidance on Terminology Standards for Ireland (July 2017)](https://www.hiqa.ie/sites/default/files/2017-07/Guidance-on-terminology-standards-for-Ireland.pdf)

This HIQA guidance establishes Ireland's national terminology framework, which IE MPD fully implements:

| Terminology | Purpose | IE MPD Usage |
|------------|---------|---------------|
| **SNOMED CT (with Irish Extension)** | Reference terminology for clinical concepts | Primary clinical coding in all IE MPD profiles |
| **LOINC** | Laboratory observation codes | Required for all laboratory result observations |
| **ICD-10-AM** | Diagnosis coding (aggregation) | Secondary coding in condition profiles |
| **NMPC** | National Medicinal Product Catalogue — medication codes | Primary medication coding in all IE MPD medication profiles |
| **ATC (WHO)** | Anatomical Therapeutic Chemical classification | Cross-border medication classification |

#### HIQA National Standards for Safer Better Healthcare (2012, updated)

**Citation**: [HIQA — National Standards for Safer Better Healthcare (2012)](https://www.hiqa.ie/sites/default/files/2017-01/National-Standards-SBH.pdf)

These standards apply to health and social care services provided by or on behalf of the HSE, including ePrescribing systems:

| Standard | Relevance to IE MPD |
|----------|---------------------|
| Theme 4 — Health and Social Care Needs | Patient-centred care; IE MPD profiles support person-centred data models |
| Theme 6 — Workforce | Practitioner registration and competency; maps to Practitioner and PractitionerRole profiles |
| Standard 6.3 — Information management | Safe, accurate, and timely health information; relevant to all IE MPD profiles |

#### HIQA Standards for Conducting Reviews of Patient Safety Incidents (2018)

**Citation**: [HIQA — National Standards for Conducting Reviews of Patient Safety Incidents (2018)](https://www.hiqa.ie/sites/default/files/2019-01/National-Standards-Conducting-Reviews-Patient-Safety-Incidents.pdf)

Relevant to error handling and adverse event reporting in ePrescription/eDispensation:

- Prescribing or dispensing errors identified through NePS or cross-border exchange **SHALL** be reportable under the HSE incident management framework
- FHIR `AdverseEvent` and `DetectedIssue` resources may be used to document medication errors and near-misses within IE MPD systems

#### HIQA eHealth Ireland Strategy Standards

HIQA supports the implementation of eHealth Ireland's national strategy. Key standards with IE MPD relevance:

| Standard / Guidance | URL | Relevance |
|--------------------|-----|-----------|
| HIQA Terminology Standards | <https://www.hiqa.ie/reports-and-publications/health-technology-assessments/guidance-use-standards-health-and-social> | SNOMED CT, LOINC, NMPC adoption |
| HIQA EHR Standards | <https://www.hiqa.ie/reports-and-publications/health-information> | EHR interoperability requirements |
| National Catalogue of Standards | <https://www.hiqa.ie/standards> | Full list of applicable HIQA standards |

---

### EU Legislation — Direct Effect in Ireland

The following EU instruments have direct effect in Ireland without requiring transposition:

| EU Instrument | Citation | Relevance |
|--------------|---------|-----------|
| **GDPR** | Regulation 2016/679/EU | Data protection for all health information; implemented by Data Protection Act 2018 |
| **EHDS Regulation** | Regulation 2025/327/EU | European Health Data Space; governs cross-border ePrescription and secondary use |
| **eIDAS 2.0** | Regulation 2024/1183/EU | EUDI Wallet and electronic identification for cross-border healthcare |
| **Falsified Medicines Directive (FMD)** | Directive 2011/62/EU (transposed by S.I. 512/2019) | Unique identifiers and safety features for medicinal products; maps to `Medication.identifier` and serialization data |
| **Cross-Border Patient Rights Directive** | Directive 2011/24/EU (transposed by S.I. 203/2014) | Legal basis for cross-border prescription recognition; basis for MyHealth@EU ePrescription service |

---

### PCRS (Primary Care Reimbursement Service)

The **Primary Care Reimbursement Service (PCRS)** is operated by the HSE and processes reimbursement claims for community drug schemes including GMS, DPS, LTI and the Health (Amendment) Act card scheme. How PCRS claims link to an ePrescription is not defined by the HIQA drafts; the mapping below is IE MPD's:

| PCRS Element | FHIR Element | Profile |
|-------------|-------------|---------|
| Electronic prescription identifier (NePS) | `MedicationRequest.groupIdentifier` / `identifier` (HIQA EP 3.1) | [IE MPD MedicationRequest (ePrescription)](StructureDefinition-ie-mpd-medicationrequest-eprescription.html) |
| Scheme category (GMS, DPS, LTI, HAA) | `MedicationRequest.insurance` → `Coverage.type` | [IE MPD Coverage](https://hl7-ie.github.io/ie-core/StructureDefinition-ie-core-coverage.html) |
| Patient scheme number (HIQA EP/PS 1.3.3) | `Patient.identifier`, typed by `IEMpdPCRSSchemeType` | [IE MPD Patient](StructureDefinition-ie-mpd-patient.html) |

PCRS reimbursement categories are exposed as properties on the NMPC supplement CodeSystem at:
`https://nmpc.hse.ie/PCRS/Category`

For NMPC/CTS API guidance including PCRS filtering, see [Terminology Services](terminology.html).

---

### References

| Legislation / Standard | Reference |
|-----------------------|-----------|
| S.I. 540/2003 — Medicinal Products (Prescription and Control of Supply) Regulations 2003 | <https://www.irishstatutebook.ie/eli/2003/si/540/made/en/print> |
| S.I. 512/2019 — European Union (Falsified Medicines) Amendment | <https://www.irishstatutebook.ie/eli/2019/si/512/made/en/print> |
| Health (Pricing and Supply of Medical Goods) Act 2013 | <https://www.irishstatutebook.ie/eli/2013/act/14/enacted/en/html> |
| Pharmacy Act 2007 | <https://www.irishstatutebook.ie/eli/2007/act/20/enacted/en/html> |
| Health Act 1970 | <https://www.irishstatutebook.ie/eli/1970/act/1/enacted/en/html> |
| Health Act 2007 | <https://www.irishstatutebook.ie/eli/2007/act/23/enacted/en/html> |
| HIPS Bill (Oireachtas) | <https://www.oireachtas.ie> |
| HIQA Terminology Guidance 2017 | <https://www.hiqa.ie/sites/default/files/2017-07/Guidance-on-terminology-standards-for-Ireland.pdf> |
| HIQA National Standards for Safer Better Healthcare | <https://www.hiqa.ie/sites/default/files/2017-01/National-Standards-SBH.pdf> |
| EHDS Regulation 2025/327 | <https://health.ec.europa.eu/ehds> |
| GDPR 2016/679 | <https://gdpr-info.eu> |
| eIDAS 2.0 Regulation 2024/1183 | <https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32024R1183> |
| Cross-Border Patient Rights Directive 2011/24/EU | <https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32011L0024> |
| HPRA Medicines Information | <https://www.hpra.ie> |
| PSI (Pharmaceutical Society of Ireland) | <https://www.thepsi.ie> |
| PCRS | <https://www.hse.ie/eng/staff/pcrs/> |
