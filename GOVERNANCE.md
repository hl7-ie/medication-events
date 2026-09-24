# HL7 Ireland Governance Model for medication-events

## Overview

The medication-events implementation guide operates within a **federated HL7 Europe governance model** that balances national sovereignty with European harmonization. HL7 Ireland maintains independent stewardship of this guide while coordinating with the broader European HL7 ecosystem.

## HL7 Ireland Organizational Structure

- **HL7 Ireland Affiliate:** Sovereign national HL7 affiliate chapter
- **GitHub Home:** [hl7-ie](https://github.com/hl7-ie)
- **Primary Contact:** HL7 Ireland leadership team
- **Scope:** National medication event standards, ePrescription workflows, and NePS (New ePrescription Service) alignment

## Relationship to HL7 Europe (Federated Governance)

The medication-events guide participates in the HL7 Europe federated model:

### Federated Structure

```
HL7 International FHIR Standard
└── HL7 Europe (Coalesced Federation)
    ├── FHIR Base (common European profiles)
    ├── National Chapters (sovereign guidance)
    │   ├── Ireland (HL7 Ireland)
    │   ├── Belgium (Belgian medication IG)
    │   ├── Denmark (MedCom)
    │   ├── Sweden (basprofiler)
    │   ├── Netherlands
    │   └── ...other affiliates
    └── Specialized Domains (cross-national)
```

### Governance Principles

1. **National Sovereignty:** HL7 Ireland controls medication-events independently; no external approval required for Irish-specific content
2. **European Coordination:** Changes affecting cross-national interoperability are discussed with [hl7-eu/coalesced](https://github.com/hl7-eu/coalesced)
3. **Transparent Alignment:** Dependencies on HL7 Europe FHIR Base are explicitly declared in `sushi-config.yaml`
4. **Contribution Openness:** Contributions from European affiliates are welcomed; liaison discussions occur for significant changes

## Decision-Making Process

### National Decisions (HL7 Ireland Autonomy)

The following decisions require only HL7 Ireland approval:

- Irish-specific medication terminology (SNOMED CT, HIC medication codes)
- National regulatory requirements (NePS alignment, GDPR implications)
- Irish workflow extensions or constraints
- Domestic publication schedule and versioning

**Process:**
1. HL7 Ireland issues/PRs are reviewed and approved by Irish working groups
2. Decision documented in commit message and PR description
3. Publication follows standard IG versioning (draft → trial use → normative)

### Cross-National Decisions (European Liaison)

The following decisions involve consultation with HL7 Europe:

- Changes to common medication profiles (e.g., if medication-events profiles are adopted by other countries)
- Terminology harmonization with Belgium, Denmark, Sweden medication IGs
- Migration of canonical URL when hl7.eu domain infrastructure becomes available
- Alignment of versioning cadence with European releases

**Process:**
1. Issue filed on medication-events repository with label `coordination:europe`
2. Liaison discussion with [hl7-eu/coalesced](https://github.com/hl7-eu/coalesced) maintainers
3. Decision documented with rationale for European context
4. Implementation follows coordinated timeline if cross-national impact exists

## Related European Medication Implementation Guides

HL7 Ireland coordinates with sibling medication IGs across Europe:

| Country | IG Repository | Scope | Canonical URL |
|---------|---------------|-------|---------------|
| Belgium | [be-fhir-medication](https://github.com/hl7-be/be-fhir-medication) | Belgian medication models | `http://hl7.be/fhir/medication/` |
| Denmark | [MedCom](https://github.com/medcomdk/MedCom-FHIR-Communication) | Danish e-health workflows | `http://medcomfhir.dk/` |
| Sweden | [basprofiler](https://github.com/HL7Sweden/basprofiler) | Swedish national base profiles | `http://hl7.se/fhir/` |
| Netherlands | [nl-core-inuse](https://github.com/hl7nl/Nictiz-STU3-eHealthTechnologies) | Dutch medication models | `http://nictiz.nl/fhir/` |

**Coordination Strategy:**
- Cross-reference medication domain expertise via issue tracking
- Participate in HL7 Europe pharmaceutical/medication working groups
- Share learnings on ePrescription workflows and medication management
- Align on common terminology binding decisions (SNOMED CT, DM+D analogues)

## Canonical URL and Migration

### Current Interim Canonical

```
https://hl7.eu/fhir/ie/medication-events/fhir
```

- Used under the European federation interim arrangement
- Publicly resolvable via GitHub Pages (fallback)
- Will migrate when `hl7.ie` domain becomes available

### Migration Plan

1. **Phase 1 (Current):** Interim European federation canonical `https://hl7.eu/fhir/ie/medication-events/fhir`
2. **Phase 2 (Future):** Migrate to permanent Irish national canonical `http://hl7.ie/fhir/ig/medication-events/current/` (when domain available)
3. **Phase 3 (Future):** Official HL7 EU FHIR registry integration if centralized infrastructure launches

Migration will be announced with appropriate version bump and changelog entry.

## Contributing and Liaison Workflows

### For HL7 Ireland Contributors

- Fork/branch medication-events repository
- Make changes aligned with Irish requirements
- Reference relevant issues (NePS requirements, regulatory drivers)
- See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines

### For European Affiliate Contributors

- Contributions are welcome, particularly:
  - Medication pattern recommendations (lessons from BE, DK, SE)
  - Terminology alignment suggestions
  - Interoperability improvements
- Label PRs with `coordination:europe` if broader European impact exists
- HL7 Ireland maintainers will engage with affiliated experts for review

### For HL7 Europe Coordination

- Critical changes or policy questions → liaison with hl7-eu/coalesced
- Cross-national medication pattern discussions → coordinate via GitHub discussions
- Versioning and publication alignment → coordinate release timing

## Questions or Clarifications

For governance questions or liaison requests:

1. **HL7 Ireland:** File an issue on [hl7-ie/medication-events](https://github.com/hl7-ie/medication-events)
2. **European Coordination:** Contact [hl7-eu/coalesced](https://github.com/hl7-eu/coalesced) maintainers
3. **General HL7 Europe Questions:** Visit [HL7 Europe](https://hl7.eu/)
