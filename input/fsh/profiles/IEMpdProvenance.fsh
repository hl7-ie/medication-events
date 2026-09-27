// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECoreProvenance.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdProvenance
Parent: Provenance
Id: ie-mpd-provenance
Title: "IE MPD Provenance"
Description: "The IE Medication Events Provenance profile sets minimum expectations for the Provenance resource to record, search, and fetch provenance information associated with a record, based on Irish requirements."

* ^url = "https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-provenance"
* ^status = #draft

* target 1..* MS
* recorded 1..1 MS
* agent 1..* MS
* agent.type MS
* agent.type from IEMpdProvenanceParticipantType (extensible)
* agent.who MS
* agent.who only Reference(IEMpdPractitioner or IEMpdPractitionerRole or IEMpdOrganization or IEMpdPatient or Device or RelatedPerson)
* agent.onBehalfOf MS
* agent.onBehalfOf only Reference(IEMpdOrganization)
