Feature: Defining alternation as patterns
	As a shy Rubyist,
  I want to use alternation combine patterns
	So that I can use them when crafting my regular expressions


Background:
  Given I define the following SRL expression:
  """
  capture (any of (literally "sample", (digit once or more)))
  """


Scenario: defining an alternation as pattern
  Then I expect the generated regular expression source to be "((?:sample|(?:\d+)))"
  Then I expect matching for:
  | "two samples  "  |
  | "         1234"  |
  | " sample 42"     |

  And I expect no match for:
  | "a ba"|
  | "%[_]"|
  | "?;!" |
  | "srl" |
  
  
Scenario: capturing an alternation 
  When I use the text "sample 42"
  Then I expect the first capture to be:
  | 0 | sample  |
  And I expect the second capture to be:
  | 0 | 42  |
  

