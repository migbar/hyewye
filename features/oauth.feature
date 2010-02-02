Feature: Oauth
  In order to easily access HyeWye
  As a Twitter user
  I want to be able to register and log in using my Twitter account

  Scenario: Logging in with Twitter
    Given a Twitter user "twitter_guy" registered with HyeWye
      And I am on the login page
     When I press "Let me log in using Twitter"
     Then I should see "Welcome twitter_guy!"
  
  Scenario: Attempting to log in an unregistered user with Twitter
    Given a Twitter user "twitter_guy" that is not registered with HyeWye
      And I am on the login page
     When I press "Let me log in using Twitter"
     Then I should see "It looks like you have not created an account on HyeWye yet"
     When I press "Let me login using Twitter"
     Then I should see "Thank you for registering twitter_guy"
  
  Scenario: Registering with Hyewye using Twitter
    Given a Twitter user "twitter_guy" that is not registered with HyeWye
      And I am on the registration page
     When I press "Register using Twitter"
     Then I should see "Thank you for registering twitter_guy"
  
  Scenario: Denying HyeWye access to Twitter
    Given a Twitter user that denies access to HyeWye
     When I am on the registration page
      And I press "Register using Twitter"
     Then I should see "You did not allow HyeWye to use your Twitter account"
  
  Scenario: Denying HyeWye access to Twitter
    Given a Twitter user that denies access to HyeWye
     When I am on the login page
      And I press "Let me log in using Twitter"
     Then I should see "You did not allow HyeWye to use your Twitter account"

  
  
  
