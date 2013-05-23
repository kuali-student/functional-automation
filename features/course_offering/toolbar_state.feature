@nightly
Feature: EC.Toolbar state

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: Validate initial CO toolbar button state for published SOC
    Given I am working on a term in "Published" SOC state
    When I manage course offerings for a subject code
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "disabled"

  Scenario: Validate initial CO toolbar button state for final edits SOC
    Given I am working on a term in "Final Edits" SOC state
    When I manage course offerings for a subject code
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "disabled"

  Scenario: Validate initial CO toolbar button state for locked SOC
    Given I am working on a term in "Locked" SOC state
    When I manage course offerings for a subject code
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "disabled"

  Scenario: Validate initial CO toolbar button state for open SOC
    Given I am working on a term in "Open" SOC state
    When I manage course offerings for a subject code
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "disabled"

  Scenario: Validate initial CO toolbar button state for draft SOC
    Given I am working on a term in "Draft" SOC state
    When I manage course offerings for a subject code
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "disabled"

  Scenario: Validate AO toolbar button for initial state and with AO selected for published SOC
    Given I am working on a term in "Published" SOC state
    And there is an "Offered" course offering present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    And there is a "Draft" course offering present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: Validate AO toolbar button for initial state and with AO selected for final edits SOC
    Given I am working on a term in "Final Edits" SOC state
    And there is a "Planned" course offering present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    And there is a "Draft" course offering present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: Validate AO toolbar button for initial state and with multiple AOs selected and changed AO status for locked SOC
    Given I am working on a term in "Locked" SOC state
    And there is a "Planned" course offering present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    When I manage course offerings for a course with the first activity offering in approved state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select the first activity offering
    When I set the activity offering as draft
    And I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    And I select the second activity offering
    And I deselect the second activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: Validate AO toolbar button for initial state and with multiple AOs selected and changed AO status for open SOC
    Given I am working on a term in "Open" SOC state
    When I manage course offerings for a course with the first activity offering in draft state and the second activity offering in approved state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    When I select the second activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    When I deselect the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    Then I deselect the second activity offering
    When I manage course offerings for a course with the first activity offering in draft state and the second activity offering in draft state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    When I approve the first Activity Offering for scheduling
    And I select the first activity offering
    And I select the second activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    When I deselect the second activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: Validate AO toolbar button for initial state and with multiple AOs selected and changed AO status for draft SOC
    Given I am working on a term in "Draft" SOC state
    And there is a Planned course offering with 2 activity offerings present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    When I approve the first Activity Offering for scheduling
    And I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    When I select the second activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    And there is a Draft course offering with 2 activity offerings present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    When I approve the first Activity Offering for scheduling
    When I select the first activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    And I select the second activity offering
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
