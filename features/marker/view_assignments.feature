Feature: View Assignment List
    As a Marker,
    So I can easily navigate between assignments while marking,
    I want to see a list of assignments, which lead to a summary page of all the submissions.

Background:
    Given the following markers are in the database
        | marker_id     | first_name    | last_name     |
        | 1700111       | Marker        | Mark          |
    And the following courses are in the database
        | course_id     | eff_date      | short_title   | long_title    | descr         | subject       |
        | 1001          | 20/08/2020    | Test Course   | Test Course   | A test course | TESTSUB       |
        | 1002          | 19/08/2020    | Reading       | Reading Stuff | Learn to read | ENG PRI       |
    And the following assignments are in the database
        | title         | due_date      | weighting     | max_points    | course_id     |
        | Test 1        | 3/09/2020     | 20            | 90            | 1001          |
        | Test 2        | 10/09/2020    | 20            | 80            | 1001          |
    And the following markers are assigned to the courses
        | marker_id     | courses       |
        | 1700111       | 1001, 1002    |
    And I am on the login page
    And I fill in "id" with "1700111"
    And I press "Login"

Scenario: View course with assignments
    Given I am on the home page for "1700111"
    And I press "View" for the course "Test Course"
    Then I should be on the marker's course page for "1001"
    And I should see "Test 1"
    And I should see "Test 2"

Scenario: View course with no assignments
    Given I am on the home page for "1700111"
    And I press "View" for the course "Reading Stuff"
    Then I should be on the marker's course page for "1002"
    And I should see "There are no assignments currently available for this course"