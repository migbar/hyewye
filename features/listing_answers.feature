Feature: Listing answers
  In order to find out what others have answered
  As a user
  I want to see the answers for a given question
  
  Background:
    Given a question "hps" exists with body: "Have plastic surgery?"

  Scenario: Seeing the answers for a question
    Given the following answers exist for question "hps"
       | user    | choice | body       | since |
       | adam    | 1      | Answer-1   | 1     |
       | bob     | 2      | Answer-2   | 5     |
       | adam    | 3      | Answer-3   | 3     |
       | charlie | 2      | Answer-4   | 2     |

     When I navigate to the answers page for question "hps"
     Then I should see the following answers
       | User    | Choice        | Answer       |
       | adam    | I Have        | Answer-1     |
       | charlie | I Would       | Answer-4     |
       | adam    | I Would Never | Answer-3     |
       | bob     | I Would       | Answer-2     |

  Scenario: Paginating answers for a question
    Given 20 answers exist for question "hps"
     When I navigate to the answers page for question "hps"
     Then I should see "Answer-1"
      And I should see "Answer-15"
      But I should not see "Answer-16"
     When I follow "2" within ".pagination"
     Then I should see "Answer-16"
      And I should see "Answer-20"
      But I should not see "Answer-15"

  Scenario: title
    Given 2 answers exist with question: question "hps", choice: "1"
      And 3 answers exist with question: question "hps", choice: "2"
      And 5 answers exist with question: question "hps", choice: "3"
     When I navigate to the answers page for question "hps"
     Then I should see "20%" within "#stats .i_have"
      And I should see "30%" within "#stats .i_would"
      And I should see "50%" within "#stats .i_would_never"
   