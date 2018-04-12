Feature: Defining regular expression as pattern
	As a shy Rubyist,
  I want to embed regex expression in SRL
	So that I can use them when crafting complex regular expressions


Scenario: defining a literal string as pattern
  When I define the following SRL expression:
  """
  letter,
  raw "[^1-4]"
  """
  Then I expect the generated regular expression to be "[a-z][^1-4]"
  Then I expect matching for:
  | " b52  "  |
  | "road66"  |
  | "a     "  |

  And I expect no match for:
  | "%[_]"|
  | "?;!" |
  | "12b" |