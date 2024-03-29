@data_setup
Feature: data_setup.Setup Environment

  Setup required data for test run

  Background:
    Given I am logged in as admin

#  @wip
#  Scenario: Set up a term in closed state
#    When I initiate a rollover to create a term in closed state EC
#    Then the results of the rollover are available
#    And the rollover can be released to departments
#    And I approve the "CHEM" subject code for scheduling in the target term
#    And I approve the "ENGL" subject code for scheduling in the target term
#    And I manage SOC for the target term
#    And I Lock the SOC
#    Then I verify that Schedule button is there for next action
#    And I Schedule the SOC
#    Then I verify that FinalEdit button is there for next action
#    And I verify the related object state changes for Schedule action
#    And I FinalEdit the SOC
#    Then I verify that Publish button is there for next action
#    And I Publish the SOC
#    Then I verify that Close button is there for next action
#    And I verify the related object state changes for Publish action

  Scenario: Set up a milestones testing term in published state
    When I initiate a rollover to create a term in published state for milestones testing
    Then the results of the rollover are available
    And the rollover can be released to departments
    And I approve the "CHEM" subject code for scheduling in the target term
    And I approve the "ENGL" subject code for scheduling in the target term
    And I manage SOC for the target term
    And I Lock the SOC
    Then I verify that Schedule button is there for next action
    And I Schedule the SOC
    Then I verify that FinalEdit button is there for next action
    And I verify the related object state changes for Schedule action
    And I FinalEdit the SOC
    Then I verify that Publish button is there for next action
    And I Publish the SOC
    Then I verify that Close button is there for next action
    And I verify the related object state changes for Publish action
    And I verify the exam periods for the milestones test fall and spring terms

  @smoke_test_setup
  Scenario: Set up a term in published state
    When I initiate a rollover to create a term in published state EC
    Then the results of the rollover are available
    And the rollover can be released to departments
    And I approve the "CHEM" subject code for scheduling in the target term
    And I approve the "ENGL" subject code for scheduling in the target term
    And I manage SOC for the target term
    And I Lock the SOC
    Then I verify that Schedule button is there for next action
    And I Schedule the SOC
    Then I verify that FinalEdit button is there for next action
    And I verify the related object state changes for Schedule action
    And I FinalEdit the SOC
    Then I verify that Publish button is there for next action
    And I Publish the SOC
    Then I verify that Close button is there for next action
    And I verify the related object state changes for Publish action
    And I verify the exam periods for the published test fall and spring terms

  Scenario: Set up a term in final edits state
    When I initiate a rollover to create a term in final edits state EC
    Then the results of the rollover are available
    And the rollover can be released to departments
    And I approve the "CHEM" subject code for scheduling in the target term
    And I approve the "ENGL" subject code for scheduling in the target term
    And I manage SOC for the target term
    And I Lock the SOC
    Then I verify that Schedule button is there for next action
    And I Schedule the SOC
    Then I verify that FinalEdit button is there for next action
    And I verify the related object state changes for Schedule action
    And I FinalEdit the SOC
    Then I verify that Publish button is there for next action

  Scenario: Set up a term in locked state
    When I initiate a rollover to create a term in locked state EC
    Then the results of the rollover are available
    And the rollover can be released to departments
    And I approve the "CHEM" subject code for scheduling in the target term
    And I approve the "ENGL" subject code for scheduling in the target term
    And I manage SOC for the target term
    And I Lock the SOC
    Then I verify that Schedule button is there for next action

  Scenario: Set up a term in open state
    When I initiate a rollover to create a term in open state EC
    Then the results of the rollover are available
    And the rollover can be released to departments

  Scenario: Set up a term in draft state
    When I initiate a rollover to create a term in draft state EC
    Then the results of the rollover are available

  Scenario: Set up a term for exam offering creation in open SOC state
    When I set up an academic term for exam offering creation in open SOC state
    Then I can generate 'bulk' exam offerings for the term

  @smoke_test_setup
  Scenario: Set up a term for exam offering creation in published SOC state
    When I set up an academic term for exam offering creation in published SOC state
    Then I can generate 'bulk' exam offerings for the term

  @wip
  Scenario: Run Bulk Creation of Exam Offerings for a term
    When a new academic term has courses found in the CO based exam matrix
    #When an academic term has course offerings with slotted exam offerings
    When I generate 'bulk' exam offerings for the term
    Then the exam offerings are successfully generated