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

  Scenario: Logging in successfully with an existing userid
    Given I am on the home page
      And a user exists with login: "my_login", password: "secret"
     When I follow "Log in"
      And I fill in "Login" with "my_login"
      And I fill in "Password" with "secret"
      And I press "Log in"
     Then I should see "Welcome my_login!"
      And I should be on the home page
      
  Scenario: Failing to log in 
  
  Scenario: logging out
  
  Scenario: attempting to log in twice  
  
  
  
  
  
  
  
  
  
  
  


