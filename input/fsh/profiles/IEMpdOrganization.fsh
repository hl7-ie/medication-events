// Copied from IE Core (hl7-ie/ie-core @ 2b91509, input/fsh/profiles/IECoreOrganization.fsh) and renamed for
// IE Medication Events (ADR-001). Only the definitions this IG needs are kept.

Profile: IEMpdOrganization
Parent: $EUOrganizationCore
Id: ie-mpd-organization
Title: "IE MPD Organization"
Description: "The IE Medication Events Organization Profile is based upon the core FHIR Organization Resource and defines the minimum set of data required to query and retrieve organization information within the Irish healthcare system. Identifier slicing for HIQA-sourced facility identifiers is defined in the use-case context (HIQA EP/PS 2.8, 2.12)."

// ── Identifier Slicing ──────────────────────────────────────────────────
* identifier MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^short = "Identifies this organization across multiple systems"
* identifier ^comment = "HIQA EP/PS 2.8 Healthcare facility identifier (Required): for a pharmacy, the PSI Retail Pharmacy Business (RPB) registration number. HIQA EP/PS 2.12 GMS Panel ID (Optional) for a GP. The GLN (2.11) is a location identifier (IEMpdLocation)."
* identifier contains
    PSIRPB 0..1 MS and
    GMSPanel 0..1 and
    HSPO 0..1
* identifier[HSPO] ^short = "Health Services Provider Identifier, organisation (HSP-O)"
* identifier[HSPO] ^comment = "Health Identifiers Act 2014 s.13 assigns a health services provider identifier (HSPI, 'a unique number', alphanumeric) to each health services provider, including organisations such as hospitals, GP practices and pharmacies; s.14 keeps it in the National Register of Health Services Provider Identifiers (Parts B, E for organisations). Not a HIQA draft element, so not MustSupport. No format is set by the Act. System URI placeholder shared with IE Core (IE Core OI-003, OI-030)."
* identifier[HSPO].system 1..1
* identifier[HSPO].system = $HSPI-O
* identifier[HSPO].type = $V2-0203#XX "Organization identifier"
* identifier[HSPO].value 1..1
* identifier[PSIRPB] ^short = "PSI Retail Pharmacy Business (RPB) registration number"
* identifier[PSIRPB] ^comment = "HIQA EP/PS 2.8: the unique registration number issued by the PSI to a Retail Pharmacy Business. System URI placeholder (IE Core OI-003)."
* identifier[PSIRPB].system 1..1 MS
* identifier[PSIRPB].system = $PSIRPB
* identifier[PSIRPB].value 1..1 MS
* identifier[GMSPanel] ^short = "GMS Panel ID (GP)"
* identifier[GMSPanel] ^comment = "HIQA EP/PS 2.12 GMS Panel ID (Optional): typically a five- to six-digit number assigned to a GP registered with the HSE to provide General Medical Services. No format is enforced (HIQA says 'typically'). System URI placeholder (IE Core OI-003)."
* identifier[GMSPanel].system 1..1
* identifier[GMSPanel].system = $GMSPanel
* identifier[GMSPanel].value 1..1
// ── Active ──────────────────────────────────────────────────────────────
* active MS
* active ^short = "Whether the organization's record is still in active use"

// ── Type ────────────────────────────────────────────────────────────────
* type MS
* type ^short = "Kind of organization"
* type from http://hl7.org/fhir/ValueSet/organization-type (preferred)

// ── Name ────────────────────────────────────────────────────────────────
* name 1..1 MS
* name ^comment = "HIQA EP/PS 2.7 Healthcare facility name (Required): for a pharmacy, the Retail Pharmacy Business name as registered with the PSI."
* name ^short = "Name used for the organization"

// ── Alias ───────────────────────────────────────────────────────────────
* alias MS

// ── Telecom ─────────────────────────────────────────────────────────────
* telecom MS
* telecom ^short = "A contact detail for the organization"
* telecom.system MS
* telecom.value MS
* telecom.use MS

// ── Address ─────────────────────────────────────────────────────────────
* address MS
* address ^short = "An address for the organization"
* address ^comment = "HIQA EP/PS 2.9 Healthcare facility address (Mandatory 1..1): postcode (2.9.1 M), address line(s) (2.9.2 M), locality (2.9.3 R), county (2.9.4 M) and country (2.9.5 M). Enforced for the prescriber and dispenser facilities in the ePrescription Bundle (invariant ie-bnd-rx-5)."
* address.line MS
* address.city MS
* address.state MS
* address.state from https://hl7-ie.github.io/medication-events/fhir/ValueSet/ie-mpd-county (extensible)
* address.postalCode MS
* address.country MS

// ── Contact ─────────────────────────────────────────────────────────────
* contact MS
* contact.purpose MS
* contact.name MS
* contact.telecom MS

// ── Part Of ─────────────────────────────────────────────────────────────
* partOf MS
* partOf only Reference(IEMpdOrganization)

// ── Endpoint ────────────────────────────────────────────────────────────
* endpoint MS
