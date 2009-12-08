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
     Then "twitter_user" should have a tweet
      And the tweet should contain "get plastic surgery?"
     When I click the first link in the tweet 
     Then I should be on the answers page for "get plastic surgery?"
  