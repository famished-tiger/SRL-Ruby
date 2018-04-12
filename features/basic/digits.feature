Feature: Defining digit letter patterns
	As a shy Rubyist,
  I want to use basic SRL digit patterns
	So that I can use them when crafting my regular expressions


Scenario: defining any single digit as pattern
  When I define the following SRL expression:
  """
  digit
  """
  Then I expect the generated regular expression to be "\d"
  Then I expect matching for:
  | "123"     |
  | "THX1138" |
  | " >red7: "|
  And I expect no match for:
  | "one" |
  | "?;!" |


Scenario: using alternative syntax for any single digit
  When I define the following SRL expression:
  """
  number
  """
  Then I expect the generated regular expression to be "\d"
  Then I expect matching for:
  | "123"     |
  | "THX1138" |
  | " >red7: "|
  And I expect no match for:
  | "one" |
  | "?;!" |


  Scenario: defining a negated digit pattern
  When I define the following SRL expression:
  """
  no digit
  """
  Then I expect the generated regular expression to be "\D"
  Then I expect matching for:
  | "a"   |
  | "two" |
  | "B1"  |
  | "  1" |
  And I expect no match for:
  | "129" |


Scenario: defining any single digit from a given range as pattern
  When I define the following SRL expression:
  """
  digit from 3 to 8
  """
  Then I expect the generated regular expression to be "[3-8]"
  Then I expect matching for:
  | "4"   |
  | "124" |
  | "B52" |
  And I expect no match for:
  | "129" |
  | "five"|


Scenario: using alternative syntax for any single digit from a given range
  When I define the following SRL expression:
  """
  number from 3 to 8
  """
  Then I expect the generated regular expression to be "[3-8]"
  Then I expect matching for:
  | "4"   |
  | "124" |
  | "B52" |
  And I expect no match for:
  | "129" |
  | "five"|


Scenario: defining any single digit from a given scrambled range
  When I define the following SRL expression:
  """
  digit from 8 to 3
  """
  Then I expect the generated regular expression to be "[3-8]"
  Then I expect matching for:
  | "4"   |
  | "124" |
  | "B52" |
  And I expect no match for:
  | "129" |
  | "five"|
