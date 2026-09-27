@hiqa @hiqa-eprescription
Feature: HIQA Draft National Standard for ePrescriptions and eDispensations (Sept 2026)
  As an implementer of IE Core
  I want the ePrescription profiles to enforce the HIQA EP rules
  So that a non-conformant prescription or dispense is rejected before it reaches a patient

  The invariants are read from the generated StructureDefinitions and evaluated with fhirpath.js.
  Each negative scenario changes a copy of a valid HIQA scenario example so it breaks exactly one rule.

  Background:
    Given the SUSHI compiler has been run successfully

  # ── The six ePrescription scenario Bundles are valid ────────────────
  @hiqa-scenarios
  Scenario Outline: <scenario> passes the prescription-level rules
    Given the HIQA example "<bundle>"
    Then the Bundle should claim profile "<profile>"
    And invariant "ie-bnd-rx-1" should pass
    And invariant "ie-bnd-rx-2" should pass
    And invariant "ie-bnd-rx-3" should pass
    And invariant "ie-bnd-rx-4" should pass
    And the entry for the List should pass invariant "ie-list-allergy-1"

    Examples:
      | scenario                     | bundle                                     | profile                                  |
      | 1 acute adult                | Bundle-hiqa-bundle-s1-acute-adult.json     | ie-mpd-bundle-eprescription             |
      | 2 paediatric under 12        | Bundle-hiqa-bundle-s2-paediatric.json      | ie-mpd-bundle-eprescription             |
      | 3 repeat                     | Bundle-hiqa-bundle-s3-repeat.json          | ie-mpd-bundle-eprescription             |
      | 4 controlled drug            | Bundle-hiqa-bundle-s4-controlled-drug.json | ie-mpd-bundle-eprescription             |
      | 5 later declined             | Bundle-hiqa-bundle-s5-non-dispensation.json | ie-mpd-bundle-eprescription            |
      | 6 cross-border with signature | Bundle-hiqa-bundle-s6-crossborder.json    | ie-mpd-bundle-eprescription-crossborder |

  # ── EP 1.6.1 / 1.6.2 allergy statement ──────────────────────────────
  @allergy-statement
  Scenario: Every prescription item must reference the allergy statement
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    When I "remove the allergy statement reference from every item"
    Then invariant "ie-bnd-rx-2" should fail

  @allergy-statement
  Scenario Outline: The allergy statement must be the patient's own and complete (<change>)
    Given the HIQA example "Bundle-hiqa-bundle-s3-repeat.json"
    Then invariant "<invariant>" should pass
    When I "<change>"
    Then invariant "<invariant>" should fail

    Examples:
      | change                                         | invariant   |
      | point the allergy statement at another patient | ie-bnd-rx-5 |
      | change the allergy statement code              | ie-bnd-rx-2 |
      | drop the listed allergy from the Bundle        | ie-bnd-rx-6 |

  @allergy-statement
  Scenario: An allergy recorded in error can be retracted without a clinical status
    Given the HIQA example "AllergyIntolerance-hiqa-allergy-niamh-penicillin.json"
    Then invariant "ie-allergy-1" should pass
    When I "remove the clinical status"
    Then invariant "ie-allergy-1" should fail
    Given the HIQA example "AllergyIntolerance-hiqa-allergy-niamh-penicillin.json"
    When I "mark it entered in error without a clinical status"
    Then invariant "ie-allergy-1" should pass

  @allergy-statement
  Scenario: An allergy statement must list allergies or say why none are recorded
    Given the HIQA example "List-hiqa-allergies-tomas-nilknown.json"
    Then invariant "ie-list-allergy-1" should pass
    When I "remove the empty reason"
    Then invariant "ie-list-allergy-1" should fail

  # ── EP 1.4.2 age of a child under 12 (legal requirement) ────────────
  @paediatric
  Scenario: The paediatric prescription records the age in UCUM years
    Given the HIQA example "Bundle-hiqa-bundle-s2-paediatric.json"
    Then every prescription item should record the age 5 "a"

  @paediatric
  Scenario: A prescription for a child under 12 without the age is rejected
    Given the HIQA example "Bundle-hiqa-bundle-s2-paediatric.json"
    When I "remove the age at prescribing from every item"
    Then invariant "ie-bnd-rx-3" should fail

  @paediatric
  Scenario: A partial date of birth cannot prove the patient is 12 or over, so the age is required
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    When I "give the patient a year-only date of birth"
    Then invariant "ie-bnd-rx-3" should fail

  @paediatric
  Scenario: An adult prescription does not need the age
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    When I "remove the age at prescribing from every item"
    Then invariant "ie-bnd-rx-3" should pass

  # ── EP 3.1 group identifier, EP 2.10 prescriber telephone ───────────
  Scenario: The items of a multi-item prescription share one group identifier
    Given the HIQA example "Bundle-hiqa-bundle-s6-crossborder.json"
    When I "give the second item a different group identifier"
    Then invariant "ie-bnd-rx-1" should fail

  Scenario: The prescriber or facility must have a telephone number
    Given the HIQA example "Bundle-hiqa-bundle-s1-acute-adult.json"
    When I "remove every telephone number"
    Then invariant "ie-bnd-rx-4" should fail

  Scenario: Another party's telephone number does not satisfy the prescriber rule
    Given the HIQA example "Bundle-hiqa-bundle-s3-repeat.json"
    When I "remove the prescriber telephone numbers but keep the patient phone"
    Then invariant "ie-bnd-rx-4" should fail

  # ── EP 3.5.2, 3.5.10, 5.1 item rules ────────────────────────────────
  Scenario: An inactive prescription item needs a status reason
    Given the HIQA example "MedicationRequest-hiqa-rx-s1-amoxicillin.json"
    Then invariant "ie-rx-status-1" should pass
    When I "set the status to on-hold without a reason"
    Then invariant "ie-rx-status-1" should fail

  Scenario: 'Do Not Substitute' needs a reason
    Given the HIQA example "MedicationRequest-hiqa-rx-s4-oxycodone.json"
    Then invariant "ie-rx-subst-1" should pass
    When I "remove the reason for not allowing substitution"
    Then invariant "ie-rx-subst-1" should fail

  Scenario: A structured dosage needs a human-readable text
    Given the HIQA example "MedicationRequest-hiqa-rx-s1-amoxicillin.json"
    Then invariant "ie-rx-dosage-1" should pass
    When I "remove the dosage text"
    Then invariant "ie-rx-dosage-1" should fail

  # ── EP 3.5.7.2, 3.5.9.1, 3.5.12 controlled drugs (MDA Regulations 2017) ──
  @controlled-drug
  Scenario: The controlled-drug example is a Schedule 2 medicine and meets the legal rules
    Given the HIQA example "Medication-hiqa-med-oxycodone-10-pr.json"
    Then the medication should be classified "schedule-2" in "ie-mpd-mda-schedule"
    Given the HIQA example "MedicationRequest-hiqa-rx-s4-oxycodone.json"
    Then invariant "ie-rx-cd-1" should pass
    And invariant "ie-rx-cd-2" should pass
    And invariant "ie-rx-cd-3" should pass

  @controlled-drug
  Scenario Outline: A Schedule 2 prescription that breaks a legal rule is rejected (<change>)
    Given the HIQA example "MedicationRequest-hiqa-rx-s4-oxycodone.json"
    When I "<change>"
    Then invariant "<invariant>" should fail

    Examples:
      | change                                    | invariant  |
      | remove the quantity in words and figures  | ie-rx-cd-1 |
      | remove the number of instalments          | ie-rx-cd-3 |
      | remove the dispense interval              | ie-rx-cd-3 |
      | extend the validity period to three months | ie-rx-cd-2 |

  @controlled-drug
  Scenario: An instalment prescription may run to two months (final instalment); a single supply only 14 days
    Given the HIQA example "MedicationRequest-hiqa-rx-s4-oxycodone.json"
    When I "extend the validity period to 30 days"
    Then invariant "ie-rx-cd-2" should pass
    When I "remove the number of instalments"
    Then invariant "ie-rx-cd-2" should fail

  @controlled-drug
  Scenario: The controlled-drug rules do not apply to other medicines
    Given the HIQA example "MedicationRequest-hiqa-rx-s1-amoxicillin.json"
    Then invariant "ie-rx-cd-1" should pass
    And invariant "ie-rx-cd-2" should pass

  # ── EP 3.5.11 repeats and EP 6 dispensing ───────────────────────────
  @repeat
  Scenario: Repeats dispensed are derived from the dispense records
    Then the dispenses of "hiqa-rx-s3-salbutamol-repeat" should total 4 "{inhaler}" with 1 repeat used of 5 allowed

  @dispense
  Scenario: A completed dispense records when it was handed over
    Given the HIQA example "MedicationDispense-hiqa-md-s1-amoxicillin.json"
    Then invariant "ie-md-handover-1" should pass
    When I "remove the hand-over time"
    Then invariant "ie-md-handover-1" should fail

  @dispense @non-dispensation
  Scenario: A non-dispensation states its reason
    Given the HIQA example "MedicationDispense-hiqa-md-s5-declined.json"
    Then the dispense should be a non-dispensation with status "declined" and quantity 0
    And invariant "ie-md-status-1" should pass
    When I "remove the dispense status reason"
    Then invariant "ie-md-status-1" should fail

  # ── EP 2.10.2 and 2.13 cross-border ─────────────────────────────────
  @crossborder
  Scenario: A cross-border prescription has a secure email and a signature over every item
    Given the HIQA example "Bundle-hiqa-bundle-s6-crossborder.json"
    Then invariant "ie-bnd-xb-1" should pass
    And invariant "ie-bnd-xb-2" should pass

  @crossborder
  Scenario Outline: A cross-border prescription that breaks a legal rule is rejected (<change>)
    Given the HIQA example "Bundle-hiqa-bundle-s6-crossborder.json"
    When I "<change>"
    Then invariant "<invariant>" should fail

    Examples:
      | change                                         | invariant   |
      | remove every email address                     | ie-bnd-xb-1 |
      | make the signature cover only the first item   | ie-bnd-xb-2 |

  # ── Traceability: every HIQA EP element is mapped ───────────────────
  @traceability
  Scenario: The HIQA traceability matrix and logical models are up to date
    When I run the script "scripts/hiqa/generate_traceability.py --check"
    Then the script should succeed

  @traceability
  Scenario: Every mapping claim agrees with the generated profiles
    When I run the script "scripts/hiqa/check_mapping_against_snapshots.py"
    Then the script should succeed
