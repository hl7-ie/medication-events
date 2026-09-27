@hiqa @data-minimisation
Feature: Data minimisation in ePrescription and eDispensation (ADR-002)
  As a data protection officer
  I want ePrescription content to carry only the HIQA EP dataset
  So that special-category and unnecessary personal data are never sent to a pharmacy (GDPR Art. 5(1)(c), Art. 9)

  Background:
    Given the SUSHI compiler has been run successfully

  Scenario Outline: The ePrescription patient profile prohibits <slice>
    Then profile "ie-mpd-patient-eprescription" should prohibit extension slice "<slice>"

    Examples:
      | slice                |
      | ethnicity            |
      | mothersMaidenName    |
      | mothersFormerSurname |
      | patient-nationality  |
      | patient-citizenship  |
      | religion             |
      | birthPlace           |
      | pronouns             |
      | countryOfAffiliation |

  Scenario Outline: The ePrescription patient profile prohibits <element>
    Then profile "ie-mpd-patient-eprescription" should prohibit element "<element>"

    Examples:
      | element     |
      | maritalStatus |
      | photo       |
      | contact     |

  Scenario: No ePrescription example patient carries prohibited demographics
    Given every ePrescription patient in the IG examples
    Then none of them should carry a prohibited demographic extension
    And none of them should have maritalStatus
    And none of them should have contact
    And none of them should have photo

  Scenario: Guard script: no EP/ED example, payload, CDA document or Postman body mentions ethnicity
    When I run the script "scripts/qa/check_ep_data_minimisation.py"
    Then the script should succeed
