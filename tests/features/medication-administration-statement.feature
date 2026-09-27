@ie-mpd @administration-statement
Feature: Medication administration and medication statements (IE MPD)
  As an implementer of IE MPD
  I want given and not-given doses, and medication use statements, to be recorded safely
  So that a missed dose is always explained and a given dose always says what was given

  The HIQA ePrescription/eDispensation draft does not cover administration, so these rules are IE-defined.

  Background:
    Given the SUSHI compiler has been run successfully

  Scenario: A given dose records what was given
    Given the HIQA example "MedicationAdministration-hiqa-mad-s7-salbutamol-given.json"
    Then invariant "ie-mad-dose-1" should pass
    And invariant "ie-mad-status-1" should pass
    When I "remove the dose and the dosage text"
    Then invariant "ie-mad-dose-1" should fail

  Scenario: A dose that was not given says why
    Given the HIQA example "MedicationAdministration-hiqa-mad-s8-dose-not-given.json"
    Then invariant "ie-mad-status-1" should pass
    When I "remove the administration status reason"
    Then invariant "ie-mad-status-1" should fail

  Scenario: A not-given dose needs no dose; marking it given without a dose is rejected
    Given the HIQA example "MedicationAdministration-hiqa-mad-s8-dose-not-given.json"
    Then invariant "ie-mad-dose-1" should pass
    When I "record the dose as completed"
    Then invariant "ie-mad-dose-1" should fail

  Scenario: The medication statement claims the IE MPD profile on the HL7 Europe Base parent
    Given I have the profile "StructureDefinition-ie-mpd-medicationstatement.json"
    Then the profile baseDefinition should be "http://hl7.eu/fhir/base/StructureDefinition/medicationStatement-eu-core"
