Feature: Course Summary
    As a student,
    So that I can easily view how well I am doing in a course,
    I want to be able to see all of my marks for a course collated on one page.

Background:
    Given the following students are in the database
        | student_id    | first_name    | last_name     |
        | 1740420       | Amelia        | Adams         |
    And the following courses are in the database
        | course_id     | eff_date      | short_title   | long_title    | descr         | subject       |
        | 1001          | 20/08/2020    | Test Course   | Test Course   | A test course | TESTSUB       |
        | 1002          | 19/08/2020    | Reading       | Reading Stuff | Learn to read | ENG PRI       |
        | 1066          | 21/08/2020    | Writing       | Writing Stuff | Learn to writ | ENG PRI       |
        | 1069          | 21/10/2020    | Hidden Boi    | Hidden Boi    | Can't be seen | HIDDEN        |
    And the following assignments are in the database
        | title         | due_date      | weighting     | max_points    | course_id     |
        | Test 1        | 3/09/2020     | 20            | 90            | 1001          |
        | Test 2        | 10/09/2020    | 20            | 80            | 1001          |
        | Read Book 1   | 30/08/2020    | 5             | 5             | 1002          |
    And the following students are assigned to the courses
        | student_id    | courses           |
        | 1740420       | 1001, 1002, 1066  |
    And I am on the login page
    And I fill in "id" with "1740420"
    And I press "Login"

Scenario: View all courses
    Given I am on the home page for "1740420"
    Then I should see "Test Course"
    And I should see "Reading Stuff"
    And I should see "Writing Stuff"
    But I should not see "Hidden Boi"

Scenario: View course with assignments
    Given I am on the home page for "1740420"
    And I press "View" for the course "Test Course"
    Then I should be on the "1001" course page for "1740420"
    And I should see "Test 1"
    And I should see "Test 2"
    But I should not see "Read Book 1"

Scenario: View course with no assignments
    Given I am on the home page for "1740420"
    And I press "View" for the course "Writing Stuff"
    Then I should be on the "1066" course page for "1740420"
    And I should see "There are no assignments currently available for this course"