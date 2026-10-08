# ADR-003: Electronic Prescription Group

- **Status:** Accepted (project owner request, 2026-10-08)
- **Breaking:** yes (the ePrescription Bundle now requires a prescription group entry)
- **Supersedes:** IE Core ADR-003's derivation of the prescription-level status from the item statuses
- **Related:** HIQA EP Section 3; open issues OI-013 (resolved here), OI-104; ADR-004

## Context

HIQA EP Section 3 describes the prescription as a whole: an identifier with type and value (3.1, Mandatory 1..*),
the date and time of issue (3.2), a prescription status with reason (3.3, Mandatory), a presented form (3.4) and its
items (3.5). Until now the IG carried these on each MedicationRequest: the identifier as `groupIdentifier`, the date
as `authoredOn`, and the prescription status was *derived* from the item statuses. 3.1.1, 3.3 to 3.3.3 were Partial
and 3.4 was a Gap.

The project owner asked for an "Electronic Prescription Group" extending over the Bundle, carrying the prescription
identifier, the prescription status and provenance.

- **FHIR R4 Bundle cannot carry it.** Bundle is a `Resource`, not a `DomainResource`: it has no `extension`,
  `status` or `text`. A Bundle profile can constrain entries but cannot add prescription-level data.
- **FHIR R4 RequestGroup is the grouping resource for requests**: `identifier`, `groupIdentifier`, `status`,
  `intent`, `subject`, `authoredOn`, `author`, `note` and `action` (each action pointing to a request). It has no
  `statusReason` or presented form, and the core `request-statusReason` and `workflow-supportingInfo` extensions do
  not allow RequestGroup as a context (checked in hl7.fhir.uv.extensions.r4 5.1.0).
- **HL7 Europe MPD 1.0.0 and IHE MPD** do not profile a prescription container; they group items by
  `MedicationRequest.groupIdentifier`.
- **NHS England EPS** (reference, `uk.nhsdigital.r4` 2.11.0 and `uk.nhsdigital.medicines.r4` 2.7.9): no container
  resource either. A prescription is the set of MedicationRequests sharing `groupIdentifier` (short-form id, with
  the long-form UUID in `Extension-DM-PrescriptionId`). The `prescription-order` MessageDefinition sends a `message`
  Bundle (MessageHeader event `prescription-order`, 1 to 4 MedicationRequests, a Provenance holding the signature)
  and requires the items to agree on status, intent, category, subject, requester, `groupIdentifier`,
  `courseOfTherapyType` and validity period. Cancellation is a `prescription-order-update` message; prescription
  status history is an extension on each item.

## Options

| Option | Advantages | Disadvantages |
|---|---|---|
| A. Keep deriving the status from the items (status quo) | No change | HIQA 3.3 stays Partial; no place for 3.3.2 reason or 3.4 presented form |
| B. Extensions on the Bundle | Matches "extending over a bundle" | Not possible in R4 (Bundle has no extensions) |
| **C. RequestGroup entry in the ePrescription Bundle** | FHIR's grouping resource; carries identifier, authoredOn, status, author and the items; extensions are allowed | Two places hold the identifier and date (group and items), so consistency rules are needed |
| D. Composition (document Bundle) | Has status, sections, attester | A document, not an order; changes the Bundle type for every prescription |
| E. Task | Has status, statusReason, businessStatus | Models the workflow step, not the prescription; EPS uses Task for release/return, not for the prescription |

## Decision

Option C. `IEMpdElectronicPrescriptionGroup` (RequestGroup) is a mandatory entry (`prescriptionGroup` 1..1) in
`IEMpdBundleEPrescription`:

| HIQA EP | Group element |
|---|---|
| 3.1 / 3.1.1 / 3.1.2 identifier, type, value | `identifier` 1..* with `type`, `system`, `value` 1..1 |
| 3.2 date and time of issue | `authoredOn` 1..1 |
| 3.3 / 3.3.1 status | `status` (request-status) |
| 3.3.2 / 3.3.3 status reason | extension `IEMpdPrescriptionGroupStatusReason` (CodeableConcept; text) |
| 3.4 presented form | extension `IEMpdPresentedForm` (Attachment) |
| 3.5 items | `action.resource` → each `IEMpdMedicationRequestEPrescription` |
| prescriber, patient | `author`, `subject` |

Consistency rules (Bundle level, informed by the EPS `prescription-order` rules):

- `ie-bnd-rx-7`: the group lists every item as an action, and only those.
- `ie-bnd-rx-8`: every item's `groupIdentifier` is one of the group's identifiers.
- `ie-bnd-rx-9`: every item has the group's patient, prescriber (`requester` = `author`) and `authoredOn`.
- `ie-bnd-rx-10` (warning): the group status agrees with the items (active → an active item; revoked → only
  cancelled or stopped items; completed → no active, on-hold or draft item).
- `ie-grp-status-1`: a reason is given unless the prescription is active, completed or draft.

Provenance: the signature Provenance may also target the group (`target` allows the group); the cross-border rule
that every item is signed (`ie-bnd-xb-2`) is unchanged.

Also closed here because it is a prescription-level rule: **HIQA EP 2.9 healthcare facility address**
(`ie-bnd-rx-11`): the organisation of the prescriber's role has an address line, county, postcode and country
(IE Core OI-013).

Not adopted from EPS: FHIR messaging (MessageHeader, `prescription-order` / `-update`). HIQA does not specify the
national service interface, so the Bundle stays a `collection`; a message wrapper can carry it unchanged if NePS
defines one (open issue OI-105).

## Consequences

- HIQA EP 3.1, 3.1.1, 3.1.2, 3.2, 3.3, 3.3.1 to 3.3.3 and 3.4 are Aligned; 2.9 is enforced.
- Every ePrescription Bundle now has a group entry (breaking for the 0.1.0 draft; scenarios 1 to 6 updated).
- Scenario 10 shows a whole-prescription cancellation (group `revoked` with a reason, item `cancelled`), like the
  EPS cancellation examples B1/C1.
- The identifier type (3.1.1) has no HIQA value set; examples use v2-0203 `PLAC` (OI-104).
