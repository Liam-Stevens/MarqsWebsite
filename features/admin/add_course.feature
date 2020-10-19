Feature: Add Course
    As an Admin,
    So that I can easily add new courses to the system,
    I want to be able to add a course's information to the system.

Background:
    Given the database is seeded
    And I am on the login page
    And I fill in "id" with "1000000"
    And I press "Login"
    And I am on the admin page

Scenario: Add course with conflicting ID
    Given I press "Add" for "Courses"
    And I fill in "Full Title" with "long title"
    And I fill in "Short Title" with "short"
    And I fill in "Subject Type" with "SUB"
    And I fill in "Course ID" with "1001"
    And I fill in "Effective Date" with "01/01/2020"
    And I fill in "Description" with "desc"
    And I press "Add Course"
    Then I should see "Course already exists"