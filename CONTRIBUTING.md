# Contributing

Thank you for helping. This is a proof of concept (see [GOVERNANCE.md](GOVERNANCE.md)); contributions are reviewed
by the maintainer.

## Ground rules

- **Invent nothing.** Every HIQA requirement, code, OID and URI must come from an authoritative source. Cite the HIQA
  element ID (for example `HIQA EP 3.5.7.2`) in the element's `^comment` or the invariant description.
- **Check codes.** Run `python scripts/terminology/verify_codes.py`. NMPC codes (SNOMED CT Irish Extension, namespace
  1000220) must be checked in the [NMPC Meds Catalogue](https://nmpc.hse.ie/browser) and added to
  `docs/hiqa-2026/nmpc-verification.csv`. Use the SNOMED CT Irish Edition (`http://snomed.info/sct` with version
  `http://snomed.info/sct/1601000220105`).
- **Unsettled questions** go in `docs/hiqa-2026/open-issues.md` (then run `python scripts/hiqa/sync_open_issues.py`),
  with a clearly named placeholder in the IG where one is needed.
- **Breaking changes** need an ADR in `docs/adr/` and an entry in `input/pagecontent/changes.md`.
- **Safety.** Log a new clinical-safety hazard and its mitigation in `docs/hiqa-2026/clinical-safety-log.md`.
- **Data minimisation.** An ePrescription or eDispensation carries only the HIQA EP patient dataset.
- **Fictional data only** in examples.

## Workflow

1. Branch from `main`: `feat/...`, `fix/...` or `docs/...`.
2. Change the FSH, or the mapping CSV for HIQA traceability, then regenerate:
   `python scripts/hiqa/generate_traceability.py`.
3. Run the checks listed in the [README](README.md#build-and-test). CI runs the same gates.
4. Use [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`; `!` for breaking).
5. Open a pull request describing what changed, why, and the HIQA IDs affected.

## Naming

| Artefact | Convention | Example |
|---|---|---|
| Profile | `IEMpd<Resource>[<UseCase>]`, id `ie-mpd-<resource>[-<use-case>]` | `IEMpdMedicationRequestEPrescription` |
| Invariant | `ie-<area>-<n>` | `ie-mad-status-1` |
| HIQA scenario example | `hiqa-<type>-s<n>-<name>` | `hiqa-mad-s7-salbutamol-given` |
