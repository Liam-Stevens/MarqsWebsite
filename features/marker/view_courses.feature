Feature: View Course List
    As a Marker,
    So I can easily navigate between courses while marking,
    I want to see a list of course, which lead to a summary page of all the submissions.

Background:
    Given the database is seeded
    And I am on the login page

Scenario: Assigned to multiple courses
    Given I fill in "id" with "1700001"
    And I press "Login"
    Then I should be on the home page for "1700001"
    And I should see "Test Course"
    And I should see "Reading Intro"
    But I should not see "Hidden Boi"

Scenario: Not assigned to any courses
    Given I fill in "id" with "1700002"
    And I press "Login"
    Then I should be on the home page for "1700002"
    And I should see "You are not assigned to any courses"