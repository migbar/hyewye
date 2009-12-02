Feature: User Accounts
  In order to Ask and Answer questions
  As a user
  I want to register for an account, login and logout

  Scenario: Going to the registration page
    Given I am on the site index
     When I follow "Sign Up"
     Then I should see "Register for an account"
    
  Scenario: Registering for an account successfully
    Given I am on the registration page
     When I fill in "Login" with "my_login"
      And I fill in "Email" with "email@example.com"
      And I fill in "Password" with "password"
      And I fill in "Password Confirmation" with "password"
      And I press "Create Account"
     Then I should see "Thank you for registering my_login, your account has been created!"
      And I should be on the home page
  
  Scenario: Failing to register due to invalid options
    Given I am on the registration page
      And I press "Create Account"
     Then I should see "is too short"

  Scenario: Logging in successfully with an existing login name
    Given I am on the site index
      And a user exists with login: "my_login", password: "secret"
     When I follow "Log in"
      And I fill in "Login" with "my_login"
      And I fill in "Password" with "secret"
      And I press "Log in"
     Then I should see "Welcome my_login!"
      And I should be on the home page
      
  Scenario: Failing to log in with an invalid login name
    Given I am on the site index
     When I follow "Log in"
      And I fill in "Login" with "my_login"
      And I fill in "Password" with "secret"
      And I press "Log in"
     Then I should see "is not valid"
     # When I go to my account page # => /account
     # Then I should be on the login page # /user_session/new
     
  Scenario: logging out
    Given I log in with login: "my_login", password: "secret"
      And I am on the site index
     When I follow "Log out"
     Then I should see "You have logged out"
      And I should be on the home page 
  
  Scenario: attempting to log in twice  
    Given I log in with login: "my_login", password: "secret"
     When I go to the login page
     Then I should see "You must be logged out to access this page"
      And I should be on the home page
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  


