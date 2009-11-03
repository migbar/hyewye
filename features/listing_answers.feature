Feature: Listing answers
  In order to find out what others have answered
  As a user
  I want to see the answers for a given question
  
  Scenario: Seeing the answers for a question
    Given a question "hps" exists with body: "Have plastic surgery?"
      And the following answers exist for question "hps"
       | user    | choice | body | since |
       | adam    | 1      | a1   | 1     |
       | bob     | 2      | a2   | 5     |
       | adam    | 3      | a3   | 3     |
       | charlie | 2      | a4   | 2     |

     When I am on the answers page for question "Have plastic surgery?"
     Then I should see the following answers
       | User    | Choice        | Answer |
       | adam    | I Have        | a1     |
       | charlie | I Would       | a4     |
       | adam    | I Would Never | a3     |
       | bob     | I Would       | a2     |



