Feature: Answer questions
  In order let others know how I feel
  As a user
  I want answer questions
  
  Background:
    Given a question "hps" exists
  
  Scenario: Answering the question
    Given I am logged in
      And I navigate to the answers page for question "hps"
     When I choose "I have"
      And I fill in "answer_body" with "and I look great!"
      And I press "answer!"
     Then I should be at the answers page for question "hps"
      And I should see "Thanks for answering!" 

  Scenario: Answering a question unsuccessfully 
    Given I am logged in
      And I navigate to the answers page for question "hps"
     When I choose "I have"
      And I press "answer!" 
     Then I should see "can't be blank"
      But I should not see "Thanks for answering!"
      
  Scenario: Requiring an answer body to be less than 255 characters
    Given I am logged in
      And I navigate to the answers page for question "hps"
     When I choose "I have"
     When I fill "answer_body" with 260 characters
      And I press "answer!"
     Then I should see "is too long"
     
  Scenario: Allowing an answer body to be 255 characters
    Given I am logged in
      And I navigate to the answers page for question "hps"
     When I choose "I have"
     When I fill "answer_body" with 255 characters
      And I press "answer!"
     Then I should not see "is too long"
      And I should see "Thanks for answering!"
      
  Scenario: User that is not logged in should log in to answer a question
    Given a user exists with login: "miguel", password: "secret"
      And I navigate to the answers page for question "hps"
     Then I should not see "My answer"
     When I follow "Let me Answer!"
      And I fill in "login" with "miguel"
      And I fill in "password" with "secret"
      And I press "Login"
     Then I should be at the answers page for question "hps"
      And I should see "My answer"
      But I should not see "Log in to answer this question"
      
  Scenario: a registered twitter user that is not logged in can log in with twitter to answer a question
    Given a Twitter user "twitter_guy" registered with HyeWye
      And I navigate to the answers page for question "hps"
     Then I should not see "My answer" 
     When I follow "Let me Answer!"
      And I press "Let me log in using Twitter" 
     Then I should be at the answers page for question "hps"
      And I should see "My answer"
      But I should not see "Log in to answer this question"            
      
      



    
        