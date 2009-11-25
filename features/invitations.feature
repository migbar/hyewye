Feature: Invitations
  In order find out when HyeWye launches
  As a user
  I want to be notified by email when the site launches 

  Scenario: Submiting email address
    Given I am on the homepage 
     When I fill in "Enter your email to be notified when we launch" with "foo@example.com"
      And I press "notify me"
     Then I should see "Thank you for your interest"
      And an invitation should exist with email: "foo@example.com"
      And "notifications@hyewye.com" should receive an email
     When I open the email
     Then I should see "\[HyeWye\] Notification request" in the email subject
      And I should see "foo@example.com" in the email body
  
  Scenario: Trying to subscribe with an invalid email
    Given I am on the homepage 
     When I fill in "Enter your email to be notified when we launch" with "not an email"
      And I press "notify me"
     Then I should see "is not an email"
