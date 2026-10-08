// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECoreEPrescription.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdMedicationRequestEPrescription
Parent: $EUMPDMedicationRequest
Id: ie-mpd-medicationrequest-eprescription
Title: "IE MPD MedicationRequest (ePrescription)"
Description: "An Irish electronic prescription (eP): one prescribed medication (HIQA EP 3.5 prescription item), derived from the HL7 Europe MPD MedicationRequest. One or more eP issued together as part of the same request form an Electronic Prescription Group (IEMpdElectronicPrescriptionGroup): they share the prescription group identifier in groupIdentifier and are exchanged with the patient, prescriber, facility, allergy statement, eDispensations and provenance."
* ^status = #draft

// ── 3.1 / 3.5.1 Identifiers ────────────────────────────────────────────
* identifier 1..* MS
* identifier ^comment = "HIQA EP 3.5.1 Prescription item identifier (Mandatory 1..*). For a single-item prescription this is typically the same as the electronic prescription identifier (EP 3.1)."
* groupIdentifier MS
* groupIdentifier ^comment = "HIQA EP 3.1 Electronic prescription (group) identifier (Mandatory 1..*): the NePS identifier used throughout the prescription and dispensation life cycle. Required when the prescription has more than one item (Bundle invariant ie-bnd-rx-1)."

// ── 3.3 / 3.5.2 Status ─────────────────────────────────────────────────
* status 1..1 MS
* status ^comment = "HIQA EP 3.5.2.1 Prescription item status (Mandatory 1..1): e.g. active, on-hold (inactive) or completed (dispensed). The status of the whole prescription (EP 3.3) is derived from its items: all completed = complete; any active = active; otherwise inactive."
* statusReason MS
* statusReason ^comment = "HIQA EP 3.5.2.2 (Required) and 3.5.2.3 (free text, in statusReason.text). Must be given unless the status is active or completed (invariant ie-rx-status-1)."
* obeys ie-rx-status-1
* intent = #order
* category MS
* category ^comment = "HIQA EP 3.5.5 Intended use of prescription item (Optional), e.g. prophylaxis, therapeutic or diagnostic."
* courseOfTherapyType MS
* courseOfTherapyType ^comment = "Acute or continuous (repeat) prescribing. Not a HIQA element; supports EP 3.5.11."

// ── 3.5.3 Medication ───────────────────────────────────────────────────
* medication[x] 1..1 MS
* medication[x] only Reference(IEMpdMedicationEPrescription)
* medication[x] ^comment = "HIQA EP 3.5.3 Prescribed medication item (Mandatory 1..1); see Section 4 (IEMpdMedicationEPrescription). A reference is required (not an inline CodeableConcept): HIQA EP 4.7.2 makes the ingredient Mandatory, and the controlled-drug rules (ie-rx-cd-1/2/3) read the MDA schedule from the Medication (independent review R-01). SNOMED CT Irish Edition / NMPC coding in Medication.code."

// ── Section 1 Patient ──────────────────────────────────────────────────
* subject 1..1 MS
* subject only Reference(IEMpdPatientEPrescription)
* subject ^comment = "HIQA EP Section 1 Patient Details. The patient profile carries only the HIQA EP dataset (IE Core ADR-002)."
* extension contains IEMpdPatientAgeAtPrescribing named ageAtPrescribing 0..1 MS
* extension[ageAtPrescribing] ^short = "Patient age at prescribing (a legal requirement if under 12)"
* extension[ageAtPrescribing] ^comment = "HIQA EP 1.4.2 Age (Required 0..1; 1.4.2.1 value and 1.4.2.2 type Mandatory within the cluster). Required when the patient is under 12 at authoredOn (invariants ie-rx-age-1, ie-bnd-rx-3)."
* obeys ie-rx-age-1
* supportingInformation MS
* supportingInformation ^comment = "HIQA EP 1.6 Clinical information: SHALL reference the allergy statement (IEMpdListAllergiesAtPrescribing; EP 1.6.1/1.6.2, invariant ie-bnd-rx-2) and MAY reference weight (IEMpdBodyWeight, EP 1.6.3) and height (IEMpdBodyHeight, EP 1.6.4)."

// ── Section 2 Prescriber ───────────────────────────────────────────────
* requester 1..1 MS
* requester only Reference(IEMpdPractitionerRole or IEMpdPractitioner)
* requester ^comment = "HIQA EP Section 2 Health Practitioner Details. The prescriber must be a registered health practitioner (EP 2.6, Mandatory), so an Organization is not allowed. Prefer PractitionerRole, which carries the role (2.5), facility (2.7–2.12) and contact details (2.10)."

// ── 3.2 Date and time of issuing ───────────────────────────────────────
* authoredOn 1..1 MS
* authoredOn ^comment = "HIQA EP 3.2 Date and time of issuing the prescription (Mandatory 1..1)."

// ── 3.5.4 Indication ───────────────────────────────────────────────────
* reasonCode MS
* reasonCode ^comment = "HIQA EP 3.5.4.1 Indication (coded, Optional) and 3.5.4.2 (free text, in reasonCode.text)."

// ── 3.5.6 Period of use (MPD extension) ────────────────────────────────
* extension[effectiveDosePeriod] MS
* extension[effectiveDosePeriod] ^comment = "HIQA EP 3.5.6 Period of use (Required 0..1): overall period of all dosage schemes."

// ── 3.5.14 Off label (MPD / IHE extension) ─────────────────────────────
* extension[offLabelUse] MS
* extension[offLabelUse] ^comment = "HIQA EP 3.5.14 Off label (Required): 3.5.14.1 off-label use (Mandatory within the cluster) and 3.5.14.2 reason (coded or free text). IHE ihe-ext-offLabel, inherited from HL7 Europe MPD; replaces the retired IEMpdOffLabelUse."

// ── 3.5.8 / Section 5 Dosage ───────────────────────────────────────────
* dosageInstruction 1..* MS
* dosageInstruction only IEMpdDosage
* dosageInstruction ^comment = "HIQA EP 3.5.8 Dosage instructions (Mandatory 1..1) and Section 5 Dosaging; see IEMpdDosage and the Dosage page (ADR-004)."
* dosageInstruction obeys ie-rx-dosage-1
* dosageInstruction.text 1..1 MS
* dosageInstruction.text ^comment = "HIQA EP 5.1 Rendered dosage instruction (Optional). IE Medication Events requires it (stricter than HIQA, IE Core OI-012) as a human-readable safety fallback for the structured dosage."
* dosageInstruction.sequence ^comment = "HIQA EP 5.2.1 Sequence (Optional)."
* dosageInstruction.patientInstruction MS
* dosageInstruction.patientInstruction ^comment = "HIQA EP 5.2.2 Note for patient (Required)."
* dosageInstruction.timing MS
* dosageInstruction.timing ^comment = "HIQA EP 5.2.4 Repeat administration (Required): bounds (5.2.4.1), duration (5.2.4.2), frequency and period (5.2.4.3), day of week (5.2.4.4), time of day (5.2.4.5), event (5.2.4.6)."
* dosageInstruction.timing.repeat.frequency MS
* dosageInstruction.timing.repeat.frequency ^comment = "HIQA EP 5.2.4.3.1 Frequency of administration (Mandatory within the frequency cluster)."
* dosageInstruction.timing.repeat.period MS
* dosageInstruction.timing.repeat.period ^comment = "HIQA EP 5.2.4.3.2 Period (Mandatory within the frequency cluster), with periodUnit."
* dosageInstruction.timing.repeat.periodUnit MS
* dosageInstruction.asNeeded[x] ^comment = "HIQA EP 5.2.5 Administer as needed (Optional)."
* dosageInstruction.site ^comment = "HIQA EP 5.2.6 Body site (Optional): morphology, location, qualifier and laterality post-coordinated in SNOMED CT, or described in site.text (5.2.6.5)."
* dosageInstruction.route MS
* dosageInstruction.route ^comment = "HIQA EP 5.2.7 Route of administration (Required); EDQM Standard Terms preferred."
* dosageInstruction.doseAndRate MS
* dosageInstruction.doseAndRate ^comment = "HIQA EP 5.2.3 Dose and rate (Required): dose quantity or range (5.2.3.1), rate (5.2.3.2)."
* dosageInstruction.doseAndRate.dose[x] MS
* dosageInstruction.maxDosePerPeriod MS
* dosageInstruction.maxDosePerPeriod ^comment = "Maximum dose per period (not a distinct HIQA element; supports safe 'as needed' dosing)."
* dosageInstruction.additionalInstruction MS
* dosageInstruction.additionalInstruction ^comment = "Additional instructions (e.g. 'with food'); complements HIQA EP 5.2.2."

// ── 3.5.7 / 3.5.9–3.5.13 Dispense request ──────────────────────────────
* dispenseRequest 1..1 MS
* dispenseRequest.extension[prescribedQuantity] MS
* dispenseRequest.extension[prescribedQuantity] ^comment = "HIQA EP 3.5.7.1 Quantity prescribed (Required): overall quantity, independent of repeats (IHE extension via HL7 Europe MPD)."
* dispenseRequest.extension contains
    IEMpdNumberOfInstalments named numberOfInstalments 0..1 MS and
    IEMpdDoNotExtend named doNotExtend 0..1
* dispenseRequest.extension[numberOfInstalments] ^comment = "HIQA EP 3.5.12 Number of instalments (Required): a legal requirement for Schedule 2, 3 and 4 Part 1 controlled drugs (invariant ie-rx-cd-3)."
* dispenseRequest.extension[doNotExtend] ^comment = "HIQA EP 3.5.9.2 'Do Not Extend' (Optional)."
* dispenseRequest.quantity 1..1 MS
* dispenseRequest.quantity ^comment = "Quantity to supply per dispense. IE Medication Events requires it (1..1, stricter than HIQA EP 3.5.7 Required 0..1; IE Core OI-012)."
* dispenseRequest.validityPeriod MS
* dispenseRequest.validityPeriod ^comment = "HIQA EP 3.5.9.1 Validity period (Required). If no start is given, it is the date of issue. Up to 12 months for non-controlled drugs. Schedule 2 and 3 controlled drugs: 14 days, or for instalment prescriptions the final instalment within two months (the first instalment within 14 days is checked at dispensing, IE Core OI-027) (invariant ie-rx-cd-2)."
* dispenseRequest.numberOfRepeatsAllowed MS
* dispenseRequest.numberOfRepeatsAllowed ^comment = "HIQA EP 3.5.11 Repeats of prescription item allowed (Optional); default 0. Repeats already dispensed are DERIVED from the completed MedicationDispense records that reference this request, not stored (IE Core ADR-003)."
* dispenseRequest.dispenseInterval MS
* dispenseRequest.dispenseInterval ^comment = "HIQA EP 3.5.13 Minimum dispense interval (Required); also the instalment interval, which must be specified for Schedule 2, 3 and 4 Part 1 instalment prescriptions (invariant ie-rx-cd-3)."
* extension contains IEMpdQuantityInWordsAndFigures named quantityInWordsAndFigures 0..1 MS
* extension[quantityInWordsAndFigures] ^comment = "HIQA EP 3.5.7.2 Quantity prescribed (free text, words and figures): must be recorded for any medication listed as a controlled drug under the Misuse of Drugs Regulations 2017 (invariant ie-rx-cd-1)."
* obeys ie-rx-cd-1 and ie-rx-cd-2 and ie-rx-cd-3

// ── 3.5.10 Substitution ────────────────────────────────────────────────
* substitution MS
* substitution.allowed[x] MS
* substitution.allowed[x] ^comment = "HIQA EP 3.5.10.2 'Do Not Substitute' (Optional): allowedBoolean = false means 'Do Not Substitute'. A legal requirement to endorse the item if the prescriber invokes it."
* substitution.reason MS
* substitution.reason ^comment = "HIQA EP 3.5.10.3 Reason for not allowing substitution (Required when 'Do Not Substitute'; free text in reason.text; invariant ie-rx-subst-1)."
* obeys ie-rx-subst-1

// ── 3.6.1 Note ─────────────────────────────────────────────────────────
* note MS
* note ^comment = "HIQA EP 3.6.1 Note (Optional) and 1.6.5 Additional clinical notes (Optional): for the patient or the pharmacist."



Profile: IEMpdMedicationDispenseEDispensation
Parent: $EUMPDMedicationDispense
Id: ie-mpd-medicationdispense-edispensation
Title: "IE MPD MedicationDispense (eDispensation)"
Description: "An Irish electronic dispensation record (HIQA EP Section 6), derived from the HL7 Europe MPD MedicationDispense. Covers a completed dispense, a partial or instalment dispense, and a non-dispensation (declined or stopped, with a reason)."
* ^status = #draft

* identifier 1..* MS
* identifier ^comment = "HIQA EP 6.1 Dispensation identifier (Required 0..*). IE Medication Events requires at least one."
* extension[recorded] MS
* extension[recorded] ^comment = "HIQA EP 6.2 Date and time of issuing the dispense record (Mandatory 1..1); 1..1 inherited from HL7 Europe MPD."
* status 1..1 MS
* status ^comment = "HIQA EP 6.3.1 Dispensation status (Mandatory). A non-dispensation uses declined or stopped with a reason (invariant ie-md-status-1)."
* statusReason[x] MS
* statusReason[x] ^comment = "HIQA EP 6.3.2 Dispensation status reason (Optional): coded (6.3.2.1) or free text (6.3.2.2, in statusReasonCodeableConcept.text). IE Medication Events requires a reason for a non-dispensation (safety: the prescriber needs to know why)."
* obeys ie-md-status-1
* medication[x] 1..1 MS
* medication[x] ^comment = "HIQA EP 6.6 Dispensed medication (Mandatory 1..1); see Section 4."
* medication[x] from IEMpdMedicationCodes (extensible)
* subject 1..1 MS
* subject only Reference(IEMpdPatientEPrescription)
* performer 1..* MS
* performer.actor MS
* performer.actor only Reference(IEMpdPractitioner or IEMpdPractitionerRole or IEMpdOrganization)
* performer ^comment = "HIQA EP Section 2 (dispenser and pharmacy). Dispensers are registered pharmacists or registered pharmaceutical assistants."
* receiver ^comment = "HIQA EP 6.4 Receiver (Optional): the patient (6.4.1) or a health practitioner (6.4.2). A related person (6.4.3) goes in extension[receiverRelatedPerson]."
* extension contains IEMpdDispenseReceiverRelatedPerson named receiverRelatedPerson 0..1
* authorizingPrescription 1..1 MS
* authorizingPrescription only Reference(IEMpdMedicationRequestEPrescription)
* authorizingPrescription ^comment = "HIQA EP 6.5 Prescription item identifier with related request (Required 0..1). IE Medication Events requires exactly one (stricter than HIQA, IE Core OI-012): this profile covers dispensing against an electronic prescription; emergency supply uses the base IEMpdMedicationDispense."
* quantity 1..1 MS
* quantity ^comment = "HIQA EP 6.7 Dispensed quantity (Mandatory 1..1)."
* whenHandedOver MS
* whenHandedOver ^comment = "HIQA EP 6.8 Date of dispensation (Mandatory) and 6.9 Time of dispensation (Required). Required when the status is completed (invariant ie-md-handover-1)."
* obeys ie-md-handover-1
* substitution MS
* substitution.wasSubstituted MS
* substitution.wasSubstituted ^comment = "HIQA EP 6.10 Substitution occurred (Optional)."
* substitution.type MS
* substitution.reason MS
* dosageInstruction MS
* dosageInstruction only IEMpdDosage
* dosageInstruction ^comment = "HIQA EP 6.11 Dosage instructions (Required); see Section 5 and IEMpdDosage."
* dosageInstruction.text MS
* note ^comment = "HIQA EP 6.12 Additional information (Optional)."



Profile: IEMpdMedicationEPrescription
Parent: $EUMPDMedication
Id: ie-mpd-medication-eprescription
Title: "IE MPD Medication (ePrescription/eDispensation)"
Description: "The medicinal product in an Irish ePrescription or eDispensation (HIQA EP Section 4), derived from the HL7 Europe MPD Medication. Many elements are expected to be auto-populated from the National Medicinal Product Catalogue (NMPC)."
* ^status = #draft

* code 1..1 MS
* code ^comment = "HIQA EP 4.1 Medication item identifier (Required 0..*) and 4.3 Medication product name (4.3.1 coded, 4.3.2 free text in code.text). NMPC (SNOMED CT Irish Extension) where available; see Terminology Services."
* code from IEMpdMedicationCodes (extensible)
// EU Base medication-eu-core already slices (IHE / EU extensions): productName, classification,
// sizeOfItem, characteristic, unitOfPresentation, packageType, device. They are reused, not re-declared.
* extension[classification] MS
* extension contains
    IEMpdMedicationInterchangeable named interchangeable 0..1 MS and
    IEMpdExemptMedicationItem named exemptMedicationItem 0..1 MS
* extension[classification] ^comment = "HIQA EP 4.2 Classification (Required 0..*): ATC (4.2.1), supply legal status (4.2.2, IEMpdSupplyLegalStatus placeholder), MDA schedule (4.2.3, IEMpdMDASchedule placeholder), other classification group (4.2.4)."
* extension[productName] ^comment = "HIQA EP 4.3 Medication product name (brand or trade name), when it differs from code.text."
* extension[unitOfPresentation] ^comment = "HIQA EP 4.7.3 Unit of presentation (Optional, dispensation)."
* extension[device] ^comment = "HIQA EP 4.8 Device (Optional, dispensation): 4.8.1 device type and 4.8.2 quantity."
* extension[characteristic] ^comment = "HIQA EP 4.9 Characteristics (Optional, dispensation), with the IHE MPD characteristic extension inherited from HL7 Europe Base: 4.9.1 type (extension type, Mandatory in the cluster) and 4.9.2 value (extension value: coded, Quantity, dateTime, integer, decimal, Ratio or string for 4.9.2.1 to 4.9.2.7)."
* extension[packageType] ^comment = "HIQA EP 4.7.6 Package type (Optional, dispensation); EDQM package terms."
* extension[interchangeable] ^comment = "HIQA EP 3.5.10.1 Medicinal product is interchangeable (Required; HPRA List of Interchangeable Medicines)."
* extension[exemptMedicationItem] ^comment = "HIQA EP 4.11 Exempt medication item (Required). Meaning Requires Clarification."
* form MS
* form ^comment = "HIQA EP 4.5 Dose form (Required, dispensation) and 4.7.1 Medication item dose form (Required). EDQM Standard Terms. For a controlled-drug preparation, the dose form is a legal requirement."
* manufacturer ^comment = "HIQA EP 4.4 Manufacturer / marketing authorisation holder (Optional, dispensation)."
* amount MS
* amount ^comment = "HIQA EP 4.7.5 Pack size or amount (Optional)."
* ingredient 1..* MS
* ingredient ^comment = "HIQA EP 4.7.2 Ingredient in medication item (Mandatory 1..*)."
* ingredient.item[x] MS
* ingredient.item[x] ^comment = "HIQA EP 4.7.2.2 Active ingredient/substance (Mandatory 1..1); SNOMED CT substance."
* ingredient.isActive MS
* ingredient.isActive ^comment = "HIQA EP 4.7.2.1 Ingredient is active (Required)."
* ingredient.strength MS
* ingredient.strength ^comment = "HIQA EP 4.7.2.3 Strength (Required; 4.7.2.3.1 Ratio Mandatory within the cluster), UCUM units. A legal requirement on a dispensation record, and on a controlled-drug prescription for a preparation. Basis of strength substance (4.7.2.3.2) via the IHE strengthsubstance extension."
* batch MS
* batch ^comment = "HIQA EP 4.10 Batch (Required, dispensation)."
* batch.lotNumber MS
* batch.lotNumber ^comment = "HIQA EP 4.10.1 Batch lot number (Required)."
* batch.expirationDate MS
* batch.expirationDate ^comment = "HIQA EP 4.10.2 Batch expiration date (Required)."



// ╭──────────────────────────────────────────────────────────────────────╮
// │  Invariants                                                          │
// ╰──────────────────────────────────────────────────────────────────────╯

Invariant: ie-rx-age-1
Description: "If the patient is under 12 years old at the date of prescribing, or the date of birth is not a full date, the patient's age SHALL be recorded on the prescription (HIQA EP 1.4.2; a legal requirement in Ireland)"
Expression: "subject.resolve().ofType(Patient).birthDate.empty() or authoredOn.empty() or ((subject.resolve().ofType(Patient).birthDate.toString().length() = 10) and ((subject.resolve().ofType(Patient).birthDate + 12 years).toString() <= authoredOn.toString().substring(0,10))) or extension('https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-patient-age-at-prescribing').exists()"
Severity: #error


Invariant: ie-rx-status-1
Description: "A status reason SHALL be given unless the prescription item is active, completed or draft (HIQA EP 3.5.2.2 / 3.5.2.3)"
Expression: "(status = 'active' or status = 'completed' or status = 'draft') or statusReason.exists()"
Severity: #error


Invariant: ie-rx-dosage-1
Description: "A structured dosage SHALL be accompanied by a human-readable dosage text (safety fallback; HIQA EP 5.1 / 5.2)"
Expression: "(timing.exists() or doseAndRate.exists()) implies text.exists()"
Severity: #error


Invariant: ie-rx-subst-1
Description: "When substitution is not allowed ('Do Not Substitute'), a reason SHALL be given (HIQA EP 3.5.10.3)"
Expression: "substitution.allowed.ofType(boolean).where($this = false).exists() implies substitution.reason.exists()"
Severity: #error


Invariant: ie-rx-cd-1
Description: "A prescription for a controlled drug (any schedule of the Misuse of Drugs Regulations 2017) SHALL state the quantity in words and figures (HIQA EP 3.5.7.2)"
Expression: "(medication.ofType(Reference).resolve().extension('https://profiles.ihe.net/PHARM/MPD/StructureDefinition/ihe-ext-medication-classification').value.ofType(CodeableConcept).coding.where(system = 'https://hl7-ie.github.io/medication-events/fhir/CodeSystem/ie-mpd-mda-schedule').exists()) implies extension('https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-quantity-in-words-and-figures').exists()"
Severity: #error


Invariant: ie-rx-cd-2
Description: "A prescription for a Schedule 2 or 3 controlled drug SHALL have a validity period ending no later than 14 days after the date of issue, or, for an instalment prescription, no later than two months after (the final instalment) (HIQA EP 3.5.9.1; Misuse of Drugs Regulations 2017)"
Expression: "(medication.ofType(Reference).resolve().extension('https://profiles.ihe.net/PHARM/MPD/StructureDefinition/ihe-ext-medication-classification').value.ofType(CodeableConcept).coding.where(system = 'https://hl7-ie.github.io/medication-events/fhir/CodeSystem/ie-mpd-mda-schedule' and (code = 'schedule-2' or code = 'schedule-3')).exists()) implies (dispenseRequest.validityPeriod.end.exists() and ((dispenseRequest.extension('https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-number-of-instalments').exists() and dispenseRequest.validityPeriod.end.toString().substring(0,10) <= (authoredOn + 2 months).toString().substring(0,10)) or (dispenseRequest.validityPeriod.end.toString().substring(0,10) <= (authoredOn + 14 days).toString().substring(0,10))))"
Severity: #error


Invariant: ie-rx-cd-3
Description: "A prescription for a Schedule 2, 3 or 4 Part 1 controlled drug SHALL state the number of instalments and, when there is more than one, the interval between them (HIQA EP 3.5.12, 3.5.13; Misuse of Drugs Regulations 2017)"
Expression: "(medication.ofType(Reference).resolve().extension('https://profiles.ihe.net/PHARM/MPD/StructureDefinition/ihe-ext-medication-classification').value.ofType(CodeableConcept).coding.where(system = 'https://hl7-ie.github.io/medication-events/fhir/CodeSystem/ie-mpd-mda-schedule' and (code = 'schedule-2' or code = 'schedule-3' or code = 'schedule-4-part-1')).exists()) implies (dispenseRequest.extension('https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-number-of-instalments').exists() and ((dispenseRequest.extension('https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-number-of-instalments').value.ofType(positiveInt) > 1) implies dispenseRequest.dispenseInterval.exists()))"
Severity: #error


Invariant: ie-md-status-1
Description: "A non-dispensation (declined, stopped, cancelled or on-hold) SHALL state the reason (HIQA EP 6.3.2)"
Expression: "(status = 'declined' or status = 'stopped' or status = 'cancelled' or status = 'on-hold') implies statusReason.exists()"
Severity: #error


Invariant: ie-md-handover-1
Description: "A completed dispense SHALL record when the medication was handed over (HIQA EP 6.8 Date of dispensation, Mandatory)"
Expression: "status = 'completed' implies whenHandedOver.exists()"
Severity: #error
