Feature: Listing answers
  In order to find out what others have answered
  As a user
  I want to see the answers for a given question
  
  Background:
    Given a question "hps" exists with body: "Have plastic surgery?"
  
  Scenario: Seeing the answers for a question
    Given the following answers exist for question "hps"
       | user    | choice | body | since |
       | adam    | 1      | a1   | 1     |
       | bob     | 2      | a2   | 5     |
       | adam    | 3      | a3   | 3     |
       | charlie | 2      | a4   | 2     |

     When I navigate to the answers page for question "hps"
     Then I should see the following answers
       | User    | Choice        | Answer |
       | adam    | I Have        | a1     |
       | charlie | I Would       | a4     |
       | adam    | I Would Never | a3     |
       | bob     | I Would       | a2     |

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
