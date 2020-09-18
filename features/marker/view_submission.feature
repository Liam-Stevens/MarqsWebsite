Feature: View a Submission
    As a marker,
    So that I can ensure a submission is marked correctly,
    I want to be able to view a submission.

Background:
    Given the database is seeded
    And I am on the login page
    And I fill in "id" with "1700001"
    And I press "Login"
    And I am on the submissions page for the assignment "1"

Scenario: View submission with comments
    Given I press "Details" for the submission by "1740001"
    Then I should be on the submission page for id "1"
    And I should see "This is a comment"
    And I should see "Another sentence of words"

Scenario: View submission with no comments
    Given I press "Details" for the submission by "1740420"
    Then I should be on the submission page for id "2"
    And I should see "No comments have been added to this submission"
