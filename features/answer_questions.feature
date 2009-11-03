Feature: Answer questions
  In order let others know how I feel
  As a user
  I want answer questions
  
  Background:
    Given a question exists with body: "have plastic surgery?"
  
  Scenario: Answering the question
    Given I am logged in
      And I am on the answers page for question "have plastic surgery?"
     When I choose "I have"
      And I fill in "answer_body" with "and I look great!"
      And I press "answer!"
     Then I should be on the answers page for question "have plastic surgery?"
      And I should see "Thanks for answering!"

  Scenario: Answering a question unsuccessfully 
    Given I am logged in
      And I am on the answers page for question "have plastic surgery?"
     When I choose "I have"
      And I press "answer!" 
     Then I should see "can't be blank"
      But I should not see "Thanks for answering!"
      
  Scenario: User that is not logged in should log in to answer a question
    Given a user exists with login: "miguel", password: "secret"
      And I am on the answers page for question "have plastic surgery?"
     Then I should not see "My answer"
     When I follow "Log in to answer this question"
      And I fill in "login" with "miguel"
      And I fill in "password" with "secret"
      And I press "Log in"  
     Then I should be on the answers page for question "have plastic surgery?"
      And I should see "My answer"
      But I should not see "Log in to answer this question"



    
        