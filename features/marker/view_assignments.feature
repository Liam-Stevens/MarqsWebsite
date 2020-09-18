Feature: View Assignment List
    As a Marker,
    So I can easily navigate between assignments while marking,
    I want to see a list of assignments, which lead to a summary page of all the submissions.

Background:
    Given the database is seeded
    And I am on the login page
    And I fill in "id" with "1700001"
    And I press "Login"

Scenario: View course with assignments
    Given I am on the home page for "1700001"
    And I press "View" for the course "Test Course"
    Then I should be on the marker's course page for "1001"
    And I should see "Test Assignment 1"
    And I should see "Test Assignment 2"

Scenario: View course with no assignments
    Given I am on the home page for "1700001"
    And I press "View" for the course "Reading Intro"
    Then I should be on the marker's course page for "1002"
    And I should see "There are no assignments currently available for this course"