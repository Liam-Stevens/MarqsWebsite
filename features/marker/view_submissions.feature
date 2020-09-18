Feature: View an Assignment's submissions
    As a Marker,
    So that I can review/amend a student's submission,
    I want to be able to see all submissions for an assignment

Background:
    Given the database is seeded
    And I am on the login page
    And I fill in "id" with "1700001"
    And I press "Login"

Scenario: View assignment with submissions
    Given I am on the submissions page for the assignment "1"
    Then I should see a submission for "1740420"
    And I should see a submission for "1740001"