Feature: Defining basic letter patterns
	As a shy Rubyist,
  I want to use basic SRL letter patterns
	So that I can use them when crafting my regular expressions


Scenario: defining any small letter as pattern
  When I define the following SRL expression:
  """
  letter, 
  letter
  """
  Then I expect the generated regular expression source to be "[a-z][a-z]"
  Then I expect matching for:
  | "srl"     |
  | "99 km"   |
  | " >red: " |
  And I expect no match for:
  | "123" |
  | "ABC" |
  | "f1"  |
  | "?;!" |

  Scenario: defining any small letter for case insensitive pattern
  When I define the following SRL expression:
  """
  letter, 
  letter,
  case insensitive
  """
  Then I expect the generated regular expression source to be "[a-z][a-z]"
  Then I expect the full generated regular expression to be "(?i-mx:[a-z][a-z])"
  Then I expect matching for:
  | "srl"     |
  | "99 km"   |
  | " >red: " |
  | "ABC"     |
  And I expect no match for:
  | "123" |
  | "f1"  |
  | "?;!" |


Scenario: defining one small letter from a given range as pattern
  When I define the following SRL expression:
  """
  letter from a to f
  """
  Then I expect the generated regular expression source to be "[a-f]"
  Then I expect matching for:
  | "b1"   |
  | "red"  |
  |" 12 cm"|
  And I expect no match for:
  | "123" |
  | "z"   |
  | "12g3"|


Scenario: defining any capital letter as pattern
  When I define the following SRL expression:
  """
  uppercase letter
  """
  Then I expect the generated regular expression source to be "[A-Z]"
  Then I expect matching for:
  | "Ruby"    |
  | "99 Km"   |
  | " >OFF: " |
  And I expect no match for:
  | "123" |
  | "abc" |
  | "?;!" |

  
Scenario: defining one capital letter from a given range as pattern
  When I define the following SRL expression:
  """
  uppercase letter from X to Z
  """
  Then I expect the generated regular expression source to be "[X-Z]"
  Then I expect matching for:
  | "Yes"    |
  | ">Zulu"  |
  |" 123 wHY"|
  And I expect no match for:
  | "yES" |
  | "123" |
  | "12f3"|


Scenario: defining one small letter from a scrambled range as pattern
  When I define the following SRL expression:
  """
  letter from d to a
  """
  Then I expect the generated regular expression source to be "[a-d]"
  Then I expect matching for:
  | "b1"   |
  And I expect no match for:
  | "123" |


  
 
