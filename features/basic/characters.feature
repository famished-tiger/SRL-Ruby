Feature: Defining basic character patterns
	As a shy Rubyist,
  I want to use basic SRL character patterns
	So that I can use them when crafting my regular expressions

# Reminder: in SRL, a character is either:
# a small letter [a-z]
# a capital letter [A-Z]
# a digit [0-9]
# an underscore '_'
Scenario: defining any character as pattern
  When I define the following SRL expression:
  """
  any character,
  any character
  """
  Then I expect the generated regular expression to be "\w\w"
  Then I expect matching for:
  | "srl"     |
  | "SRL"     |
  | "123"     |
  | " (red} " |
  | "r_!"     |
  And I expect no match for:
  | "B"   |
  | "%[_]"|
  | "?;!" |
  
  
Scenario: defining any non-character as pattern
  When I define the following SRL expression:
  """
  no character
  """
  Then I expect the generated regular expression to be "\W"
  Then I expect matching for:
  | "{}"      |
  | " (red} " |
  | "r_!"     |
  And I expect no match for:
  | "srl"     |
  | "SRL"     |
  | "123"     |  

