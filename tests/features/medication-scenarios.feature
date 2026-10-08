@medication-scenarios
# Reference examples ported from IE Core 0.2.0 (hl7-ie/ie-core @ 34ff374; IE Core ADR-009).
Feature: IE MPD Medication Request and Dispensing Scenarios
  As an implementer of the IE MPD FHIR Implementation Guide
  I want to validate medication request and dispensing examples
  So that I can ensure correct FHIR representation of Irish and cross-border medication workflows

  Background:
    Given the SUSHI compiler has been run successfully
    And the fsh-generated resources are available

  # ──────────────────────────────────────────────
  # Scenario 1: Local IE – Full Dispensing
  # ──────────────────────────────────────────────

  @medication @full-dispense
  Scenario: ePrescription profile validates against base MedicationRequest profile
    Given I have the example resource "MedicationRequest-ie-prescription-scenario1-full.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have a status value
    And the resource should have a subject reference
    And the resource should have an intent value of "order"

  @medication @full-dispense
  Scenario: Full dispensation MedicationDispense has completed status
    Given I have the example resource "MedicationDispense-ie-dispense-scenario1-full.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a status value of "completed"
    And the resource should have a quantity value

  @medication @full-dispense
  Scenario: ePrescription has a PCRS identifier
    Given I have the example resource "MedicationRequest-ie-prescription-scenario1-full.json"
    When I extract identifiers with system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/neps"
    Then at least one identifier should exist

  # ──────────────────────────────────────────────
  # Scenario 2: Local IE – Partial Dispensing
  # ──────────────────────────────────────────────

  @medication @partial-dispense
  Scenario: Partial dispense prescription has 2 repeats allowed (90-day supply)
    Given I have the example resource "MedicationRequest-ie-prescription-scenario2-partial.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have a dispenseRequest with numberOfRepeatsAllowed of 2
    And the resource should have a dispenseRequest quantity of 90

  @medication @partial-dispense
  Scenario: First partial dispense uses type FFP (First Fill - Part Fill)
    Given I have the example resource "MedicationDispense-ie-dispense-scenario2-partial-1.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a dispense type code of "FFP"
    And the resource should have a quantity value of 30

  @medication @partial-dispense
  Scenario: Second partial dispense references same authorising prescription
    Given I have the example resource "MedicationDispense-ie-dispense-scenario2-partial-2.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have an authorizingPrescription reference

  @medication @partial-dispense
  Scenario: Third partial dispense completes the 90-tablet prescription
    Given I have the example resource "MedicationDispense-ie-dispense-scenario2-partial-3.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a status value of "completed"
    And the resource should have a dispense type code of "FFP"

  # ──────────────────────────────────────────────
  # Scenario 3: Multiple Prescriptions Bundle
  # ──────────────────────────────────────────────

  @medication @multi-prescription
  Scenario: Metformin prescription has a groupIdentifier
    Given I have the example resource "MedicationRequest-ie-prescription-scenario3-multi-metformin.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have a groupIdentifier

  @medication @multi-prescription
  Scenario: Atorvastatin prescription shares the same groupIdentifier
    Given I have the example resource "MedicationRequest-ie-prescription-scenario3-multi-atorvastatin.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have a groupIdentifier value of "IE-GP-RX-GROUP-20240620"

  @medication @multi-prescription
  Scenario: Ramipril prescription is intent order
    Given I have the example resource "MedicationRequest-ie-prescription-scenario3-multi-ramipril.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have an intent value of "order"

  @medication @multi-prescription
  Scenario: Multi-prescription Metformin dispense references correct prescription
    Given I have the example resource "MedicationDispense-ie-dispense-scenario3-metformin.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have an authorizingPrescription reference

  # ──────────────────────────────────────────────
  # Scenario 4: Cross-border IE → ES
  # ──────────────────────────────────────────────

  @medication @crossborder @ie-to-es
  Scenario: Irish cross-border prescription has both PCRS and MyHealth@EU identifiers
    Given I have the example resource "MedicationRequest-ie-prescription-scenario4-ie-to-es.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have at least 2 identifiers
    And one identifier should use system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/neps"
    And one identifier should use system "urn:oid:2.16.840.1.113883.19.1.4.1"

  @medication @crossborder @ie-to-es
  Scenario: Spanish dispensation of Irish cross-border prescription records substitution
    Given I have the example resource "MedicationDispense-ie-dispense-scenario4-es-pharmacy.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a status value of "completed"
    And the resource should have substitution wasSubstituted true

  @medication @crossborder @ie-to-es
  Scenario: Irish patient Ciarán Walsh has Irish IHI identifier
    Given I have the example resource "Patient-ie-mpd-patient-ciaran-walsh.json"
    Then the resource should have resourceType "Patient"
    When I extract identifiers with system "https://hl7-ie.github.io/ie-core/fhir/ie/core/sid/ihi"
    Then each identifier value should match pattern "^([0-9]{18}|[0-9]{10})$"

  # ──────────────────────────────────────────────
  # Scenario 5: Cross-border ES → IE
  # ──────────────────────────────────────────────

  @medication @crossborder @es-to-ie
  Scenario: Spanish patient has CIP identifier
    Given I have the example resource "Patient-ie-mpd-patient-es-maria-garcia.json"
    Then the resource should have resourceType "Patient"
    And the resource should have at least 1 identifier
    And one identifier should be issued in "Spain"

  @medication @crossborder @es-to-ie
  Scenario: Spanish prescription has Spanish receta identifier and cross-border identifier
    Given I have the example resource "MedicationRequest-ie-prescription-scenario5-es-to-ie.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have at least 2 identifiers
    And one identifier should be issued in "Spain"

  @medication @crossborder @es-to-ie
  Scenario: Irish dispensation of Spanish prescription uses Irish dispense identifier
    Given I have the example resource "MedicationDispense-ie-dispense-scenario5-ie-pharmacy.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a status value of "completed"
    When I extract identifiers with system "urn:ietf:rfc:3986"
    Then at least one identifier should exist

  @medication @crossborder @es-to-ie
  Scenario: Irish dispensation of Spanish prescription does not substitute
    Given I have the example resource "MedicationDispense-ie-dispense-scenario5-ie-pharmacy.json"
    Then the resource should have substitution wasSubstituted false

  # ──────────────────────────────────────────────
  # Scenario 6: Repeat Prescription (6-month GMS)
  # ──────────────────────────────────────────────

  @medication @repeat-prescription
  Scenario: 6-month GMS repeat prescription has 5 repeats allowed
    Given I have the example resource "MedicationRequest-ie-prescription-scenario6-repeat.json"
    Then the resource should have resourceType "MedicationRequest"
    And the resource should have a dispenseRequest with numberOfRepeatsAllowed of 5
    And the resource should have a validity period spanning 6 months

  @medication @repeat-prescription
  Scenario: First monthly dispensation has type FF (First Fill)
    Given I have the example resource "MedicationDispense-ie-dispense-scenario6-repeat-month1.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a dispense type code of "FF"

  @medication @repeat-prescription
  Scenario: Second monthly dispensation has type RF (Refill)
    Given I have the example resource "MedicationDispense-ie-dispense-scenario6-repeat-month2.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a dispense type code of "RF"

  @medication @repeat-prescription
  Scenario: Third monthly dispensation has type RF (Refill)
    Given I have the example resource "MedicationDispense-ie-dispense-scenario6-repeat-month3.json"
    Then the resource should have resourceType "MedicationDispense"
    And the resource should have a dispense type code of "RF"

  # ──────────────────────────────────────────────
  # Supporting Resource Validation
  # ──────────────────────────────────────────────

  @medication @supporting-resources
  Scenario: Irish pharmacy organization is valid
    Given I have the example resource "Organization-ie-mpd-organization-pharmacy-example.json"
    Then the resource should have resourceType "Organization"
    And the resource should have an active status
    And the resource should have a name value

  @medication @supporting-resources
  Scenario: Irish pharmacist has PSI identifier
    Given I have the example resource "Practitioner-ie-mpd-practitioner-pharmacist-example.json"
    Then the resource should have resourceType "Practitioner"
    And the resource should have at least 1 identifier
    And the resource should have a name with a family component

  @medication @supporting-resources
  Scenario: Spanish health centre organization is valid
    Given I have the example resource "Organization-ie-mpd-organization-es-health-centre.json"
    Then the resource should have resourceType "Organization"
    And the resource should have a name value

  @medication @supporting-resources
  Scenario: Spanish pharmacy organization is valid
    Given I have the example resource "Organization-ie-mpd-organization-es-pharmacy.json"
    Then the resource should have resourceType "Organization"
    And the resource should have a name value
