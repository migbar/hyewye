Feature: Stream
  In order find out what people are asking and answering
  As a user
  I want to view all recent activity
  
  Scenario: viewing the stream
    Given the following questions and answers exist
      | model    | body | since |
      | question | q1   | 1     |
      | question | q2   | 2     |
      | question | q3   | 3     |
      | question | q4   | 4     |
      | question | q5   | 90    |
      | question | q5   | 9000  |
     When I go to the home page
     Then I should see the following events
      | Event |
      | q1    |
      | q2    |
      | q3    |
      | q4    |
  
  Scenario: Answering a question in the stream
    Given a question "hps" exists with body: "Have plastic surgery?"
      And I am on the home page
     When I follow "Answer" for question "hps"
     Then I should be on the answers page for question "Have plastic surgery?"
  
  
  
