@nightly @blue_team
Feature: REG.AZ Holds Functionary using Applied Holds
  Hold2.8 As a Holds Functionary I want to be the appropriate Role to expire an applied hold
  Hold2.9 As a Holds Functionary I want to be the appropriate Role to delete an applied hold
  Hold2.10 As a Holds Functionary I want to be the appropriate Role to apply a hold to a student

#KSENROLL-14598
  Scenario: HOLD2.8.1 Validate that a Holds Functionary can expire an applied hold
    Given I am logged in as a Holds Functionary
    When I edit a hold to add an expiration date to a student record
    Then the expired hold is no longer displayed for the student

  Scenario: Hold2.8.2 Validate that a non Holds Functionary can not expire an applied hold
    Given I am logged in as a Schedule Coordinator
    And I find a hold
    When I attempt to expire that hold
    Then an expire hold authorization error message is displayed

#KSENROLL-14600
  Scenario: HOLD2.9.1 Validate that a Holds Functionary can delete an applied hold
    Given I am logged in as a Holds Functionary
    When I delete a hold on a student record
    Then the deleted hold no longer displays for the student

  Scenario: Hold2.9.2 Validate that a non Holds Functionary can not delete an applied hold
    Given I am logged in as a Schedule Coordinator
    And I find a hold
    When I attempt to delete that hold
    Then a delete hold authorization error message is displayed

#KSENROLL-14602
  Scenario: HOLD2.10.1 Validate that a Holds Functionary can apply a hold to a student
    Given I am logged in as a Holds Functionary
    When I apply a hold to a student by completing the required information
    Then the hold exists for the student with an effective date

  Scenario: Hold2.10.2 Validate that a non Holds Functionary can not apply a hold to a student
    Given I am logged in as a Schedule Coordinator
    When I attempt to apply a hold to a student
    Then an apply hold authorization error message is displayed