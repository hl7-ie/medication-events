# Clinical safety log

Hazards that the IE MPD rules mitigate. Hazards inherited from IE Core keep IE Core's number (see
`docs/hiqa-2026/clinical-safety-log.md` in `hl7-ie/ie-core`); new hazards are numbered MPD-HZ-xx.

This is a proof of concept. It is not a clinical safety case, and the IG is not for clinical use.

| ID | Hazard | Cause | Mitigation in this IG | Residual risk |
|---|---|---|---|---|
| IE Core HZ-06 | Wrong-patient match at the pharmacy | The mother's maiden name is no longer sent on an ePrescription | IHI (Required) plus name, date of birth and address (Mandatory); IHI format check `ie-pat-1` | Patients without an IHI rely on demographics only |
| MPD-HZ-01 | A missed dose is not noticed or not explained | An administration recorded as `not-done` with no reason | `ie-mad-status-1` requires `statusReason` for `not-done` | Free-text reasons are not machine-comparable (OI-103) |
| MPD-HZ-02 | A dose is recorded as given but what was given is unknown | An administration recorded as `completed` with no dose | `ie-mad-dose-1` requires a dose or dosage text for `completed` | Dosage text is not machine-checkable |
| MPD-HZ-03 | A medication statement misstates the dose | "As directed" statements have no structured dose | `dosage.text` 1..1; `dose[x]` MustSupport | Consumers must read the text when no dose is given (OI-017) |
