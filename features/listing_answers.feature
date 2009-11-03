Feature: Listing answers
  In order to find out what others have answered
  As a user
  I want to see the answers for a given question
  
  Scenario: Seeing the answers for a question
    Given a question "hps" exists with body: "Have plastic surgery?"
      And the following answers exist for question "hps"
        | choice | body | since |
        | 1      | a1   | 1     |
        | 2      | a2   | 5     |
        | 3      | a3   | 3     |
        | 2      | a4   | 2     |

     When I am on the answers page for question "Have plastic surgery?"
     Then I should see the following answers
        | Choice        | Answer |
        | I Have        | a1     |
        | I Would       | a4     |
        | I Would Never | a3     |
        | I Would       | a2     |



