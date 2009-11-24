Feature: Managing Questions
  In order to find out what others think
  As a user
  I want ask questions
  
  Background:
    Given I am logged in

  Scenario: Creating a question successfully
    Given I am on the site index
     When I follow "ask a question"
     Then I should be on the ask question page
     When I fill in "Have you ever / Would you ever" with "get plastic surgery?" 
      And I press "ask away!"
     Then I should see "thanks for asking"
      And I should be on the home page 
  
  Scenario: Requiring question body to be less than 140 characters
    Given I am on the ask question page
     When I fill "Have you ever / Would you ever" with 150 characters
      And I press "ask away!"
     Then I should see "is too long"
