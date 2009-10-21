Feature: User Accounts
  In order to Ask and Answer questions
  As a user
  I want to register for an account, login and logout

  Scenario: Going to the registration page
    Given I am on the home page
     When I follow "Sign Up"
     Then I should see "Register for an account"
    
  Scenario: Registering for an account successfully
    Given I am on the registration page
     When I fill in "Login" with "my_login"
      And I fill in "Email" with "email@example.com"
      And I fill in "Password" with "password"
      And I fill in "Password Confirmation" with "password"
      And I press "Create Account"
     Then I should see "Account Created!"
      And I should be on the home page
  
  Scenario: Failing to register due to invalid options
    Given I am on the registration page
      And I press "Create Account"
     Then I should see "errors prohibited this user from being saved"
