# HL7 Ireland Medication Events

Starter implementation guide scaffold for **`hl7.fhir.ie.medication-events`**. This repository provides the initial structure for an Irish medication events implementation guide covering prescribing, dispensing, administration, medication statements, and NePS-aligned ePrescription workflows.

## Canonical and package metadata

- **Repository:** `hl7-ie/medication-events`
- **Canonical (interim):** `https://hl7.eu/fhir/ie/medication-events/fhir` (European federation canonical under HL7 Europe)
- **FHIR package:** `hl7.fhir.ie.medication-events`
- **FHIR version:** `4.0.1`

## Purpose and scope

This scaffold establishes a baseline HL7 Ireland implementation guide that can evolve into national guidance for medication event exchange. The initial content includes:

- a minimal FHIR IG publisher configuration
- placeholder conformance artifacts for profiles, extensions, terminology, and capability statement support
- synthetic sample resources for Patient, Encounter, MedicationRequest, and Observation
- GitHub Actions automation for validating and publishing the guide through GitHub Pages

## European federation context

This implementation guide is part of the **federated HL7 Europe governance model** where:

- **Package naming** follows the standard pattern: `hl7.fhir.{cc}.{module}` (e.g., `hl7.fhir.ie.medication-events`)
- **Canonical URL** uses the interim European federation structure: `https://hl7.eu/fhir/ie/medication-events/fhir`
- **HL7 Ireland** maintains sovereign control over medication-events while coordinating with [hl7-eu/coalesced](https://github.com/hl7-eu/coalesced) for European harmonization
- **Related affiliate medication IGs**: This guide aligns with medication implementation guides from Belgium, Sweden, Denmark, and Norway; see [HL7 Europe affiliates](https://github.com/hl7-eu) for federation structure

**Note:** When the `hl7.ie` domain becomes available or the official HL7 EU infrastructure is launched, the canonical URL will migrate to the permanent location.

## Alignment to HL7 affiliate patterns

The scaffold intentionally follows patterns commonly used across affiliate implementation guides such as **HL7 US Core**, **CA Core+**, **UK Core**, **NI Core**, and **AU Base**:

- GitHub Pages is used as the canonical publication base while the official `hl7.ie` domain is unavailable.
- SUSHI/FSH is used to define starter conformance artifacts in a maintainable form.
- IG Publisher configuration is kept repository-local so that CI and local builds use the same entry points.
- Terminology, profiles, examples, and page content are separated into standard input folders for future growth.

## Repository structure

```text
.
├── .github/
│   └── workflows/
│       └── ig-publisher.yml
├── input/
│   ├── fsh/
│   │   └── medication-events.fsh
│   ├── pagecontent/
│   │   ├── downloads.md
│   │   └── index.md
│   └── resources/
│       └── CapabilityStatement-ie-medication-events-capabilitystatement.json
├── .gitignore
├── ig.ini
├── package-list.json
├── package.json
├── sushi-config.yaml
└── README.md
```

## Included starter artifacts

- **Profiles**
  - `IEMedicationRequest`
  - `IEMedicationObservation`
- **Extension**
  - `IEEPrescriptionReference`
- **Terminology placeholders**
  - `IEMedicationEventTypeCS`
  - `IEMedicationEventTypeVS`
- **Capability statement**
  - `IEMedicationEventsCapabilityStatement`
- **Synthetic examples**
  - `ExampleIEPatient`
  - `ExampleIEEncounter`
  - `ExampleIEMedicationRequest`
  - `ExampleIEMedicationObservation`

## Developer workflow

### Prerequisites

- Node.js 20+
- Java 17+

### Install dependencies

```bash
npm install
```

### Build and validate the FSH content

```bash
npm run build
```

### Download IG Publisher

```bash
npm run publisher:download
```

### Build the implementation guide locally

```bash
npm run publish:local
```

The generated site is written to `output/` and is ignored by git.

## Publishing

The GitHub Actions workflow validates the FSH definitions on pull requests and, on `main`, runs IG Publisher and deploys the generated guide to GitHub Pages at the canonical URL.
