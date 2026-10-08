@ie-mpd @prescription-group @dosage
Feature: Electronic Prescription Group (ePG) and Dosage (ADR-003, ADR-004)
  As an implementer of IE MPD
  I want the prescription as a whole, and every dosage, to follow the HIQA EP rules
  So that a prescription's identifier, date, status and items always agree, and a dosage is always readable and complete

  Each rule is shown passing on a scenario example, then failing on a deliberately broken copy.

  Background:
    Given the SUSHI compiler has been run successfully

  # ── Prescription group (HIQA EP Section 3) ─────────────────────────────

  Scenario: Every scenario Bundle passes the prescription group rules
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    Then invariant "ie-bnd-rx-7" should pass
    And invariant "ie-bnd-rx-8" should pass
    And invariant "ie-bnd-rx-9" should pass
    And invariant "ie-bnd-rx-10" should pass
    And invariant "ie-bnd-rx-11" should pass

  Scenario: A two-item prescription lists both items in its group
    Given the HIQA example "Bundle-hiqa-bundle-s6-crossborder.json"
    Then invariant "ie-bnd-rx-7" should pass
    When I "drop the second item from the prescription group"
    Then invariant "ie-bnd-rx-7" should fail

  Scenario: Every item carries the prescription identifier (HIQA EP 3.1)
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    When I "give the first item another prescription identifier"
    Then invariant "ie-bnd-rx-8" should fail

  Scenario: Every item has the prescription's date of issue (HIQA EP 3.2)
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    When I "change the first item date of issue"
    Then invariant "ie-bnd-rx-9" should fail

  Scenario: A cancelled prescription gives the reason (HIQA EP 3.3.2)
    Given the HIQA example "RequestGroup-hiqa-grp-s10-cancelled.json"
    Then invariant "ie-grp-status-1" should pass
    When I "remove the prescription group status reason"
    Then invariant "ie-grp-status-1" should fail

  Scenario: The prescription status agrees with the item statuses (HIQA EP 3.3)
    Given the HIQA example "Bundle-hiqa-bundle-s10-cancelled.json"
    Then invariant "ie-bnd-rx-10" should pass
    When I "reactivate the cancelled item"
    Then invariant "ie-bnd-rx-10" should fail

  Scenario: The prescriber's facility has a full address (HIQA EP 2.9)
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    When I "remove the facility postcode"
    Then invariant "ie-bnd-rx-11" should fail

  # ── The ePG holds the eDispensations and provenance ──────────────────────

  Scenario: An ePG carries its eDispensations and dispensing provenance
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    Then invariant "ie-bnd-rx-12" should pass
    And invariant "ie-bnd-rx-13" should pass
    And invariant "ie-bnd-rx-14" should pass

  Scenario: An eDispensation in the ePG is authorised by one of its items (HIQA EP 6.5)
    Given the HIQA example "Bundle-hiqa-bundle-s3-repeat.json"
    Then invariant "ie-bnd-rx-12" should pass
    When I "point the dispensation at a prescription outside the ePG"
    Then invariant "ie-bnd-rx-12" should fail

  Scenario: An eDispensation in the ePG is for the ePG's patient
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    When I "make the dispensation for another patient"
    Then invariant "ie-bnd-rx-13" should fail

  Scenario: Provenance in the ePG describes the ePG's resources
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    When I "point the provenance at a resource outside the ePG"
    Then invariant "ie-bnd-rx-14" should fail

  # ── Dosage (HIQA EP Section 5) ────────────────────────────────────────

  Scenario: Sequential dosages are complete and readable
    Given the HIQA example "MedicationStatement-ie-mpd-dosage-ex-sequential-warfarin.json"
    Then every dosage should pass invariant "ie-dos-1"
    And every dosage should pass invariant "ie-dos-2"
    When I "remove the period from every dosage"
    Then a dosage should fail invariant "ie-dos-2"

  Scenario: A structured dosage always has its text (HIQA EP 5.1)
    Given the HIQA example "MedicationStatement-ie-mpd-dosage-ex-concurrent-insulin.json"
    Then every dosage should pass invariant "ie-dos-1"
    When I "remove the text of every dosage"
    Then a dosage should fail invariant "ie-dos-1"

  Scenario: An as-needed dosage states a maximum dose, and a dose range has both ends
    Given the HIQA example "MedicationStatement-ie-mpd-dosage-ex-as-needed-salbutamol.json"
    Then every dosage should pass invariant "ie-dos-3"
    And every dosage should pass invariant "ie-dos-4"
    When I "remove the maximum dose"
    Then a dosage should fail invariant "ie-dos-3"

  Scenario: A dose range without its high end is rejected (HIQA EP 5.2.3.1.2)
    Given the HIQA example "MedicationStatement-ie-mpd-dosage-ex-as-needed-salbutamol.json"
    When I "remove the high end of the dose range"
    Then a dosage should fail invariant "ie-dos-4"

  Scenario: A weekly medicine names its day (HIQA EP 5.2.4.4)
    Given the HIQA example "MedicationStatement-ie-mpd-dosage-ex-weekly-methotrexate.json"
    Then every dosage should pass invariant "ie-dos-2"
