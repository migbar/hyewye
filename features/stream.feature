Feature: Stream
  In order find out what people are asking and answering
  As a user
  I want to view all recent activity
  
  Scenario: viewing the stream
    Given the following questions and answers exist
      | model    | user    | body | since |
      | question | adam    | q1   | 1     |
      | question | bob     | q2   | 2     |
      | question | adam    | q3   | 3     |
      | question | dave    | q4   | 4     |
      | question | bob     | q5   | 90    |
      | question | charlie | q6   | 9000  |
     When I go to the home page
     Then I should see the following events
      | User | Event |
      | adam | q1    |
      | bob  | q2    |
      | adam | q3    |
      | dave | q4    |
  
  Scenario: Answering a question in the stream
    Given a question "hps" exists with body: "Have plastic surgery?"
      And I am on the home page
     When I follow "Answer" for question "hps"
     Then I should be on the answers page for question "Have plastic surgery?"
  
  
  
