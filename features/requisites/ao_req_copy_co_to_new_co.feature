@nightly @yellow_team
Feature: CO.Copy CO with AO Requisites to new CO

  Background:
    Given I am logged in as a Schedule Coordinator

  #KSENROLL-8917
  Scenario: ELIG8.10.1 Test that changes made on the AO level is also copied with CO to the new term
    Given I have made changes to multiple AO Requisites for the same course offering
    When I copy a course offering from an existing offering that had changes made to its activity offerings
    Then both Activity Offerings should have the AR icon present
    And the copied course offering should have the same AO Requisites as the original
