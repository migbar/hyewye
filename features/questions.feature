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
  
  Scenario: Requiring question body to be less than 255 characters
    Given I am on the ask question page
     When I fill "Have you ever / Would you ever" with 260 characters
      And I press "ask away!"
     Then I should see "is too long"
@wip
   Scenario: Allowing question body to be 255 characters
     Given I am on the ask question page
      When I fill "Have you ever / Would you ever" with 255 characters
       And I press "ask away!"
      Then I should not see "is too long"
       And I should see "thanks for asking" 