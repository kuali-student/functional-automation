@wip
Feature: BT.Bookmark a course

  Background:

    Given I am logged in as a Student


  Scenario: BK 2.0.1 Verify that I can see a gutter for the bookmarks
    When I navigate to the Planner page
    Then I should see a gutter for bookmarks

  Scenario: BK 2.0.2 Verify that I can see a page to display the bookmarks
   When I bookmark a course
   And  I navigate to the Planner page
   And  I click on View more details link
   Then I should be able to see a page that displays the bookmarks and display the CDP overview section information

  Scenario: BK 2.0.3 Verify that I can access the secondary navigation for bookmarks
    When I navigate to the Planner page
    Then I should be able to view a link to bookmark page in the secondary navigation

