Feature: Managing Questions
  In order to find out what others think
  As a user
  I want ask questions

  Scenario: Creating a question
    Given I am logged in
     When I follow "ask a question"
      And I fill in "Have you ever / Would you ever" with "get plastic surgery?" 
      And I press "ask away!"
     Then I should see "thanks for asking"
      And I should be on the home page 
  
  



  
