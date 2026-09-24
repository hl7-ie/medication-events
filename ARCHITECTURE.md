# Architecture: medication-events within European HL7 FHIR Ecosystem

## Layered Governance Model

The medication-events implementation guide is positioned within a **three-tier dependency and governance model** aligned with the European HL7 federated approach:

```
┌─────────────────────────────────────────────┐
│   LAYER 3: Specialized Domains              │
│   (National + Specialized)                  │
│                                             │
│   ├─ medication-events (HL7 Ireland)        │ ← THIS IG
│   ├─ medication-admin (HL7 Ireland future)  │
│   └─ Other specialized domains              │
└─────────────────────────────────────────────┘
              ↓ (depends on)
┌─────────────────────────────────────────────┐
│   LAYER 2: National Guidance                │
│   (National profile sets)                   │
│                                             │
│   ├─ Ireland Core (future)                  │
│   ├─ Belgium Core (be-core)                 │
│   ├─ Swedish Base (basprofiler)             │
│   └─ Other national implementations         │
└─────────────────────────────────────────────┘
              ↓ (depends on)
┌─────────────────────────────────────────────┐
│   LAYER 1: European Foundation              │
│   (Common European Base)                    │
│                                             │
│   ├─ HL7 FHIR Europe Base (hl7.fhir.eu.base)
│   └─ Common European FHIR patterns          │
└─────────────────────────────────────────────┘
              ↓ (depends on)
┌─────────────────────────────────────────────┐
│   FHIR International Standard               │
│   (hl7.fhir.r4.core)                        │
└─────────────────────────────────────────────┘
```

## Dependency Declaration

### Explicit Dependencies in sushi-config.yaml

The medication-events guide declares explicit dependencies on:

```yaml
dependencies:
  hl7.fhir.eu.base: 1.0.0
```

### Dependency Chain

```
medication-events (hl7.fhir.ie.medication-events)
  └─ HL7 FHIR Europe Base (hl7.fhir.eu.base)
      └─ HL7 FHIR R4 Core (hl7.fhir.r4.core)
```

### Rationale for European Base Dependency

1. **Common Medication Concepts:** Medication-events leverages European definitions of Medication, MedicationRequest, Dosage
2. **Interoperability:** Ensures compatibility with other European affiliate medication IGs
3. **Terminology Alignment:** Access to common European SNOMED CT concepts and bindings
4. **Standards Evolution:** Benefit from European working group coordination and versioning cadence

## Layer 1: European FHIR Foundation

**Package:** `hl7.fhir.eu.base`

**Purpose:** Defines foundational FHIR profiles and extensions for use across all European affiliates.

**Key Components:**
- Common European Patient profile
- Common European Practitioner profile
- Common European Organization profile
- European terminology bindings (SNOMED CT)
- Common extensions (e.g., address formatting, identifier types)

**Version Management:** Managed by [hl7-eu/coalesced](https://github.com/hl7-eu/coalesced) with coordinated release cycles.

## Layer 2: National Implementation Profiles

**Package (current placeholder):** Ireland national profiles (future: `hl7.fhir.ie.core` or similar)

**Purpose:** Establishes national context without adding specialized domains.

**Current Status:** Not yet created; medication-events currently extends HL7 FHIR R4 directly while establishing the pattern.

**Future Expansion:** When Irish national profiles are established (patient identifiers, practitioner licensing, organization hierarchies), medication-events will depend on those.

### Comparable National Implementations

| Country | Package | Purpose | Status |
|---------|---------|---------|--------|
| Belgium | `hl7.fhir.be.core` | Belgian national base | Active |
| Sweden | `se.riv.clinicalprocess.fhir` | Swedish national base | Active |
| Denmark | `dk.fhir.core` | Danish national base | Planning |
| Netherlands | `nl.nictiz.fhir.nl` | Dutch national base | Active |

**Cross-National Coordination:** Each national layer maintains sovereignty while participating in European working groups for terminology and pattern alignment.

## Layer 3: Specialized Domains (medication-events)

**Package:** `hl7.fhir.ie.medication-events`

**Canonical:** `https://hl7.eu/fhir/ie/medication-events/fhir` (interim European federation)

**Purpose:** Defines Irish-specific medication event and ePrescription exchange patterns, including:

- **Medication Event Workflows:** Prescribing, dispensing, administration, medication statements
- **NePS Alignment:** Integration with Irish New ePrescription Service requirements
- **Constraint & Extension:** National-specific constraints on Medication/MedicationRequest, plus Irish extensions
- **Example Resources:** Realistic Irish medication scenarios (patient consent, dispensing rules, etc.)

### Design Principles

1. **Specialization over Generalization:** Layer 3 is narrow and focused; it specializes rather than re-generalizes
2. **Dependency Chain Inheritance:** Profiles inherit constraints from Layer 2 (future) and Layer 1 (current)
3. **Non-Duplication:** Avoids redefining profiles already in parent layers
4. **Clear Separation:** Medication events (this IG) vs. medication administration (separate future IG)

### Profiles Defined in medication-events

- `IEMedicationRequest` — Irish constraints on prescribing workflows
- `IEMedicationObservation` — Irish observations during medication events
- Extensions: `IEEPrescriptionReference`, etc.

### Example Scenario Flow

```
┌─ Patient (from HL7 FHIR EU Base or future IE Core)
│   │
│   └─ MedicationRequest (from Layer 1: FHIR R4)
│       └─ IEMedicationRequest profile (LAYER 3: medication-events)
│           └─ Constrained for Irish ePrescription workflows
│           └─ NePS requirements embedded
│
└─ Practitioner (from HL7 FHIR EU Base)
    └─ Licenses/registrations (future: Irish national layer)
```

## Comparison to Similar European Medication IGs

### Belgium (hl7.fhir.be.medication)

- **Structure:** National core → Specialized medication IG
- **Dependency:** Belgium national base (hl7.fhir.be.core) → HL7 EU Base
- **Scope:** Belgian medication terminology, conformance to Belgian health IT law
- **Coordination:** Participates in hl7-eu/coalesced for European harmonization

**Alignment with Ireland:**
- Similar two-layer pattern (once Irish national core exists)
- Cross-reference medication terminology and workflow patterns
- Coordinate on SNOMED CT medication bindings

### Denmark (MedCom Medication)

- **Structure:** Medical specialization model (MedCom coordinates multiple domains)
- **Scope:** Danish e-health communication standards (FHIR flavoring of MedCom XML)
- **Dependency:** Danish FHIR Base → HL7 EU Base

**Alignment with Ireland:**
- MedCom ePrescription workflows similar to Irish NePS model
- Coordinate on cross-border e-prescription interoperability
- Share testing patterns for medication event messaging

### Sweden (basprofiler - Swedish National Base)

- **Structure:** Single foundational layer (Swedish Base profiles)
- **Scope:** All clinical domains leverage basprofiler (no specialized medication IG currently)
- **Future:** May add specialized domains as medication workflows mature

**Alignment with Ireland:**
- Swedish Base patterns inform Irish national layer design
- basprofiler's modular approach applicable to medication-events specialization

### Belgium Medication Comparison (Detailed)

```
Belgium (hl7.fhir.be.medication)          Ireland (hl7.fhir.ie.medication-events)
────────────────────────────────────────  ──────────────────────────────────────
Package: hl7.fhir.be.medication           Package: hl7.fhir.ie.medication-events
Depends on: hl7.fhir.be.core              Depends on: hl7.fhir.eu.base (interim)
National: Belgium                         National: Ireland
Scope: Medication in Belgium              Scope: Medication events + ePrescription
Canonical: http://hl7.be/fhir/medication  Canonical: https://hl7.eu/fhir/ie/...
```

## Version Alignment Strategy

### Semantic Versioning

medication-events uses **semantic versioning** aligned with:

1. **FHIR Core Version:** `4.0.1` (locked; major changes require new IG)
2. **European Base Alignment:** Tracks HL7 EU Base version compatibility
3. **National Changes:** Minor/patch versions for Irish requirement updates

### Release Cadence

```
HL7 International FHIR (yearly major)
  ↓
HL7 Europe Base (semi-annual releases)
  ↓
HL7 Ireland medication-events (quarterly or as-needed)
```

### Example Version Timeline

```
Jan 2026:  medication-events 0.1.0 (initial scaffold, draft)
Jun 2026:  medication-events 0.2.0 (NePS alignment, trial use)
Jan 2027:  medication-events 1.0.0 (normative, if regulatory approval obtained)
Jul 2027:  HL7 EU Base 2.0.0 released → medication-events 1.1.0 (update dependencies)
```

## Migration Plan: Canonical URL Future State

### Current State (Phase 1)

```
Canonical: https://hl7.eu/fhir/ie/medication-events/fhir
Status: Interim, under European federation arrangement
Resolution: Via hl7-ie.github.io fallback
```

### Planned State (Phase 2)

```
Canonical: http://hl7.ie/fhir/ig/medication-events/current/
Status: Permanent, when hl7.ie domain available
Resolution: Direct domain resolution
```

### Contingency: Official HL7 EU Infrastructure

If HL7 International launches centralized European FHIR registry:

```
Canonical: https://registry.hl7.eu/fhir/ie/medication-events/
Status: Permanent, centrally hosted
Resolution: Central registry
```

## Interoperability Considerations

### Cross-Border Exchange (Ireland ↔ Europe)

medication-events profiles are designed to support:

1. **Denmark ↔ Ireland:** MedCom ePrescription interchange (via transformation layer if needed)
2. **Belgium ↔ Ireland:** Medication request/response harmonization
3. **EU Directive 2011/24/EU:** Patient cross-border medication access

### Profile Reusability

Other European countries may reference or adopt medication-events patterns:
- Import via dependency declaration: `hl7.fhir.ie.medication-events`
- Reference specific profiles in their own IGs
- Coordinate major changes via GOVERNANCE.md liaison process

## Questions and Future Architecture Enhancements

### Open Questions (To Be Addressed)

1. **Irish National Core Layer:** When should Layer 2 (Ireland Core) be established?
2. **Medication Administration IG:** Should medication-events expand or split into separate IGs?
3. **Terminology Governance:** Who maintains Irish medication terminology (SNOMED CT + HIC codes)?

### Backlog for Phase 2+

- [ ] Establish Irish national core profiles layer (hl7.fhir.ie.core)
- [ ] Federate terminology governance with HL7 Europe
- [ ] Create medication administration IG (separate from events)
- [ ] Document URI/URL strategy for Irish national assets
- [ ] Expand example resources to cover NePS workflows comprehensively

---

**See also:**
- [GOVERNANCE.md](./GOVERNANCE.md) — Decision-making and liaison processes
- [CONTRIBUTING.md](./CONTRIBUTING.md) — How to contribute with European context
- [README.md](./README.md) — Quick start and package info
- [hl7-eu/coalesced](https://github.com/hl7-eu/coalesced) — HL7 Europe federation coordination
