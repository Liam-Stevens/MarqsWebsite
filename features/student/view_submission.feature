Feature: View a Submission
    As a Student,
    So that I can see what grade I received for an assignment,
    I want to be able to view my submissions.

Background:
    Given the database is seeded
    And I am on the login page

Scenario: View Grade (whole number)
    When I fill in "id" with "1740021"
    And I press "Login"
    Given I am on the submission page for id "4"
    Then I should see "50/50"

Scenario: View Grade (floating point)
    When I fill in "id" with "1740001"
    And I press "Login"
    Given I am on the submission page for id "1"
    Then I should see "81.2/100"

Scenario: View a submission with comments
    When I fill in "id" with "1740001"
    And I press "Login"
    Given I am on the submission page for id "1"
    Then I should see "This is a comment"
    And I should see "Another sentence of words"

Scenario: View a submission with no comments
    When I fill in "id" with "1740420"
    And I press "Login"
    Given I am on the submission page for id "2"
    Then I should see "No comments have been added to this submission"

Scenario: Can't view any marker buttons
    When I fill in "id" with "1740420"
    And I press "Login"
    Given I am on the submission page for id "1"
    Then I should not see "Add Comment"
    And I should not see "Edit Grade"
    And I should not see "Edit"
    And I should not see "Remove"