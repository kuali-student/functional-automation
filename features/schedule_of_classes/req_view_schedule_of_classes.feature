@nightly @yellow_team
Feature: CO.View changes made to AO or CO Requisites on Schedule of Classes
  ELIG 8.18 : As a Central Administrator I want to have Rules display in the Schedule of Classes so that students are
  able to see whether or not they will qualify for enrolment in a course prior to trying to enrol

  Background:
    Given I am logged in as admin

  #KSENROLL-9795
  Scenario: ELIG8.18.1 Verify that the Schedule of Classes shows the ref data when no changes are made to the CO Requisites
    Given I have made no changes to the CO Requisites of a course
    And I am using the schedule of classes page
    When I search for course offerings by course
    And I select a course that has existing course offering requisites
    Then the course offering requisites should be displayed with the course data

  #KSENROLL-9795
  Scenario: ELIG8.18.2 Test that adding an AO Requisite will add detail to the SoC AO table
    Given I add a text rule to the Antirequisite section
    And I am using the schedule of classes page
    When I search for course offerings by course
    And I select a course that has existing activity offering level requisites
    Then the activity offering requisites should be displayed with the correct activity

  #KSENROLL-9795
  Scenario: ELIG8.18.3 Test that suppressing the Corequisite rule for AO A is displayed on the Schedule of Classes
    Given I suppress a course offering rule for a specific activity in a course
    And I am using the schedule of classes page
    When I search for course offerings by course
    And I select a course that has existing course offering requisites
    Then the suppressed requisite should not be visible for the changed activity
    But the suppressed requisite should be visible for any unchanged activity
    And any un-suppressed course offering requisites should be visible with the course data

  #KSENROLL-9795
  Scenario: ELIG8.18.4 Test that editing the SE & Prerequisite rule is displayed on the Schedule of Classes
    Given I edit a course offering requisite at the AO level by adding a new text statement
    And I am using the schedule of classes page
    When I search for course offerings by course
    And I select a course that has existing course offering requisites
    Then the edited course offering requisite should be displayed with the affected activity offering
    But the unedited course offering requisite should be displayed with any un-affected activity offerings

  #KSENROLL-9795
  Scenario: ELIG8.18.5 Test that adding CO Requisites is displayed on the Schedule of Classes
    Given I add a new course offering requisite to a course
    And I am using the schedule of classes page
    When I search for course offerings by course
    And I select a course that has existing course offering requisites
    Then the newly added course offering requisite should be displayed with the course data
