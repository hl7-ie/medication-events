// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/terminology/HIQAPlaceholders.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

CodeSystem: IEMpdPCRSSchemeType
Id: ie-mpd-pcrs-scheme-type
Title: "IE MPD PCRS Scheme Type (placeholder)"
Description: "PLACEHOLDER. Types of Primary Care Reimbursement Service (PCRS) scheme number, taken from the examples in HIQA EP/PS 1.3.3.1: medical card scheme, GP visit card, Drugs Payment Scheme (DPS), Long-Term Illness scheme and Health Amendment Act card scheme (HAA). Used as Identifier.type for HIQA 'other identifiers used in health and social care'. Requires Clarification (IE Core OI-007): to be replaced by an HSE/PCRS code system."
* ^status = #draft
* ^experimental = true
* ^caseSensitive = true
* ^content = #complete
* #medical-card "Medical card scheme number" "PCRS medical card (General Medical Services) number."
* #gp-visit-card "GP visit card number" "PCRS GP visit card number."
* #dps "Drugs Payment Scheme number" "PCRS Drugs Payment Scheme (DPS) number."
* #lti "Long-Term Illness scheme number" "PCRS Long-Term Illness (LTI) scheme number."
* #haa "Health Amendment Act card number" "PCRS Health (Amendment) Act card scheme (HAA) number."


ValueSet: IEMpdPCRSSchemeTypeVS
Id: ie-mpd-pcrs-scheme-type
Title: "IE MPD PCRS Scheme Type (placeholder)"
Description: "PLACEHOLDER. PCRS scheme number types (HIQA EP/PS 1.3.3.1 examples). Requires Clarification (IE Core OI-007)."
* ^status = #draft
* ^experimental = true
* include codes from system IEMpdPCRSSchemeType


CodeSystem: IEMpdMDASchedule
Id: ie-mpd-mda-schedule
Title: "IE MPD Misuse of Drugs Schedule (placeholder)"
Description: "PLACEHOLDER. Controlled drug schedules of the Misuse of Drugs Regulations 2017 (S.I. No. 173/2017), cited by HIQA EP 4.2.3 (MDA Schedule, Required, expected auto-populated from the NMPC). The schedule names come from the regulations; the codes are IE Medication Events placeholders. Requires Clarification (IE Core OI-007): to be replaced by the NMPC/HPRA representation."
* ^status = #draft
* ^experimental = true
* ^caseSensitive = true
* ^content = #complete
* #schedule-1 "Schedule 1" "Misuse of Drugs Regulations 2017, Schedule 1."
* #schedule-2 "Schedule 2" "Misuse of Drugs Regulations 2017, Schedule 2."
* #schedule-3 "Schedule 3" "Misuse of Drugs Regulations 2017, Schedule 3."
* #schedule-4-part-1 "Schedule 4 Part 1" "Misuse of Drugs Regulations 2017, Schedule 4 Part 1."
* #schedule-4-part-2 "Schedule 4 Part 2" "Misuse of Drugs Regulations 2017, Schedule 4 Part 2."
* #schedule-5 "Schedule 5" "Misuse of Drugs Regulations 2017, Schedule 5."


ValueSet: IEMpdMDAScheduleVS
Id: ie-mpd-mda-schedule
Title: "IE MPD Misuse of Drugs Schedule (placeholder)"
Description: "PLACEHOLDER. Controlled drug schedules (S.I. No. 173/2017). HIQA EP 4.2.3. Requires Clarification (IE Core OI-007)."
* ^status = #draft
* ^experimental = true
* include codes from system IEMpdMDASchedule


CodeSystem: IEMpdSupplyLegalStatus
Id: ie-mpd-supply-legal-status
Title: "IE MPD Supply Legal Status (placeholder)"
Description: "PLACEHOLDER. Legal supply status of a medicinal product, HIQA EP 4.2.2 (Required, auto-populated). Only the two statuses given as examples in the HIQA text are included. Requires Clarification (IE Core OI-007): to be replaced by the NMPC/HPRA representation."
* ^status = #draft
* ^experimental = true
* ^caseSensitive = true
* ^content = #fragment
* #prescription-only "Prescription only medicine" "Prescription only medicine (HIQA EP 4.2.2 example)."
* #general-sale "General sales list" "General sales list (HIQA EP 4.2.2 example)."
