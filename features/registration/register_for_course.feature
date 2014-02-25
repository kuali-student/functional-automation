@nightly @red_team
Feature: REG.Register for course

  As a student, I want to be able to add courses to my registration cart, including specifying
  course options where applicable. I also want to be able to edit and delete courses in my
  registration cart.

  Background:
    Given I am logged in as a Student

  #CR 1.1 (KSENROLL-11747)  CR 1.3 (KSENROLL-11812)
  Scenario: I want to enter course information into my list of selections so that I can indicate what I want to register for.
    When I add a CHEM course offering to my registration cart
    Then the course is present in my cart
    And I can view the details of my selection

  #CR 1.2 (KSENROLL-11748)
  Scenario: I want to indicate course parameters at the time I enter course information so I can register with my preferred options
    When I add a course to my registration cart and specify course options
    Then the course is present in my cart, with the correct options

  #CR 1.4 (KSENROLL-11809)
  Scenario: I want to remove a course from my selections because I dont want to register for it anymore
    When I add an ENGL course offering to my registration cart
    And I drop the course from my registration cart
    Then the course is not present in my cart

  #CR 1.5 (KSENROLL-11810)
  Scenario: I want to change the course parameters for my selections so I can register with preferred options
    When I add a course offering having multiple credit options to my registration cart
    And I edit the course in my registration cart
    Then the course is present in my cart, with the correct options

  #CR 1.9 (KSENROLL-11922)
  Scenario: I want my course selections to persist so that I can return in another session and continue my registration process.
    When I add a PHYS course offering to my registration cart
    Then the course is present in my cart
    And I log out
    When I am logged in as a Student
    And I view my registration cart
    Then the course is present in my cart

  #CR 1.10 (KSENROLL-11923)
  Scenario: I want to reverse my decision to remove a course from my selections so that I can continue my registration process.
    When I add a BSCI course offering to my registration cart
    And I drop the course from my registration cart
    Then the course is not present in my cart
    Then I undo the drop action
    And the course is present in my cart
