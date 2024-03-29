@nightly @yellow_team
Feature: CO.Exam Offering RSI Inline Edit

  FE 6.1: As a Central Administrator I want to update the requested scheduling information for exam offerings driven by Course Offerings

  FE 6.2:  As a Central Adminisrator I want to update the requested scheduling information for exam offerings driven by activity offerings

  FE 6.3: As a Central Administrator I want to update the requested scheduling information for AO driven exam offerings with a
  scheduling state of Matrix Error so that AOs with non standard times will have exam offerings with RSI

  FE 6.4: As a Central Administrator I want the system to enforce appropriate authorization to add or change RSI information for exam offerings

  FE 6.6: As a Central Administrator I want to add location to an AO driven Exam Offering if the matrix is not configured to copy location
  from the driver AO so that the preferred examination site is sent to the scheduler

  FE 6.7: As a Central Administrator I want to override the day and time of an exam slotted by the matrix so that scheduling data
  that is preferred to that derived from the matrix is sent to the scheduler

  FE 6.8: As a Central Administrator I want to add a location to the requested scheduling information of an on matrix CO driven exam offering
  if the location is not part of the matrix so that the preferred examination site is sent to the scheduler

  FE 6.9: As a Central Administrator I want to resend an on matrix CO Driven exam offering to the matrix slotting process so that
  I can correct exam override errors

  FE 6.10: As a Central Administrator I want to resend an on matrix AO Driven exam offering to the matrix slotting process so that
  I can correct exam override errors

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: FE 6.1.1 Verify that the matrix override option is not present for a course not using the exam matrix
    Given I manage CO-driven exam offerings for a course offering configured not to use the exam matrix
    Then the Override Matrix option should not be present

  Scenario: FE 6.1.2 Verify successful Exam Offering RSI inline edit for a CO-driven Exam Offering not using the exam matrix
    Given I manage CO-driven exam offerings for a course offering configured not to use the exam matrix
    And I update the available fields on the exam offering RSI
    Then the CO-driven exam offering RSI is successfully updated

  Scenario: FE 6.1.3 Verify Exam Offering RSI edit error message for invalid start time
    Given I manage a CO-driven exam offering
    When I enter an invalid time in the exam offering RSI start time field
    Then the error displayed for CO-driven exam offerings RSI is that the start time is invalid
    And the CO-driven exam offering RSI is not updated

  Scenario: FE 6.2.1 Verify successful Exam Offering RSI inline edit for an AO-driven Exam Offering not using the exam matrix
    Given I manage AO-driven exam offerings for a course offering configured not to use the exam matrix
    And I update the available fields on the exam offering RSI
    Then the AO-driven exam offering RSI is successfully updated

  Scenario: FE 6.2.2 Verify Exam Offering RSI edit error message for invalid (blank) day
    Given I manage an AO-driven exam offering
    When I leave exam offering RSI Day field blank
    Then the error displayed for AO-driven exam offerings RSI day field is required
    And the AO-driven exam offering RSI is not updated

  Scenario: FE 6.2.3 Verify Exam Offering RSI edit error message for invalid end time
    Given I manage an AO-driven exam offering
    When I enter a blank time in the exam offering RSI end time field
    Then the error displayed for AO-driven exam offerings RSI end time is required
    And the AO-driven exam offering RSI is not updated

  Scenario: FE 6.2.4 Verify Exam Offering RSI edit error message for invalid facility
    Given I manage an AO-driven exam offering
    When I enter an invalid facility code in the exam offering RSI facility field
    Then the error displayed for AO-driven exam offerings RSI facility is: Building code is invalid
    And the AO-driven exam offering RSI is not updated

  Scenario: FE 6.2.5 Verify Exam Offering RSI edit error message for invalid room
    Given I manage an AO-driven exam offering
    When enter an invalid room code in the exam offering RSI room field
    Then the error displayed for AO-driven exam offerings RSI room is: Room code is invalid
    And the AO-driven exam offering RSI is not updated

  Scenario: FE 6.3.1 Verify successful Exam Offering RSI inline edit using override for an on-matrix AO-driven Exam Offering
    Given I manage an AO-driven exam offering with RSI generated from the exam matrix
    When I select exam matrix override and update the available fields on the exam offering RSI
    And I update the available fields on the exam offering RSI
    Then the AO-driven exam offering RSI is successfully updated

    @bug @KSENROLL-13974
  Scenario: FE 6.3.2 Confirm that matrix error scheduling state updated to unscheduled when manually changing EO RSI
    Given I manage a course offering with an on-matrix CO-driven exam offering with no match on the matrix
    And the CO RSI is blank and the scheduling state is matrix error
    When I select exam matrix override and update the available fields on the exam offering RSI
    Then the CO-driven exam offering RSI is successfully updated
    And the CO-driven EO RSI scheduling state is Unscheduled

  Scenario: FE 6.3.3 Confirm that matrix error scheduling state updated to unscheduled when changing AO RSI to something that matches the matrix
    Given I manage a course offering with an on-matrix AO-driven exam offering with no match on the matrix
    And the AO RSI is blank and the scheduling state is matrix error
    When I change the driving AO RSI to match an entry on the final exam matrix
    Then the AO-driven exam offering RSI is successfully updated
    And the AO-driven EO RSI scheduling state is Unscheduled

  Scenario: FE 6.3.4 Confirm that unscheduled scheduling state updated to matrix error when manually changing EO RSI
    Given I manage an AO-driven exam offering with RSI generated from the exam matrix
    And the AO-driven EO RSI scheduling state is Unscheduled
    When I change the driving AO RSI so it no longer matches an entry on the exam matrix
    Then the AO RSI is blank and the scheduling state is matrix error

  Scenario: FE 6.4.1 DSC (Carol) has read-only permission on Manage Exam Offerings page
    Given there is an AO-driven exam offering for a course offering in Carol's admin org
    When I am logged in as a Department Schedule Coordinator (Carol)
    And I manage an AO-driven exam offering for a course offering in my admin org
    Then I am not able to edit the AO-driven exam offering RSI

  Scenario: FE 6.5.1 FE 6.6.1 Successfully override facility and room information for an AO-driven Exam Offering RSI
    Given I manage an AO-driven exam offering with RSI generated from the exam matrix
    When I select override matrix and update the location fields on the exam offering RSI
    Then the AO-driven exam offering RSI is successfully updated

  Scenario: FE 6.5.2 Verify that Exam Offering RSI facility and room fields can be set to blank
    Given I manage a CO-driven exam offering with RSI generated from the exam matrix
    When I select override matrix and delete the contents of the exam offering RSI facility and room number fields
    Then the CO-driven exam offering RSI is successfully updated

  Scenario: FE 6.7.1 FE 6.3.2 Successfully override day and time information for an AO-driven Exam Offering RSI
    Given I manage an AO-driven exam offering with RSI generated from the exam matrix
    When I select matrix override and update the day and time fields on the exam offering RSI
    Then the AO-driven exam offering RSI is successfully updated

  Scenario: FE 6.7.2 AO-driven verify that when the matrix override option is selected then updates to the activity offering RSI do not change the EO RSI
    Given I manage an AO-driven exam offering with RSI generated from the exam matrix
    When I select matrix override and update the day and time fields on the exam offering RSI
    And I update the requested scheduling information for the related activity offering so there is no match on the exam matrix
    Then the AO-driven exam offering RSI is not updated

  Scenario: FE 6.7.3 AO-driven verify that when the matrix override option is selected then updates to the AO ASI do not change the EO RSI
    Given I manage an AO-driven exam offering with RSI generated from the exam matrix in a term in "Published" SOC state
    And I select matrix override and update the day and time fields on the exam offering RSI
    When I update the scheduling information for the related activity offering and send to the scheduler
    Then the AO-driven exam offering RSI is not updated

  Scenario: FE 6.8.1 Successfully add facility and room information to a CO-driven Exam Offering RSI when exam matrix facility and room info is blank
    Given I manage a course offering with a CO-driven exam offering with RSI generated from the exam matrix where facility and room info are blank
    When I manage the Exam Offerings for the Course Offering
    When I select matrix override and add facility and room information to the exam offering RSI
    Then the CO-driven exam offering RSI is successfully updated

  Scenario: FE 6.9.1 Verify that when the matrix override option removed then the CO driven EO RSI updates to the exam matrix value
    Given I manage a CO-driven exam offering with RSI generated from the exam matrix
    And I select matrix override and update the day and time fields on the exam offering RSI
    When I subsequently remove matrix override from the CO driven exam offering RSI
    Then the CO-driven exam offering RSI is updated according to the exam matrix

  Scenario: FE 6.9.2 Verify successful Exam Offering RSI inline edit using override for an on-matrix CO-driven Exam Offering
    Given I manage a CO-driven exam offering with RSI generated from the exam matrix
    When I select exam matrix override and update the available fields on the exam offering RSI
    Then the CO-driven exam offering RSI is successfully updated

  Scenario: FE 6.10.1 Verify that when the matrix override option removed then the AO driven EO RSI updates to the exam matrix value
    Given I manage an AO-driven exam offering with RSI generated from the exam matrix
    And I select matrix override and update the day and time fields on the exam offering RSI
    When I subsequently remove matrix override from the AO-driven exam offering RSI
    Then the AO-driven exam offering RSI is updated according to the exam matrix