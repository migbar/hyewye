Feature: Twitter Messaging
  In order to let my twitter friends know about my questions and answers
  As a user
  I want to tweet my HyeWye activity
  
  Background:
    Given I am a logged in as the Twitter user "twitter_guy"
  
  @wip
  Scenario: Tweeting a question
    Given I am on the ask question page
     When I fill in "Have you ever / Would you ever" with "get plastic surgery?"
      And I press "ask away!"
     Then "twitter_guy" should have a tweet
      And the tweet should contain "#hyewye get plastic surgery?"
     When I click the first link in the tweet 
     Then I should be on the answers page for "get plastic surgery?"
  
  @wip
  Scenario: Tweeting an answer
    Given a twitter user "question_guy" exists with screen_name: "question_guy"
      And a question "hps" exists with user: twitter user "question_guy"
      And I navigate to the answers page for question "hps"
     When I choose "I have"
      And I fill in "answer_body" with "and I look great!"
      And I press "answer!"
     Then "twitter_guy" should have a tweet
      And the tweet should contain "@question_guy I Have, and I look great! #hyewye" 
     When I click the first link in the tweet 
     Then I should be at the answers page for question "hps"
  
  