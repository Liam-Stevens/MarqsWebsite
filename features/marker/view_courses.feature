Feature: View Course List
    As a Marker,
    So I can easily navigate between courses while marking,
    I want to see a list of course, which lead to a summary page of all the submissions.

Background:
    Given the following markers are in the database
        | marker_id     | first_name    | last_name     |
        | 1700669       | John          | Johnson       |
        | 1700420       | First         | Last          |
    And the following courses are in the database
        | course_id     | eff_date      | short_title   | long_title    | descr         | subject       |
        | 1001          | 20/08/2020    | Test Course   | Test Course   | A test course | TESTSUB       |
        | 1002          | 19/08/2020    | Reading       | Reading Stuff | Learn to read | ENG PRI       |
        | 1066          | 21/08/2020    | Writing       | Writing Stuff | Learn to writ | ENG PRI       |
        | 1069          | 21/10/2020    | Hidden Boi    | Hidden Boi    | Can't be seen | HIDDEN        |
    And the following markers are assigned to the courses
        | marker_id     | courses           |
        | 1700669       | 1001, 1002, 1066  |
    And I am on the login page

Scenario: Assigned to multiple courses
    Given I fill in "id" with "1700669"
    And I press "Login"
    Then I should be on the home page for "1700669"
    And I should see "Test Course"
    And I should see "Reading Stuff"
    And I should see "Writing Stuff"
    But I should not see "Hidden Boi"

Scenario: Not assigned to any courses
    Given I fill in "id" with "1700420"
    And I press "Login"
    Then I should be on the home page for "1700420"
    And I should see "You are not assigned to any courses"