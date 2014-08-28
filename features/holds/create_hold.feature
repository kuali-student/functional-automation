@nightly @blue_team
Feature: Holds.Manage Hold
  Hold 1.1 As an admin I want to create the general information for a hold so that the hold can be added to the catalog of holds

  Background:
    Given I am logged in as admin

  #KSENROLL-14522
  @Draft
  Scenario: Hold 1.1.1 Verify that a hold is created and added to the catalog of holds
    When I create a hold by completing the required information needed
    Then a message indicating that the hold has been successfully created is displayed
    And the hold exists in the hold catalog

  @Draft
  Scenario: Hold 1.1.2 Verify that a duplicate check message is displayed when creating a duplicate hold entry
    When I attempt to create a duplicate hold entry
    Then a duplicate check message is displayed
    And the hold does not exist in the hold catalog
