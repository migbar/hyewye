Feature: Avatar
  In order to be recognized on hyewye
  As a user 
  I want to display my avatar

@wip
  Scenario: Using Twitter's avatar
    Given a Twitter user "twitter_guy" registered with HyeWye
      And I log in using Twitter
     When I navigate to the model page for user "twitter_guy"
     Then I should see the Twitter avatar for user "twitter_guy"
@wip
  Scenario: Using a Gravatar
    Given a user "miguel" exists with login: "miguel", password: "secret"
      And I log in with login: "miguel", password: "secret"
     When I navigate to the model page for user "miguel"
     Then I should see the Gravatar for user "miguel"
