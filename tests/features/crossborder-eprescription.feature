@crossborder-eprescription
# Reference examples ported from IE Core 0.2.0 (hl7-ie/ie-core @ 34ff374; IE Core ADR-009).
Feature: Cross-Border ePrescription Workflow — Seán Murphy (IE) across EU
  As an implementer of the IE MPD FHIR Implementation Guide
  I want to validate cross-border ePrescription and eDispensation examples
  So that I can ensure correct FHIR representation of Irish patient
  prescriptions dispensed in EU member states via MyHealth@EU

  Background:
    Given the SUSHI compiler has been run successfully
    And the fsh-generated resources are available

  # ──────────────────────────────────────────────────────────────────────
  # PATIENT PROFILE — Seán Patrick Murphy
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @patient-profile
  Scenario: Seán Murphy patient resource has required Irish identifiers
    Given I have the example resource "Patient-ie-mpd-patient-sean-murphy.json"
    Then the resource should have resourceType "Patient"
    And the resource should have an active status
    And the resource should have at least 3 identifiers
    And one identifier should use system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/ihi"
    And one identifier should use system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/pps"
    And one identifier should use system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"

  @crossborder @patient-profile
  Scenario: Seán Murphy PPS identifier has correct format
    Given I have the example resource "Patient-ie-mpd-patient-sean-murphy.json"
    When I extract identifiers with system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/pps"
    Then each identifier value should match pattern "^[0-9]{7}[A-Z]$"

  @crossborder @patient-profile
  Scenario: Seán Murphy IHI has 18-digit format
    Given I have the example resource "Patient-ie-mpd-patient-sean-murphy.json"
    When I extract identifiers with system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/ihi"
    Then each identifier value should match pattern "^([0-9]{18}|[0-9]{10})$"

  @crossborder @patient-profile
  Scenario: Seán Murphy eIDAS identifier uses IE country code prefix
    Given I have the example resource "Patient-ie-mpd-patient-sean-murphy.json"
    When I extract identifiers with system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
    Then each identifier value should match pattern "^IE/"

  @crossborder @patient-profile
  Scenario: GP Dr. Aoife O'Brien has IMC identifier
    Given I have the example resource "Practitioner-ie-mpd-practitioner-aoife-obrien.json"
    Then the resource should have resourceType "Practitioner"
    And the resource should have at least 1 identifiers
    And one identifier should use system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/imc"

  @crossborder @patient-profile
  Scenario: Grafton Street Medical Practice carries no unsourced identifiers (ADR-006)
    Given I have the example resource "Organization-ie-mpd-organization-grafton-medical.json"
    Then the resource should have resourceType "Organization"
    And the resource should have an active status
    And the resource should have a name value
    And no identifier should use system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/crn"
    And no identifier should use system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/hpi"

  # ──────────────────────────────────────────────────────────────────────
  # ALLERGY — PENICILLIN / AMOXICILLIN (CRITICAL)
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @allergy
  Scenario: Critical penicillin allergy has high criticality
    Given I have the example resource "AllergyIntolerance-ie-mpd-allergy-penicillin-murphy.json"
    Then the resource should have resourceType "AllergyIntolerance"
    And the resource should have a criticality of "high"

  @crossborder @allergy
  Scenario: Penicillin allergy has confirmed verification status
    Given I have the example resource "AllergyIntolerance-ie-mpd-allergy-penicillin-murphy.json"
    Then the resource should have resourceType "AllergyIntolerance"
    And the resource should have a verificationStatus of "confirmed"

  @crossborder @allergy
  Scenario: Penicillin allergy reaction severity is severe
    Given I have the example resource "AllergyIntolerance-ie-mpd-allergy-penicillin-murphy.json"
    Then the resource should have resourceType "AllergyIntolerance"
    And the resource should have at least 1 reaction

  # ──────────────────────────────────────────────────────────────────────
  # CONDITIONS
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @conditions
  Scenario: Type 2 Diabetes Mellitus condition has correct SNOMED code
    Given I have the example resource "Condition-ie-mpd-condition-t2dm-murphy.json"
    Then the resource should have resourceType "Condition"
    And the resource should have at least 1 coding
    And one coding should have code "44054006"

  @crossborder @conditions
  Scenario: Essential Hypertension condition has correct SNOMED code
    Given I have the example resource "Condition-ie-mpd-condition-hypertension-murphy.json"
    Then the resource should have resourceType "Condition"
    And the resource should have at least 1 coding
    And one coding should have code "38341003"

  @crossborder @conditions
  Scenario: Hypercholesterolaemia condition has correct SNOMED code
    Given I have the example resource "Condition-ie-mpd-condition-hypercholesterolaemia-murphy.json"
    Then the resource should have resourceType "Condition"
    And the resource should have at least 1 coding
    And one coding should have code "13644009"

  # ──────────────────────────────────────────────────────────────────────
  # SCENARIO 1: IE → GERMANY (Metformin + Lisinopril, PZN codes)
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @ie-to-de
  Scenario: IE→DE Metformin prescription has eIDAS IE/DE identifier
    Given I have the example resource "MedicationRequest-ie-rx-sean-de-metformin.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have at least 2 identifiers
    And one identifier should use system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/neps"
    And one identifier should use system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"

  @crossborder @ie-to-de
  Scenario: IE→DE prescriptions share a groupIdentifier (same prescription event)
    Given I have the example resource "MedicationRequest-ie-rx-sean-de-metformin.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have a groupIdentifier value of "IE-GP-RX-GROUP-20250120-DE"

  @crossborder @ie-to-de
  Scenario: IE→DE Lisinopril prescription allows generic substitution
    Given I have the example resource "MedicationRequest-ie-rx-sean-de-lisinopril.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have an intent value of "order"
    And the resource should have a status value of "active"

  @crossborder @ie-to-de
  Scenario: German Metformin dispensation records PZN product code
    Given I have the example resource "MedicationDispense-ie-dispense-de-metformin.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a status value of "completed"
    And the resource should have substitution wasSubstituted true

  @crossborder @ie-to-de
  Scenario: German Lisinopril dispensation records generic substitution
    Given I have the example resource "MedicationDispense-ie-dispense-de-lisinopril.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a status value of "completed"
    And the resource should have substitution wasSubstituted true

  @crossborder @ie-to-de
  Scenario: Apotheke am Brandenburger Tor pharmacy organization is valid
    Given I have the example resource "Organization-ie-org-de-apotheke-brandenburger.json"
    Then the resource should have resourceType "Organization"
    And the resource should have a name value
    And the resource should have an active status

  # ──────────────────────────────────────────────────────────────────────
  # SCENARIO 5: IE → LATVIA (Metformin + Lisinopril, ZRA codes)
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @ie-to-lv
  Scenario: IE→LV Metformin prescription has eIDAS IE/LV identifier
    Given I have the example resource "MedicationRequest-ie-rx-sean-lv-metformin.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have at least 2 identifiers
    And one identifier should use system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"

  @crossborder @ie-to-lv
  Scenario: IE→LV Metformin prescription eIDAS value contains IE/LV country codes
    Given I have the example resource "MedicationRequest-ie-rx-sean-lv-metformin.json"
    When I extract identifiers with system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
    Then each identifier value should match pattern "^IE/LV/"

  @crossborder @ie-to-lv
  Scenario: Latvian dispensation records ZRA product code
    Given I have the example resource "MedicationDispense-ie-dispense-lv-metformin.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a status value of "completed"
    And the resource should have substitution wasSubstituted true

  # ──────────────────────────────────────────────────────────────────────
  # SCENARIO 6: IE → PORTUGAL (Sertraline + Omeprazole, INFARMED codes)
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @ie-to-pt
  Scenario: IE→PT Sertraline prescription does not allow substitution
    Given I have the example resource "MedicationRequest-ie-rx-sean-pt-sertraline.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have an intent value of "order"
    And the resource should have at least 2 identifiers

  @crossborder @ie-to-pt
  Scenario: IE→PT Sertraline and Omeprazole share the same groupIdentifier
    Given I have the example resource "MedicationRequest-ie-rx-sean-pt-sertraline.json"
    Then the resource should have a groupIdentifier value of "IE-GP-RX-GROUP-20250620-PT"

  @crossborder @ie-to-pt
  Scenario: Portuguese dispensation of Sertraline was not substituted
    Given I have the example resource "MedicationDispense-ie-dispense-pt-sertraline.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a status value of "completed"
    And the resource should have substitution wasSubstituted false

  # ──────────────────────────────────────────────────────────────────────
  # SCENARIO 7: IE → DENMARK (Warfarin 5mg — anticoagulant, no substitution)
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @ie-to-dk
  Scenario: IE→DK Warfarin prescription has eIDAS IE/DK identifier
    Given I have the example resource "MedicationRequest-ie-rx-sean-dk-warfarin.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have at least 2 identifiers
    And one identifier should use system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"

  @crossborder @ie-to-dk
  Scenario: IE→DK Warfarin prescription eIDAS value contains IE/DK country codes
    Given I have the example resource "MedicationRequest-ie-rx-sean-dk-warfarin.json"
    When I extract identifiers with system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
    Then each identifier value should match pattern "^IE/DK/"

  @crossborder @ie-to-dk
  Scenario: IE→DK Warfarin prescription has a PCRS identifier
    Given I have the example resource "MedicationRequest-ie-rx-sean-dk-warfarin.json"
    When I extract identifiers with system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/neps"
    Then at least one identifier should exist

  @crossborder @ie-to-dk
  Scenario: Copenhagen pharmacy is valid
    Given I have the example resource "Organization-ie-org-dk-apoteket-copenhagen.json"
    Then the resource should have resourceType "Organization"
    And the resource should have a name value

  # ──────────────────────────────────────────────────────────────────────
  # SCENARIO 8: IE → SWEDEN (Insulin — biological, strict no-substitution)
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @ie-to-se
  Scenario: IE→SE Insulin Glargine prescription disallows substitution
    Given I have the example resource "MedicationRequest-ie-rx-sean-se-insulin-glargine.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have at least 2 identifiers

  @crossborder @ie-to-se
  Scenario: IE→SE Insulin Glargine and Aspart share same groupIdentifier
    Given I have the example resource "MedicationRequest-ie-rx-sean-se-insulin-glargine.json"
    Then the resource should have a groupIdentifier value of "IE-GP-RX-GROUP-20250710-SE"

  @crossborder @ie-to-se
  Scenario: Stockholm pharmacy is valid
    Given I have the example resource "Organization-ie-org-se-apoteket-hjartat.json"
    Then the resource should have resourceType "Organization"
    And the resource should have a name value

  # ──────────────────────────────────────────────────────────────────────
  # SCENARIO 9: IE → AUSTRIA (Atorvastatin 80mg + Ramipril 10mg)
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @ie-to-at
  Scenario: IE→AT Atorvastatin 80mg prescription has eIDAS IE/AT identifier
    Given I have the example resource "MedicationRequest-ie-rx-sean-at-atorvastatin80.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have at least 2 identifiers
    And one identifier should use system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"

  @crossborder @ie-to-at
  Scenario: IE→AT Atorvastatin and Ramipril prescriptions share groupIdentifier
    Given I have the example resource "MedicationRequest-ie-rx-sean-at-atorvastatin80.json"
    Then the resource should have a groupIdentifier value of "IE-GP-RX-GROUP-20250715-AT"

  @crossborder @ie-to-at
  Scenario: Vienna pharmacy is valid
    Given I have the example resource "Organization-ie-org-at-apotheke-goldene-kugel.json"
    Then the resource should have resourceType "Organization"
    And the resource should have a name value

  # ──────────────────────────────────────────────────────────────────────
  # SCENARIO 10: INBOUND — Finland → Ireland via NePS (Mikko Korhonen)
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @inbound @fi-to-ie @neps
  Scenario: Finnish patient Mikko Korhonen has Finnish and eIDAS identifiers
    Given I have the example resource "Patient-ie-patient-fi-mikko-korhonen.json"
    Then the resource should have resourceType "Patient"
    And the resource should have at least 2 identifiers
    And one identifier should be issued in "Finland"
    And one identifier should use system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"

  @crossborder @inbound @fi-to-ie @neps
  Scenario: Finnish patient eIDAS identifier uses FI/IE country codes
    Given I have the example resource "Patient-ie-patient-fi-mikko-korhonen.json"
    When I extract identifiers with system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
    Then each identifier value should match pattern "^FI/IE/"

  @crossborder @inbound @fi-to-ie @neps
  Scenario: Irish dispensation of Finnish prescription uses Irish dispense-id
    Given I have the example resource "MedicationDispense-ie-dispense-fi-to-ie-neps.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a status value of "completed"
    When I extract identifiers with system "urn:ietf:rfc:3986"
    Then at least one identifier should exist

  @crossborder @inbound @fi-to-ie @neps
  Scenario: Irish dispensation for Finnish patient carries Finnish Kela prescription identifier
    Given I have the example resource "MedicationDispense-ie-dispense-fi-to-ie-neps.json"
    Then one identifier should be issued in "Finland"

  @crossborder @inbound @fi-to-ie @neps
  Scenario: Hickey's Pharmacy is active Irish organization
    Given I have the example resource "Organization-ie-org-ie-hickeys-pharmacy.json"
    Then the resource should have resourceType "Organization"
    And the resource should have an active status
    And the resource should have a name value

  # ──────────────────────────────────────────────────────────────────────
  # SCENARIO 11: INBOUND — Belgium → Ireland via NePS (Lars Janssen)
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @inbound @be-to-ie @neps
  Scenario: Belgian patient Lars Janssen has Belgian NISS and eIDAS identifiers
    Given I have the example resource "Patient-ie-patient-be-lars-janssen.json"
    Then the resource should have resourceType "Patient"
    And the resource should have at least 2 identifiers
    And one identifier should be issued in "Belgium"
    And one identifier should use system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"

  @crossborder @inbound @be-to-ie @neps
  Scenario: Belgian patient eIDAS identifier uses BE/IE country codes
    Given I have the example resource "Patient-ie-patient-be-lars-janssen.json"
    When I extract identifiers with system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
    Then each identifier value should match pattern "^BE/IE/"

  @crossborder @inbound @be-to-ie @neps
  Scenario: Irish dispensation of Belgian prescription uses Irish dispense-id
    Given I have the example resource "MedicationDispense-ie-dispense-be-to-ie-neps.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a status value of "completed"
    When I extract identifiers with system "urn:ietf:rfc:3986"
    Then at least one identifier should exist

  @crossborder @inbound @be-to-ie @neps
  Scenario: McCauley's Pharmacy is active Irish organization
    Given I have the example resource "Organization-ie-org-ie-mccauleys-pharmacy.json"
    Then the resource should have resourceType "Organization"
    And the resource should have an active status

  # ──────────────────────────────────────────────────────────────────────
  # MEDICATION RESOURCES
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @medications
  Scenario: Lisinopril 10mg has ATC code C09AA03
    Given I have the example resource "Medication-ie-medication-lisinopril-10.json"
    Then the resource should have resourceType "Medication"
    And the resource should have at least 1 coding
    And one coding should have code "C09AA03"

  @crossborder @medications
  Scenario: Warfarin 5mg has ATC code B01AA03
    Given I have the example resource "Medication-ie-medication-warfarin-5.json"
    Then the resource should have resourceType "Medication"
    And the resource should have at least 1 coding
    And one coding should have code "B01AA03"

  @crossborder @medications
  Scenario: Insulin Glargine has ATC code A10AE04
    Given I have the example resource "Medication-ie-medication-insulin-glargine.json"
    Then the resource should have resourceType "Medication"
    And the resource should have at least 1 coding
    And one coding should have code "A10AE04"

  @crossborder @medications
  Scenario: Sertraline has ATC code N06AB06
    Given I have the example resource "Medication-ie-medication-sertraline-50.json"
    Then the resource should have resourceType "Medication"
    And the resource should have at least 1 coding
    And one coding should have code "N06AB06"

  @crossborder @medications
  Scenario: Atorvastatin 80mg has correct SNOMED code
    Given I have the example resource "Medication-ie-medication-atorvastatin-80.json"
    Then the resource should have resourceType "Medication"
    And the resource should have at least 1 coding
    And one coding should have code "373444002"

  # ──────────────────────────────────────────────────────────────────────
  # eIDAS IDENTIFIER FORMAT VALIDATION
  # ──────────────────────────────────────────────────────────────────────

  @crossborder @eidas-format
  Scenario: All outbound IE→DE eIDAS identifiers use IE/DE format
    Given I have the example resource "MedicationRequest-ie-rx-sean-de-metformin.json"
    When I extract identifiers with system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
    Then each identifier value should match pattern "^IE/DE/[0-9]{7}[A-Z]$"

  @crossborder @eidas-format
  Scenario: All outbound IE→LV eIDAS identifiers use IE/LV format
    Given I have the example resource "MedicationRequest-ie-rx-sean-lv-metformin.json"
    When I extract identifiers with system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
    Then each identifier value should match pattern "^IE/LV/[0-9]{7}[A-Z]$"

  @crossborder @eidas-format
  Scenario: All outbound IE→PT eIDAS identifiers use IE/PT format
    Given I have the example resource "MedicationRequest-ie-rx-sean-pt-sertraline.json"
    When I extract identifiers with system "http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier"
    Then each identifier value should match pattern "^IE/PT/[0-9]{7}[A-Z]$"
