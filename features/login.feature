Feature: Login
    As a student or marker,
    So that I can view data that is only relevant to me,
    I want to be able to log in with my university credentials.

Background:
    Given the following students are in the database
        | student_id    | first_name    | last_name    |
        | 1740001       | Bugs          | Bunny        |
        | 1740042       | Yosemite      | Sam          |
    And the following markers are in the database
        | marker_id     | first_name    | last_name    |
        | 1700001       | Linus         | Torvalds     |
        | 1700102       | Bill          | Gates        |
    And I am on the login page

Scenario: Login as student
    When I fill in "id" with "1740001"
    And I press "Login"
    Then I should be on the home page for "1740001"
    And I should see "Courses"

Scenario: Login as marker
    When I fill in "id" with "1700102"
    And I press "Login"
    Then I should be on the home page for "1700102"
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