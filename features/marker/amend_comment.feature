Feature: Amend a Submission's Comment
    As a marker,
    So that I can ensure students receive useful feedback,
    I want to be able to add and amend comments on a submission.

Background:
    Given the database is seeded
    And I am on the login page
    And I fill in "id" with "1700001"
    And I press "Login"
    And I am on the submission page for id "1"

Scenario: Add a valid comment
    Given I follow "Add Comment"
    Then I should be on the add comment page for submission "1"
    When I fill in "content" with "This is valid"
    And I press "Add Comment"
    Then I should be on the submission page for id "1"
    And I should see "This is valid"

Scenario: Add a blank comment
    Given I follow "Add Comment"
    Then I should be on the add comment page for submission "1"
    When I fill in "content" with ""
    And I press "Add Comment"
    Then I should be on the add comment page for submission "1"
    And I should see "Can't add a blank comment"

Scenario: Update a comment
    Given I follow "Edit" for comment "This is a comment"
    Then I should be on the edit comment page for "1"
    When I fill in "content" with "This has been updated"
    And I press "Apply Edit"
    Then I should be on the submission page for id "1"
    And I should see "Comment updated."
    And I should see "This has been updated"

Scenario: Update a comment to blank
    Given I follow "Edit" for comment "This is a comment"
    Then I should be on the edit comment page for "1"
    When I fill in "content" with ""
    And I press "Apply Edit"
    Then I should be on the edit comment page for "1"
    And I should see "Can't set a blank comment"