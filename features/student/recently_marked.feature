Feature: Recently Marked
    As a Student,
    So I can be alerted to newly marked assignment,
    I want recently marked assignments to be displayed on the homepage.

Background:
    Given the database is seeded
    And I am on the login page

Scenario: No marked assignments
    Given I fill in "id" with "1740420"
    And I press "Login"
    Then I should be on the home page for "1740420"
    And I should not see "Recently Marked"

Scenario: Recently marked assignments (within 7 days) should be shown
    Given I fill in "id" with "1740001"
    And I press "Login"
    Then I should be on the home page for "1740001"
    And I should see "Recently Marked"
    And I should see "Test Assignment 1"

Scenario: Recently marked assignments (outside of last 7 days) should not be shown
    Given I fill in "id" with "1740021"
    And I press "Login"
    Then I should be on the home page for "1740021"
    And I should not see "Recently Marked"
    And I should not see "Test Assignment 2"