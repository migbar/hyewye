Feature: Stream
  In order find out what people are asking and answering
  As a user
  I want to view all recent activity

  Scenario: viewing the stream shows only the events up to a limit
    Given the following questions and answers exist
      | model    | user    | body         | since |
      | question | adam    | question-1   | 1     |
      | question | bob     | question-2   | 2     |
      | question | adam    | question-3   | 3     |
      | question | dave    | question-4   | 4     |
      | question | bob     | question-5   | 5     |
      | question | charlie | question-6   | 6     |
      And I am on the site index
     Then I should see the following users and events
      | user | body          |
      | adam | question-1    |
      | bob  | question-2    |
      | adam | question-3    |
      | dave | question-4    |
  
  @wip
  Scenario: showing stats for a question in the sidebar
    Given the following questions and answers exist
      | model             | user | body       |
      | question          | bob  | question-2 |
      | answered_question | adam | question-1 |
     When I go to the site index
     Then I should see "question-1" within "#sidebar #stats"
  
  Scenario: Answering a question in the stream
    Given a question "hps" exists with body: "Have plastic surgery?"
      And I am on the site index
     When I follow "Answer" for question "hps"
     Then I should be at the answers page for question "hps"
  
  
  
