# ADR-003: Electronic Prescription Group (ePG)

- **Status:** Accepted (project owner, 2026-10-08)
- **Breaking:** yes (the ePrescription Bundle is renamed the Electronic Prescription Group and requires a header)
- **Supersedes:** IE Core ADR-003's derivation of the prescription-level status from the item statuses
- **Related:** HIQA EP Sections 3 and 6; open issues OI-013 (resolved here), OI-104, OI-105; ADR-004

## Context

HIQA EP Section 3 describes the prescription as a whole: an identifier with type and value (3.1, Mandatory 1..*),
the date and time of issue (3.2), a prescription status with reason (3.3, Mandatory), a presented form (3.4) and its
items (3.5). Until now the IG carried these on each MedicationRequest: the identifier as `groupIdentifier`, the date
as `authoredOn`, and the prescription status was *derived* from the item statuses. 3.1.1, 3.3 to 3.3.3 were Partial
and 3.4 was a Gap.

The project owner defined the concept: **an Electronic Prescription Group (ePG) is a Bundle of one or more
electronic prescriptions (eP, each a MedicationRequest) issued together as part of the same request, together with
their eDispensations and provenance.** HIQA's draft calls the group "the electronic prescription" and each eP a
"prescription item"; the group identifier and status are HIQA's electronic prescription identifier (3.1) and
prescription status (3.3). The group-level HIQA data must live somewhere in the ePG.

- **A FHIR R4 Bundle cannot carry prescription-level data.** Bundle is a `Resource`, not a `DomainResource`: no
  `extension`, `status` or `text`. A Bundle profile can constrain entries only.
- **FHIR R4 RequestGroup is the grouping resource for requests**: `identifier`, `status`, `intent`, `subject`,
  `authoredOn`, `author`, `note` and `action` (each action pointing to a request). It has no `statusReason` or
  presented form, and the core `request-statusReason` and `workflow-supportingInfo` extensions do not allow
  RequestGroup as a context (checked in hl7.fhir.uv.extensions.r4 5.1.0).
- **HL7 Europe MPD 1.0.0 and IHE MPD** do not profile a prescription container; they group items by
  `MedicationRequest.groupIdentifier`.
- **NHS England EPS** (reference, `uk.nhsdigital.r4` 2.11.0 and `uk.nhsdigital.medicines.r4` 2.7.9): no container
  resource either. A prescription is the set of MedicationRequests sharing `groupIdentifier` (short-form id, with
  the long-form UUID in `Extension-DM-PrescriptionId`). The `prescription-order` MessageDefinition sends a `message`
  Bundle (MessageHeader event `prescription-order`, 1 to 4 MedicationRequests, a Provenance holding the signature)
  and requires the items to agree on status, intent, category, subject, requester, `groupIdentifier`,
  `courseOfTherapyType` and validity period. Dispensing is a separate `dispense-notification` message; cancellation
  is `prescription-order-update`.

## Options for the prescription-level data

| Option | Advantages | Disadvantages |
|---|---|---|
| **A. Header (RequestGroup) inside the ePG** | FHIR's grouping resource; carries identifier, authoredOn, status, author and the eP; extensions are allowed; HIQA 3.3 Aligned | The identifier and date also appear on the items, so consistency rules are needed |
| B. No header; derive the status from the eP statuses | Fewer resources | HIQA 3.3 Partial; no place for the 3.3.2 reason or 3.4 presented form |
| C. Extensions on the Bundle | Matches "extending over a bundle" | Not possible in R4 |
| D. Composition (document Bundle) | Has status, sections, attester | A document, not an order |
| E. Task | Has status, statusReason, businessStatus | Models a workflow step, not the prescription |

The project owner chose A (2026-10-08).

## Decision

**`IEMpdElectronicPrescriptionGroup`** (Bundle, `collection`) is the ePG. Its entries:

| Slice | Profile | Cardinality |
|---|---|---|
| `header` | `IEMpdPrescriptionGroupHeader` (RequestGroup) | 1..1 |
| `electronicPrescription` | `IEMpdMedicationRequestEPrescription` (eP) | 1..* |
| `dispensation` | `IEMpdMedicationDispenseEDispensation` | 0..* |
| `provenance` | `IEMpdProvenance` (the prescriber's signature is `IEMpdProvenanceEPrescriptionSignature`) | 0..* (1..* cross-border) |
| `patient`, `allergyStatement`, `allergy`, `practitioner`, `practitionerRole`, `organization`, `medication` | as before | — |

`Bundle.identifier` is the prescription group identifier (HIQA EP 3.1), also every eP's `groupIdentifier`. The cross-border ePG is
`IEMpdElectronicPrescriptionGroupCrossBorder`.

**`IEMpdPrescriptionGroupHeader`** (RequestGroup) carries HIQA EP 3.1 `identifier` (type, system, value), 3.2
`authoredOn`, 3.3 `status` with the `IEMpdPrescriptionGroupStatusReason` extension, 3.4 the `IEMpdPresentedForm`
extension, and 3.5 one `action` per item; `author` is the prescriber and `subject` the patient.

Rules (ePG level; the item rules are informed by the EPS `prescription-order` rules):

- `ie-bnd-rx-7`: the header lists every eP as an action, and only those.
- `ie-bnd-rx-8`: every eP's `groupIdentifier` is one of the header's identifiers.
- `ie-bnd-rx-9`: every eP has the header's patient, prescriber (`requester` = `author`) and `authoredOn`.
- `ie-bnd-rx-10` (warning): the group status agrees with the eP statuses.
- `ie-grp-status-1`: a reason is given unless the prescription is active, completed or draft.
- `ie-bnd-rx-11`: the prescriber's facility has a full address (HIQA EP 2.9; IE Core OI-013 resolved).
- `ie-bnd-rx-12`: every eDispensation is authorised by an eP in the same ePG (HIQA EP 6.5).
- `ie-bnd-rx-13`: every eDispensation is for the ePG's patient.
- `ie-bnd-rx-14` (warning): every Provenance targets resources in the same ePG.

The signature Provenance may also target the header; the cross-border rule that every eP is signed (`ie-bnd-xb-2`)
is unchanged.

Not adopted from EPS: FHIR messaging (MessageHeader, `prescription-order`, `dispense-notification`). HIQA does not
specify the national service interface, so the ePG stays a `collection`; a message wrapper can carry it unchanged if
NePS defines one (OI-105).

## Consequences

- HIQA EP 3.1, 3.1.1, 3.1.2, 3.2, 3.3, 3.3.1 to 3.3.3 and 3.4 are Aligned; 2.9 is enforced.
- Profile ids change (unpublished 0.1.0 draft): `ie-mpd-bundle-eprescription` → `ie-mpd-electronic-prescription-group`,
  `ie-mpd-bundle-eprescription-crossborder` → `ie-mpd-electronic-prescription-group-crossborder`; the header is
  `ie-mpd-prescription-group-header`.
- Scenarios 1, 3, 4 and 5 are full ePGs (eP with their eDispensations, scenario 1 also with dispensing provenance);
  scenario 10 shows a cancelled prescription (header `revoked` with a reason), like the EPS cancellation examples.
- The identifier type (3.1.1) has no HIQA value set; examples use v2-0203 `PLAC` (OI-104).
