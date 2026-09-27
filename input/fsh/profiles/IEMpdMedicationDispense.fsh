// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECoreMedicationDispense.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdMedicationDispense
Parent: MedicationDispense
Id: ie-mpd-medicationdispense
Title: "IE MPD MedicationDispense"
Description: "The IE Medication Events MedicationDispense profile sets minimum expectations for the MedicationDispense resource to record, search, and fetch medication dispensing events associated with a patient, based on Irish requirements."

* ^url = "https://hl7-ie.github.io/medication-events/fhir/StructureDefinition/ie-mpd-medicationdispense"
* ^status = #draft

* status 1..1 MS
* medication[x] 1..1 MS
* medication[x] ^short = "Medication dispensed. Use NMPC as the primary coding where available, with SNOMED CT Irish Edition as a secondary coding where available."
* medication[x] from IEMpdMedicationCodes (extensible)
* subject 1..1 MS
* subject only Reference(IEMpdPatient)
* context MS
* performer MS
* authorizingPrescription MS
* type MS
* quantity MS
* daysSupply MS
* whenHandedOver MS
* dosageInstruction MS
