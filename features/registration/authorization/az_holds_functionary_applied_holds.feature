@blue_team
Feature: REG.Holds Functionary using Applied Holds
  Hold2.8 As a Holds Functionary I want to be the appropriate Role to expire an applied hold
  Hold2.9 As a Holds Functionary I want to be the appropriate Role to delete an applied hold

#KSENROLL-14598
  @draft
  Scenario: HOLD2.8.1 Validate that a Holds Functionary can expire an applied hold
    Given I am logged in as a Holds Functionary
    And I apply a hold for expiration to a student
    When I expire the hold with an expiration date that is later than the effective date
    Then the expired hold is no longer displayed for the student
  @draft
  Scenario: Hold2.8.2 Validate that a non Holds Functionary can not expire an applied hold
    Given I am logged in as a non Holds Functionary
    And I find a hold
    When I attempt to expire that hold
    Then an expire hold authorization error message is displayed

#KSENROLL-14600
  @draft
  Scenario: HOLD2.9.1 Validate that a Holds Functionary can delete an applied hold
    Given I am logged in as a Holds Functionary
    And I apply a hold for deletion to a student
    When I delete that hold
    Then the deleted hold no longer displays for the student
  @draft
  Scenario: Hold2.9.2 Validate that a non Holds Functionary can not delete an applied hold
    Given I am logged in as a non Holds Functionary
    And I find a hold
    When I attempt to delete that hold
    Then a delete hold authorization error message is displayed


