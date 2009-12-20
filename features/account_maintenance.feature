################################################################################
# MORE FEATURES - account maintenance (password, email, twitter integration ...)
################################################################################  


Feature: Account maintenance
  In order keep my account information current 
  As a registered user
  I want maintain my account information


  Scenario: change email

  Scenario: change password
    Given I am logged in
      And I am on my account page
     When I fill in "password" with "secret"
      And I fill in "password confirmation" with "secret"
      And I press "save"
     Then I should see "Account successfully updated"

  Scenario: reset password
    Given a user exists with email: "miguel@example.com"
      And I am on the login page
     When I follow "Recover password"
      And I fill in "email" with "miguel@example.com"
      And I press "Request password reset"   
     Then I should see "We have sent password reset instructions to miguel@example.com. Please check your email."
      And "miguel@example.com" should receive an email
     When I open the email
     Then I should see "\[HyeWye\] Password reset instructions" in the email subject
     When I click the first link in the email
      And I fill in "Password" with "secret"
      And I fill in "Password confirmation" with "secret"
      And I press "Update my password and log me in"
     Then I should see "Password successfully updated"
      And I should be on the homepage
@wip
  Scenario: opting to tweet my activity
    Given a Twitter user "twitter_guy" registered with HyeWye
      And I log in using Twitter
      And I am on my account page
     When I uncheck "tweet my activity" 
      And I press "Save"
     Then I should see "Account successfully updated"   
  
  
  