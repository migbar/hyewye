Feature: Answer questions
  In order let others know how I feel
  As a user
  I want answer questions
  
  Background:
    Given a question exists with body: "have plastic surgery?"
      And I am logged in
  
  Scenario: Answering the question
    Given I am on the answers page for question "have plastic surgery?"
     When I choose "I have"
      And I fill in "answer_body" with "and I look great!"
      And I press "answer!"
     Then I should be on the answers page for question "have plastic surgery?"
      And I should see "Thanks for answering!"

  Scenario: Answering a question unsuccessfully 
    Given I am on the answers page for question "have plastic surgery?"
     When I choose "I have"
      And I press "answer!" 
     Then I should see "can't be blank"
      But I should not see "Thanks for answering!"
        