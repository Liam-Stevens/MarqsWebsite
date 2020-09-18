Feature: Course Summary
    As a student,
    So that I can easily view how well I am doing in a course,
    I want to be able to see all of my marks for a course collated on one page.

Background:
    Given the database is seeded
    And I am on the login page

Scenario: View all courses
    Given I fill in "id" with "1740001"
    And I press "Login"
    Then I should be on the home page for "1740001"
    And I should see "Test Course"
    And I should see "Reading Intro"
    But I should not see "Hidden Boi"

Scenario: No courses available
    Given I fill in "id" with "1740420"
    And I press "Login"
    Then I should be on the home page for "1740420"
    And I should see "You are not assigned to any courses"

Scenario: View course with assignments
    Given I fill in "id" with "1740001"
    And I press "Login"
    Then I should be on the home page for "1740001"
    And I press "View" for the course "Test Course"
    Then I should be on the course page for "1001"
    And I should see "Test Assignment 1"
    And I should see "Test Assignment 2"
    But I should not see "Read Book 1"

Scenario: View course with no assignments
    Given I fill in "id" with "1740001"
    And I press "Login"
    Then I should be on the home page for "1740001"
    And I press "View" for the course "Reading Intro"
    Then I should be on the course page for "1002"
    And I should see "There are no assignments currently available for this course"