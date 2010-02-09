Feature: User Activity Stream
  In order find out what a user has been asking and answering
  As a user
  I want to view a user's activity stream
  
  Background: 
    Given a user "bob" exists
      And a user "john" exists
  
  Scenario: viewing the stream for a user
    Given the following questions and answers exist for user "bob"
      | model    | body | since |
      | question | q1   | 1     |
      | question | q2   | 2     |
      | question | q3   | 3     |
    And the following questions and answers exist for user "john"
      | model    | body | since |
      | question | q4   | 4     |
      | question | q5   | 90    |
      | question | q6   | 9000  |
     When I navigate to the model page for user "bob"
     Then I should see the following events
      | Event |
      | q1    |
      | q2    |
      | q3    |
     But I should not see the following events
      | Event |
      | q4    |
      | q5    |
      | q6    |
 
@wip
  Scenario: Paginating events for a user
    Given user "bob" answered 20 questions
     When I navigate to the model page for user "bob"
     Then I should see "Answer-1"
      And I should see "Answer-15"
      But I should not see "Answer-16"
     When I follow "2" within ".pagination"
     Then I should see "Answer-16"
      And I should see "Answer-20"
      But I should not see "Answer-15"
 