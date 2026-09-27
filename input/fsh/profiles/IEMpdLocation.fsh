// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECoreLocation.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdLocation
Parent: $EULocationCore
Id: ie-mpd-location
Title: "IE MPD Location"
Description: "The IE Medication Events Location Profile is based upon the core FHIR Location Resource and defines the minimum set of data required to query and retrieve location information within the Irish healthcare system. It covers details such as the location name, type, address, and managing organization."

// ── Identifier ──────────────────────────────────────────────────────────
* identifier MS
* identifier ^short = "Unique code or number identifying the location to its users"
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains GLN 0..1 MS
* identifier[GLN] ^short = "Global Location Number (GLN)"
* identifier[GLN] ^comment = "HIQA EP/PS 2.11 Location ID (GLN) (Required 0..1): a 13-digit number made up of a GS1 company prefix, a location reference and a check digit. Not an organisation identifier: each GP practice in a shared building has its own GLN. System: GS1 GLN (HL7 Terminology NamingSystem/GLN)."
* identifier[GLN].system 1..1 MS
* identifier[GLN].system = $GLN
* identifier[GLN].value 1..1 MS
* identifier[GLN] obeys ie-loc-gln-1

// ── Status ──────────────────────────────────────────────────────────────
* status MS
* status ^short = "active | suspended | inactive"

// ── Operational Status ──────────────────────────────────────────────────
* operationalStatus MS

// ── Name ────────────────────────────────────────────────────────────────
* name MS
* name ^short = "Name of the location as used by humans"

// ── Alias ───────────────────────────────────────────────────────────────
* alias MS

// ── Description ─────────────────────────────────────────────────────────
* description MS
* description ^short = "Additional details about the location"

// ── Mode ────────────────────────────────────────────────────────────────
* mode MS

// ── Type ────────────────────────────────────────────────────────────────
* type MS
* type ^short = "Type of function performed at the location"
* type from http://terminology.hl7.org/ValueSet/v3-ServiceDeliveryLocationRoleType (extensible)

// ── Telecom ─────────────────────────────────────────────────────────────
* telecom MS
* telecom ^short = "Contact details of the location"
* telecom.system MS
* telecom.value MS
* telecom.use MS

// ── Address ─────────────────────────────────────────────────────────────
* address MS
* address ^short = "Physical location address"
* address.line MS
* address.city MS
* address.state MS
* address.state ^short = "County"
* address.state from https://hl7-ie.github.io/medication-events/fhir/ValueSet/ie-mpd-county (extensible)
* address.postalCode MS
* address.postalCode ^short = "Eircode or postal code"
* address.country MS

// ── Physical Type ───────────────────────────────────────────────────────
* physicalType MS

// ── Position ────────────────────────────────────────────────────────────
* position MS
* position.longitude MS
* position.latitude MS

// ── Managing Organization ───────────────────────────────────────────────
* managingOrganization MS
* managingOrganization only Reference(IEMpdOrganization)
* managingOrganization ^short = "Organization responsible for provisioning and upkeep"

// ── Part Of ─────────────────────────────────────────────────────────────
* partOf MS
* partOf only Reference(IEMpdLocation)

// ── Endpoint ────────────────────────────────────────────────────────────
* endpoint MS


Invariant: ie-loc-gln-1
Description: "GLN SHALL be 13 digits with a valid GS1 mod-10 check digit (HIQA EP/PS 2.11)"
Expression: "value.matches('^[0-9]{13}$') and (((10 - ((value.substring(0,1).toInteger() + value.substring(1,1).toInteger()*3 + value.substring(2,1).toInteger() + value.substring(3,1).toInteger()*3 + value.substring(4,1).toInteger() + value.substring(5,1).toInteger()*3 + value.substring(6,1).toInteger() + value.substring(7,1).toInteger()*3 + value.substring(8,1).toInteger() + value.substring(9,1).toInteger()*3 + value.substring(10,1).toInteger() + value.substring(11,1).toInteger()*3) mod 10)) mod 10) = value.substring(12,1).toInteger())"
Severity: #error
