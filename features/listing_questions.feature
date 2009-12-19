Feature: Listing questions
  In order to see what people are inquiring about
  As a user
  I want to see a list of the questions
  
  Scenario: Listing questions for a user
    Given a user "curious_cat" exists
      And another user "another_cat" exists
      And the following questions exist:
        | body       | user               |
        | question 1 | user "curious_cat" |
        | question 2 | user "curious_cat" |
        | question 3 | user "another_cat" |
     When I navigate to the questions page for user "curious_cat"
     Then I should see the following
        | question 1 |
        | question 2 |
      But I should not see "question 3"
      
  
  
