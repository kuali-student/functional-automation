@nightly
Feature: SA.FE3-13 Update Exam Offerings
  FE 3-13 As a Central Admin I want existing exam offerings to be Cancelled if the CO setting changes
  to "No final Exam" or "Alternative final assessment" after bulk creation and after the SoC is published so that exam offerings match CO exam settings

  Background:
    Given I am logged in as admin

#FE3.13.EB1(KSENROLL-9801)
  Scenario: Update Course Offering with Exam Driver to CO and confirm Exam Offering created is in a Cancelled state.
    When I view the Exam Offerings for a CO where the Course Offering Standard FE is changed to No Final Exam
    Then the Exam Offering table should be in a Canceled state

#FE3.13.EB2(KSENROLL-9801)
  Scenario: Update Course Offering with Exam Driver to CO and confirm Exam Offering created in a Draft state
    When I view the Exam Offerings for a CO where the Course Offering No FE is changed to Standard Final Exam
    Then the Exam Offerings for Course Offering should be in a Draft state
