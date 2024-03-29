@wip @red_team
Feature: REG.Registration proof of concept

  As a student, I want to be able to search for a course from the Schedule of Classes.
  The search results list should display properly depending on screen size.
  Clicking on one of the courses should bring up a detail of that course.

  @wip
  Scenario: Display course search results and detail info in mobile mode
    Given I am using a mobile screen size
    And I am logged into the POC site as admin
    When I search for course offerings by using a custom course offering code
    Then the course search results are displayed in mobile format
    When I select a course offering from the search results
    Then the course detail is displayed in mobile format
  @wip
  Scenario: Display course search results and detail info in tablet mode
    Given I am using a tablet screen size
    And I am logged into the POC site as admin
    When I search for course offerings by using a custom course offering code
    Then the course search results are displayed in tablet format
    When I select a course offering from the search results
    Then the course detail is displayed in tablet format
