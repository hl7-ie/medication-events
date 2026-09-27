// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECoreRelatedPerson.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdRelatedPerson
Parent: RelatedPerson
Id: ie-mpd-relatedperson
Title: "IE MPD RelatedPerson"
Description: "The IE Medication Events RelatedPerson profile sets minimum expectations for the RelatedPerson resource to record, search, and fetch related person data associated with a patient, based on Irish requirements."

* ^url = "https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-relatedperson"
* ^status = #draft

* active MS
* patient 1..1 MS
* patient only Reference(IEMpdPatient)
* relationship MS
* name 1..* MS
