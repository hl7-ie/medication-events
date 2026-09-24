# Contributing to medication-events

Thank you for your interest in contributing to the HL7 Ireland medication-events implementation guide. This document outlines how to contribute, with specific guidance for Irish national contributors and European affiliate contributors.

## Before You Start

1. Read [GOVERNANCE.md](./GOVERNANCE.md) to understand the federated decision-making model
2. Review [ARCHITECTURE.md](./ARCHITECTURE.md) to understand the layer structure and dependencies
3. Check open issues and pull requests to avoid duplicating work

## Contribution Workflow

### 1. Fork and Branch

```bash
# Fork the repository on GitHub (hl7-ie/medication-events)
git clone https://github.com/<your-username>/medication-events.git
git checkout -b <feature-branch>
```

### 2. Branch Naming Convention

- **Irish requirements:** `ie/<issue-number>-description`
  - Example: `ie/42-neps-ePrescription-constraints`
- **European coordination:** `eu/<issue-number>-description`
  - Example: `eu/15-medication-terminology-alignment`
- **Bug fixes:** `fix/<issue-number>-description`
  - Example: `fix/8-profile-cardinality`
- **Documentation:** `docs/<change>`
  - Example: `docs/add-architecture-diagram`

### 3. Make Your Changes

#### For Irish National Requirements

When adding Irish-specific constraints or extensions:

1. **Document regulatory drivers** in commit messages
   - Example: "Add NePS ePrescription cardinality constraints per Irish eHealth Board requirements"
2. **Add examples** reflecting Irish healthcare scenarios
   - Patient with Irish medical record number (MRN)
   - Dispenser with Irish pharmacy registration
3. **Update profiles** in `input/fsh/medication-events.fsh`
4. **Add test/example resources** in `input/resources/` or `input/examples/`
5. **Reference GitHub issues** using `Fixes #<issue-number>` in commit messages

#### For European Alignment (Cross-Country Changes)

When proposing changes that may affect European harmonization:

1. **Label your PR** with `coordination:europe` (using GitHub PR labels)
2. **Cross-reference related IGs** in your PR description
   - Mention if Belgium, Denmark, or Sweden medication IGs have similar patterns
   - Example: "Aligns with Belgian medication terminology binding approach"
3. **Add issue on [hl7-eu/coalesced](https://github.com/hl7-eu/coalesced)** if broader federation impact
4. **Discuss impact** with GOVERNANCE.md liaison contacts before major changes

### 4. Build and Validate Locally

```bash
# Install dependencies
npm install

# Build FSH content
npm run build

# Validate with IG Publisher (requires Java 17+)
npm run publisher:download  # First time only
npm run publish:local

# Check output in ./output/
open output/index.html
```

### 5. Create a Pull Request

**PR Title Format:**

```
[IE|EU|FIX] <Short description of change>
```

- `[IE]` — Irish-specific requirement
- `[EU]` — European coordination/alignment
- `[FIX]` — Bug fix or maintenance

**Example PR Titles:**
- `[IE] Add NePS ePrescription cardinality constraints`
- `[EU] Align medication terminology with Belgium IG`
- `[FIX] Correct MedicationRequest.status cardinality`

**PR Description Template:**

```markdown
## Summary
Brief description of what this PR addresses.

## Motivation (Irish National or European Context)
- **Regulatory Driver (if Irish):** Cite NePS, eHealth Board requirements, or regulatory source
- **European Alignment (if applicable):** Reference Belgium, Denmark, Sweden medication IGs
- **GitHub Issue:** Fixes #<issue-number>

## Changes
- Bullet-point list of changes
- One change per bullet

## Profile Changes (if applicable)
- List any profile additions or updates
- Example: Added `IEMedicationRequest.supportingInformation` cardinality constraint

## Example Resources (if applicable)
- List any new or updated example resources
- Example: Added ExampleIEMedicationRequestEPrescription

## Validation
- [ ] FSH builds successfully (`npm run build`)
- [ ] IG Publisher runs without errors (`npm run publish:local`)
- [ ] Output renders correctly in browser
- [ ] No breaking changes to existing profiles

## European Coordination (if applicable)
- [ ] Consulted with [hl7-eu/coalesced](https://github.com/hl7-eu/coalesced) (if cross-national impact)
- [ ] Coordinated with Belgium/Denmark/Sweden maintainers (if medication pattern alignment)

## Reviewers
- Mention HL7 Ireland maintainers or specific topic experts
```

### 6. Respond to Review Feedback

- Address questions or requested changes promptly
- Push new commits to your branch (don't rebase; reviewers can see the history)
- Re-request review when feedback is addressed

### 7. Merge and Cleanup

Once approved:
- A maintainer will merge your PR into `main`
- GitHub Actions CI/CD will build and deploy to GitHub Pages automatically
- You can delete your feature branch

## Contribution Types

### Type 1: Irish National Requirements

**Scope:** Constraints, extensions, or examples specific to Irish NePS, regulatory requirements, or healthcare system patterns.

**Process:**
1. Reference GitHub issue with regulatory driver (e.g., NePS requirement document)
2. Add profiles or constraints to `input/fsh/medication-events.fsh`
3. Create realistic Irish examples (patient identifiers, dispenser types, etc.)
4. Ensure no conflicts with European alignment

**Example Contributions:**
- NePS-compliant ePrescription cardinality constraints
- Irish medication terminology bindings (SNOMED CT + HIC codes)
- Irish-specific extensions (e.g., "Dispensed by Irish Pharmacy Identification")

### Type 2: European Alignment & Harmonization

**Scope:** Improvements in consistency with Belgium, Denmark, Sweden medication IGs or HL7 Europe FHIR Base.

**Process:**
1. Label PR with `coordination:europe`
2. Research and reference comparable approaches in other country IGs
3. Propose harmonization without sacrificing Irish requirements
4. Coordinate timing with hl7-eu/coalesced if major change

**Example Contributions:**
- "Align medication.manufacturer binding to match Belgium medication IG"
- "Adopt Swedish basprofiler pattern for Dosage.timing"
- "Harmonize MedicationRequest constraint rationale with Danish MedCom"

### Type 3: Terminology Updates

**Scope:** SNOMED CT bindings, value set expansions, or code system alignments.

**Process:**
1. Document terminology authority (SNOMED CT, HIC, National Terminology Board, etc.)
2. Provide binding rationale specific to Irish healthcare
3. Reference European terminology working group if cross-national
4. Add example resources demonstrating value set usage

**Example Contributions:**
- "Expand MedicationRequest.medicationCodeableConcept to include HIC medication codes"
- "Bind MedicationRequest.intent to SNOMED CT Irish workflow concepts"

### Type 4: Documentation and Guidance

**Scope:** README updates, governance clarifications, architecture documentation, implementation guidance.

**Process:**
1. No validation build required for documentation-only changes
2. Ensure consistency with existing documentation tone and structure
3. Cross-link related documents (GOVERNANCE.md, ARCHITECTURE.md, etc.)
4. Add examples if describing complex concepts

**Example Contributions:**
- Clarify canonical URL strategy in README
- Add implementation guide for European countries adopting medication-events
- Document Irish regulatory context in GOVERNANCE.md

## Code Style and Conventions

### FSH (FHIR Shorthand) Style

- **Naming:** PascalCase for profiles; camelCase for elements (e.g., `IEMedicationRequest`, `supportingInformation`)
- **Descriptions:** Clear, concise; reference regulatory or clinical rationale
- **Cardinality:** Specify min/max explicitly; justify constraints
- **Bindings:** Always include binding strength and value set reference
- **Comments:** Use `//` for brief notes; include GitHub issue references for complex logic

**Example FSH:**
```fsh
Profile: IEMedicationRequest
Parent: MedicationRequest
Description: "Irish medication request for NePS ePrescription workflows"

* medicationCodeableConcept only CodeableConcept
* medicationCodeableConcept from IEMedicationValueSet (required)  // NePS requirement
* supportingInformation 1..* MS  // NePS: e.prescription details mandatory
```

### Commit Message Style

```
[IE|EU|FIX] Short description (imperative mood)

Longer explanation of why and what changed. Reference GitHub issue numbers.
Include regulatory drivers if Irish national change.

Example regulation/coordination:
- NePS requirement: [link]
- Belgium alignment: Reference comparable pattern
- HL7 Europe coordination: Issue in hl7-eu/coalesced

Fixes #<issue-number>
```

### Example Naming Convention

- Irish examples: `Example<ResourceType>IE<Scenario>`
  - Example: `ExampleMedicationRequestIENePSEPrescription`
- European/generic examples: `Example<ResourceType>`
  - Example: `ExamplePatient`

## Testing and Validation

### Pre-Submission Checklist

- [ ] FSH builds without errors: `npm run build`
- [ ] IG Publisher runs: `npm run publish:local` (no fatal errors)
- [ ] Generated site is accessible at `output/index.html`
- [ ] All new profiles are documented in README or page content
- [ ] Examples render correctly in output site
- [ ] No breaking changes to existing conformance artifacts
- [ ] Branch is up-to-date with `main`: `git pull origin main`

### Common Build Issues

**Issue:** "Profile parent not found"
- **Cause:** Dependency not declared in `sushi-config.yaml`
- **Fix:** Check [ARCHITECTURE.md](./ARCHITECTURE.md) for dependency chain; add to `sushi-config.yaml` if needed

**Issue:** "Invalid cardinality"
- **Cause:** Constraint violates parent profile cardinality
- **Fix:** Review parent profile in HL7 FHIR R4 or HL7 EU Base; adjust constraint

**Issue:** "Unresolved terminology binding"
- **Cause:** ValueSet or CodeSystem not found in dependency
- **Fix:** Verify ValueSet/CodeSystem is defined in `input/fsh/` or imported via dependency

## Governance and Decision-Making

### When Is European Coordination Required?

**Required (coordination:europe label):**
- Changes to common medication profiles that other countries might adopt
- Terminology bindings that affect cross-border exchange
- Migration of canonical URL or dependency versions
- Major architectural changes

**Not Required:**
- Irish-specific constraints (national sovereignty)
- Irish regulatory compliance updates
- Documentation clarifications
- Bug fixes within existing profiles

### Reaching HL7 Ireland Maintainers

1. **GitHub Issues:** File issues on [hl7-ie/medication-events](https://github.com/hl7-ie/medication-events)
2. **Pull Requests:** Request review from HL7 Ireland team members
3. **HL7 Ireland Website:** [hl7.ie](https://www.hl7.ie/) (contact info available)

### Reaching HL7 Europe Liaison

For federation-level coordination:
1. File issue on [hl7-eu/coalesced](https://github.com/hl7-eu/coalesced)
2. Reference medication-events repository and specific change
3. Include context from GOVERNANCE.md decision-making process

## Additional Resources

- **HL7 FHIR Standard:** [hl7.org/fhir/](https://www.hl7.org/fhir/)
- **FHIR Shorthand Documentation:** [fshschool.org](https://fshschool.org/)
- **HL7 Ireland:** [hl7.ie](https://www.hl7.ie/)
- **HL7 Europe Affiliates:** [github.com/hl7-eu](https://github.com/hl7-eu)
- **Related Medication IGs:**
  - Belgium: [hl7-be/be-fhir-medication](https://github.com/hl7-be/be-fhir-medication)
  - Denmark: [medcomdk/MedCom-FHIR-Communication](https://github.com/medcomdk/MedCom-FHIR-Communication)
  - Sweden: [HL7Sweden/basprofiler](https://github.com/HL7Sweden/basprofiler)

## Recognition

Contributors to medication-events are recognized in the FHIR package metadata and repository contributor list. Significant contributions may be featured in release notes.

Thank you for contributing to Irish healthcare interoperability! 🇮🇪

---

**Questions?** Open an issue on [hl7-ie/medication-events](https://github.com/hl7-ie/medication-events) or contact HL7 Ireland.
