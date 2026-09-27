// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECorePractitionerRole.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdPractitionerRole
Parent: $EUPractitionerRoleCore
Id: ie-mpd-practitionerrole
Title: "IE MPD PractitionerRole"
Description: "The IE Medication Events PractitionerRole Profile is based upon the core FHIR PractitionerRole Resource and defines the minimum set of data required to query and retrieve practitioner role information within the Irish healthcare system. It constrains references to IE Medication Events profiles and binds the role code to the IE Medication Events Healthcare Provider Taxonomy."

// ── Identifier ──────────────────────────────────────────────────────────
* identifier MS

// ── Active ──────────────────────────────────────────────────────────────
* active MS

// ── Period ──────────────────────────────────────────────────────────────
* period MS

// ── Practitioner ────────────────────────────────────────────────────────
* practitioner MS
* practitioner only Reference(IEMpdPractitioner)
* practitioner ^short = "Practitioner that is able to provide the defined services for the organization"

// ── Organization ────────────────────────────────────────────────────────
* organization MS
* organization only Reference(IEMpdOrganization)
* organization ^short = "Organization where the roles are available"

// ── Code (Role) ─────────────────────────────────────────────────────────
* code MS
* code ^short = "Roles which this practitioner may perform"
* code from https://hl7-ie.github.io/medication-events/fhir/ValueSet/ie-mpd-healthcare-provider-taxonomy (extensible)

// ── Specialty ───────────────────────────────────────────────────────────
* specialty MS
* specialty ^short = "Specific specialty of the practitioner"
* specialty from http://hl7.org/fhir/ValueSet/c80-practice-codes (preferred)

// ── Location ────────────────────────────────────────────────────────────
* location MS
* location only Reference(IEMpdLocation)
* location ^short = "The location(s) at which this practitioner provides care"

// ── Telecom ─────────────────────────────────────────────────────────────
* telecom MS
* telecom ^short = "Contact details that are specific to the role/location/service"
* telecom.system MS
* telecom.value MS
* telecom.use MS

// ── Healthcare Service ──────────────────────────────────────────────────
* healthcareService MS

// ── Endpoint ────────────────────────────────────────────────────────────
* endpoint MS
* endpoint ^short = "Technical endpoints providing access to services operated for the practitioner with this role"
