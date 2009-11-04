Feature: User Activity Stream
  In order find out what a user has been asking and answering
  As a user
  I want to view a user's activity stream
  
  # Scenario: viewing the stream for a user
  #   Given the following questions and answers exist for user "bob"
  #     | model    | body | since |
  #     | question | q1   | 1     |
  #     | question | q2   | 2     |
  #     | question | q3   | 3     |
  #   And the following questions and answers exist for user "john"
  #     | question | q4   | 4     |
  #     | question | q5   | 90    |
  #     | question | q6   | 9000  |
  #    When I go to the user page for "bob"
  #    Then I should see the following events
  #     | Event |
  #     | q1    |
  #     | q2    |
  #     | q3    |
  #    But I should not see the following events
  #     | Event |
  #     | q4    |
  #     | q5    |
  #     | q6    |
 