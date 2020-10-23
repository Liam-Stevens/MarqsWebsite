Feature: Edit Submission Grade
    As a marker,
    So that I can fix any wrong grades on a submission,
    I want to be able to edit the assigned grade.

Background:
    Given the database is seeded
    And I am on the login page
    And I fill in "id" with "1700001"
    And I press "Login"
    And I am on the edit grade page for submission "1"

Scenario: Valid grade
    When I fill in "submission_grade" with "42"
    And I press "Update Grade"
    Then I should be on the submission page for id "1"
    And I should see "1740001's submission was updated"
    And I should see "42/100"

Scenario: Blank grade
    When I fill in "submission_grade" with ""
    And I press "Update Grade"
    Then I should be on the edit grade page for submission "1"
    And I should see "Can't set a blank grade"

Scenario: Negative grade
    When I fill in "submission_grade" with "-1"
    And I press "Update Grade"
    Then I should be on the edit grade page for submission "1"
    And I should see "grade must be a non-negative number"

Scenario: Grade larger than maximum
    When I fill in "submission_grade" with "99999999"
    And I press "Update Grade"
    Then I should be on the edit grade page for submission "1"
    And I should see "1740001's grade can't be greater than max points: 100"
