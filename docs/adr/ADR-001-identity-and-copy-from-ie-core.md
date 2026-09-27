# ADR-001: Identity, and copying from IE Core

- **Status:** Accepted (27 September 2026)
- **Breaking:** yes (compared with the starter scaffold)

## Context

The repository started as a scaffold with the package id `hl7.fhir.ie.medication-events` and the canonical
`https://hl7.eu/fhir/ie/medication-events/fhir`, and its documents described it as an HL7 Ireland guide within an
HL7 Europe federation. This IG is a proof of concept by an individual author. It is not affiliated with, or endorsed
by, HL7 Ireland, HL7 Europe, HIQA, the HSE or the Department of Health.

- The FHIR package specification reserves the `hl7.*` prefix: "HL7 manages all the packages that start with hl7."
  (<https://hl7.org/fhir/packages.html>).
- `hl7.eu` is HL7 Europe's domain. A canonical there implies HL7 Europe publishes the content.
- IE Core (`hl7-ie/ie-core`, package `nostalgic-ie.fhir.core`, release "Nostalgic IE") already holds ePrescription
  and eDispensation profiles aligned with the HIQA draft (September 2026). The project owner asked that IE Core keep
  them, and that this IG take what it needs.

## Decision

1. **Identity.** Package id `nostalgic-ie.fhir.medication-events`, canonical
   `https://hl7-ie.github.io/medication-events/fhir`, name `IEMpd`, release name "Nostalgic IE" (the IE Core family's
   code name). Every page and README says it is a proof of concept, not affiliated with those bodies.
2. **Copy, own canonical.** The ePrescription and eDispensation artefacts are **copied** from IE Core
   (`hl7-ie/ie-core` @ 2b91509), not referenced as a package dependency. The copy is tree-shaken: only the profiles,
   extensions, terminology, NamingSystems and examples reachable from the ePrescription, eDispensation and medication
   statement roots are kept. They are renamed `IECore*` → `IEMpd*` and `ie-core-*` → `ie-mpd-*`, and take this IG's
   canonical. Each copied file names its source file and commit in a header comment.
3. **Identifier systems stay in IE Core's namespace.** Identifier `system` URIs
   (`https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/...`) are **not** renamed, so an IHI, PPSN or IMC number is
   written the same way in both IGs. They remain placeholders until the HSE publishes system URIs (OI-003).
4. **References to IE Core decisions** carried in the copied content are qualified ("IE Core ADR-003", "IE Core
   HZ-06"). Open-issue numbers keep IE Core's numbers (OI-0xx); issues specific to this IG are OI-1xx.

## Consequences

- The IG can be built, versioned and published on its own, and IE Core is unchanged.
- The two copies can drift. A change to an ePrescription rule in one should be considered for the other; the header
  comment gives the IE Core commit to diff against.
- Instances valid against IE Core are **not** automatically valid against this IG (different profile URLs in
  `meta.profile`), although the rules are the same at the time of copying.
- The scaffold's package id and canonical are retired; nothing was ever published under them.
