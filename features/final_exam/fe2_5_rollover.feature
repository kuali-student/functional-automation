@nightly @yellow_team
Feature: CO.FE2-5 Perform Simple Rollover
  FE 2.5: As a Central Administrator I want exam information to be copied in a rollover so that exam settings
  are retained session over session until modified

  Background:
    Given I am logged in as admin

  #FE2.5.EB1 (KSENROLL-9532)
  Scenario: Test whether setting up exam offerings for COs and then performing a rollover retains the exam information
    Given I create an Academic Calendar and add an official term
    And I add an Exam Period to the new term
    When I have multiple Course Offerings each with a different Exam Offering in the source term
    And I rollover the source term to a new academic term with an exam period
    And I generate 'bulk' exam offerings for the term
    Then all the exam settings and messages are retained after the rollover is completed for the courses that were rolled over
