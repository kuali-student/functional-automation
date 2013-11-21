@nightly
Feature: SA.FE7-2 Exclude Non-Active Days for Scheduling of Exam Period
  FE 7.2: As a Central Administrator I want non active days within the exam period configured so that these days are
  not used in the scheduling of the Final Examination as exams are not written on Saturdays or Sundays

  Background:
    Given I am logged in as admin
    And I create an Academic Calender and add an official term

  #FE7.2.EB1 (KSENROLL-9792)
  Scenario: Test whether the exclude non-active day toggles are selected by default
    When I add an Exam Period to the term
    Then the non-active days toggles should be selected by default

  #FE7.2.EB2 (KSENROLL-9792)
  Scenario: Test that when the non-active days are included and saved, that it retains this setting when the term is viewed
    When I choose to include the non-active days in the term's Exam Period
    Then the non-active days should still be included in the Exam Period when I return to view the term