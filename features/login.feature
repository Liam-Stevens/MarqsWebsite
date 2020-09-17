Feature: Login
    As a student or marker,
    So that I can view data that is only relevant to me,
    I want to be able to log in with my university credentials.

Background:
    Given the database is seeded
    And I am on the login page

Scenario: Login as student
    When I fill in "id" with "1740001"
    And I press "Login"
    Then I should be on the home page for "1740001"
    And I should see "Courses"

Scenario: Login as marker
    When I fill in "id" with "1700002"
    And I press "Login"
    Then I should be on the home page for "1700002"
    And I should see "Assigned Courses"

Scenario: Submit invalid ID (not found)
    When I fill in "id" with "1234567"
    And I press "Login"
    Then I should be on the login page
    And I should see "Not a valid ID"

Scenario: Submit invalid ID (invalid characters)
    When I fill in "id" with "a123b347"
    And I press "Login"
    Then I should be on the login page
    And I should see "Not a valid ID"

Scenario: Submit blank ID
    When I press "Login"
    Then I should be on the login page
    And I should see "Not a valid ID"