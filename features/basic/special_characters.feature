Feature: Defining basic special character patterns
	As a shy Rubyist,
  I want to use basic SRL special character patterns
	So that I can use them when crafting my regular expressions


Scenario: defining any whitespace as pattern
  When I define the following SRL expression:
  """
  whitespace,
  whitespace
  """
  Then I expect the generated regular expression source to be "\s\s"
  Then I expect matching for:
  | "two spaces>  " |
  | "  <two spaces" |
  | " two>  spaces" |

  And I expect no match for:
  | "B"   |
  | "%[_]"|
  | "?;!" |
  | "srl" |
  | "SRL" |
  | "123" | 
  
  
Scenario: defining any non-whitespace as pattern
  When I define the following SRL expression:
  """
  no whitespace
  """
  Then I expect the generated regular expression source to be "\S"
  Then I expect matching for:
  | "{}"      |
  | " (red} " |
  | "r_!"     |
  And I expect no match for:
  | "   "     |

  
Scenario: defining a backslash as pattern
  When I define the following SRL expression:
  """
  backslash
  """
  Then I expect the generated regular expression source to be "\\"
  Then I expect matching for:
  | "   \   " |
  | "{}\    " |
  And I expect no match for:
  | "   " |
  | "B"   |
  | "%[_]"|
  | "?;!" |
  | "srl" |
  | "SRL" |
  | "123" | 
  
Scenario: defining a tab as pattern
  When I define the following SRL expression:
  """
  tab
  """
  Then I expect the generated regular expression source to be "\t"


Scenario: defining a vertical tab as pattern
  When I define the following SRL expression:
  """
  vertical tab
  """
  Then I expect the generated regular expression source to be "\v"

  
Scenario: defining a newline as pattern
  When I define the following SRL expression:
  """
  new line
  """
  Then I expect the generated regular expression source to be "\n"


  Scenario: defining a carriage return as pattern
  When I define the following SRL expression:
  """
  carriage return
  """
  Then I expect the generated regular expression source to be "\r"

