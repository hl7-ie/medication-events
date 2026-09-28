// Aliases copied from IE Core (hl7-ie/ie-core @ 2b91509); only those used here are kept.

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $ATC = http://www.whocc.no/atc

// HSE Central Terminology Server (CTS) — NMPC & SNOMED CT Irish Edition
// FHIR endpoint: https://nmpc.hse.ie/production1/fhir
// Guidance & examples: https://github.com/hsenmpc/nmpc-api-examples
//
// The NMPC (National Medicinal Product Catalogue) is a SNOMED CT-based medication
// catalogue maintained by the HSE and hosted on the CTS. Products are represented
// as SNOMED CT concepts within the Irish Extension (module 1601000220105), with
// an NMPC supplement codesystem providing additional properties (PCRS category,
// shortage status, HPRA authorisation number, ATC mapping, etc.).
//
// Product hierarchy:
//   VTM  → ATM  (therapeutic moiety level)
//   VMP  → AMP  (medicinal product level)
//   VMPP → AMPP (pack level — dispensable unit)
//
Alias: $V2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203

// IE Medication Events Identifier Systems (IE Core ADR-006). All are PLACEHOLDERS pending HSE-published URIs (IE Core OI-003);
// see NamingSystems.fsh. GMS/DPS/LTI/HAA are PCRS scheme numbers carried as HIQA "other identifiers".
Alias: $IHI = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/ihi
Alias: $IMC = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/imc
Alias: $GMS = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/gms

// Irish Government Identifier Systems
Alias: $PPS = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/pps
Alias: $EUPatientCore = http://hl7.eu/fhir/base/StructureDefinition/patient-eu-core
Alias: $EUPractitionerCore = http://hl7.eu/fhir/base/StructureDefinition/practitioner-eu-core
Alias: $EUPractitionerRoleCore = http://hl7.eu/fhir/base/StructureDefinition/practitionerRole-eu-core
Alias: $EUOrganizationCore = http://hl7.eu/fhir/base/StructureDefinition/organization-eu-core
Alias: $EULocationCore = http://hl7.eu/fhir/base/StructureDefinition/location-eu-core

// HL7 Europe MPD — ePrescription & eDispensation (hl7.fhir.eu.mpd 0.1.0-ballot)
// https://hl7.eu/fhir/mpd
Alias: $EUMPDMedicationRequest  = http://hl7.eu/fhir/mpd/StructureDefinition/MedicationRequest-eu-mpd
Alias: $EUMPDMedicationDispense = http://hl7.eu/fhir/mpd/StructureDefinition/MedicationDispense-eu-mpd
Alias: $EUMPDMedication         = http://hl7.eu/fhir/mpd/StructureDefinition/Medication-eu-mpd

// eHDSI / MyHealth@EU system identifiers
//   NCPeH organisation identifier system (eHDSI OID)
// removed (IE Core ADR-006): unverified OID alias

// Irish National ePrescription Service (NePS) identifier system
Alias: $NePS = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/neps

// ── HL7 extensions used for HIQA demographics (IE Core ADR-002) ───────────────────────
Alias: $RecordedSexOrGender = http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender
Alias: $PatientMothersMaidenName = http://hl7.org/fhir/StructureDefinition/patient-mothersMaidenName
Alias: $PatientReligion = http://hl7.org/fhir/StructureDefinition/patient-religion
Alias: $PatientInterpreterRequired = http://hl7.org/fhir/StructureDefinition/patient-interpreterRequired

// GS1 Global Location Number: preferred URI of HL7 Terminology NamingSystem/GLN (THO 7.4.0)
Alias: $GLN = http://www.gs1.org/gln

// HIQA-sourced professional registration and facility identifier systems (IE Core ADR-006).
// PLACEHOLDER URIs pending authority-published URIs (IE Core OI-003); see NamingSystems.fsh.
Alias: $PSI = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/psi
Alias: $NMBI = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/nmbi
Alias: $DentalCouncil = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/dental-council
Alias: $PSIRPB = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/psi-rpb
Alias: $GMSPanel = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/gms-panel
// Health Services Provider Identifier (HSPI), Health Identifiers Act 2014 s.13-14; IE Core systems (ADR-001).
Alias: $HSPI-I = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/hsp-i
Alias: $HSPI-O = https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/hsp-o
Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $ATC = http://www.whocc.no/atc
Alias: $V2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $PROVENANCE-PARTICIPANT-TYPE = http://terminology.hl7.org/CodeSystem/provenance-participant-type
Alias: $IE-PROVENANCE = https://hl7-ie.github.io/medication-events/fhir/CodeSystem/ie-mpd-provenance-participant-type-codes
Alias: $IE-COUNTY = https://hl7-ie.github.io/medication-events/fhir/CodeSystem/ie-mpd-county-codes
Alias: $IE-ETHNICITY = https://hl7-ie.github.io/medication-events/fhir/CodeSystem/ie-mpd-ethnicity-codes
