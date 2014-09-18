@blue_team
Feature: REG.Manage Applied Hold
  Hold 2.14 As a Holds Functionary I want the system not to display expired holds if the maintain history is set to false

  Background:
    Given I am logged in as admin

#KSENROLL-14604
  @pending
  Scenario: HOLD2.14.1 Verify that an expired hold, that's not set to maintain history, doesn't display for a student
    Given I applied a hold, that doesn't maintain history, to a student
    And I expire that hold
    Then the hold no longer displayed for the student

#KSENROLL-14604
  @pending
  Scenario: HOLD2.14.2 Verify that an expired hold, that's set to maintain history, displays for a student
    Given I applied a hold, that maintains history, to a student
    And I expire that hold
    Then the expired hold is displayed for the student