Feature: View an Assignment's submissions
    As a Marker,
    So that I can review/amend a student's submission,
    I want to be able to see all submissions for an assignment

Background:
    Given the following markers are in the database
        | marker_id     | first_name    | last_name     |
        | 1700001       | Mark          | Marker        |
    And the following students are in the database
        | student_id    | first_name    | last_name     |
        | 1740420       | Amelia        | Adams         |
        | 1740001       | Banana        | Pyjama        |
    And the following courses are in the database
        | course_id     | eff_date      | short_title   | long_title    | descr         | subject       |
        | 1001          | 20/08/2020    | Test Course   | Test Course   | A test course | TESTSUB       |
    And the following markers are assigned to the courses
        | marker_id     | courses       |
        | 1700001       | 1001          |
    And the following assignments are in the database
        | title         | due_date      | weighting     | max_points    | course_id     |
        | Test 1        | 3/09/2020     | 20            | 90            | 1001          |
        | Test 2        | 10/09/2020    | 20            | 80            | 1001          |
    And the following submissions are in the database
        | assignment_id | grade        | submitted_date | student_id    |
        | 1             | 80           | 12-03-2000     | 1740420       |
        | 1             | 72           | 11-03-2000     | 1740001       |
    And I am on the login page
    And I fill in "id" with "1700001"
    And I press "Login"

Scenario: View assignment with submissions
    Given I am on the submissions page for the assignment "1"
    Then I should see a submission for "1740420"
    And I should see a submission for "1740001"

Scenario: View assignment with no submissions
    Given I am on the submissions page for the assignment "2"
    And I should see "No submissions have been made for this assignment"