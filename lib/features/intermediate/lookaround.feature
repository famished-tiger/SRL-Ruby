Feature: Defining lookaround patterns
	As a shy Rubyist,
  I want to use intermediate SRL lookaround patterns
	So that I can use them when crafting my regular expressions


Scenario: using if not followed lookforward
  Given I define the following SRL expression:
  """
  capture (digit) if followed by (anything once or more, digit)
  """
  When I use the text "This example contains 3 numbers. 2 should not match. Only 1 should."
  Then I expect the first capture to be:
  | 0 | 3  |
  And I expect the second capture to be:
  | 0 | 2  |  
 
 
Scenario: using if not followed lookforward
  Given I define the following SRL expression:
  """
  capture (digit) if not followed by (anything once or more, digit)
  """
  When I use the text "This example contains 3 numbers. 2 should not match. Only 1 should."
  Then I expect the first capture to be:
  | 0 | 1  |


Scenario: using if already had
  Given I define the following SRL expression:
  """
  capture (literally "bar") if already had literally "foo"
  """
  Then I expect no match for:
  | "fobar"|
  When I use the text "foobar"
  Then I expect the first capture to be:
  | 0 | bar  |

  
Scenario: using if already had
  Given I define the following SRL expression:
  """
  capture (literally "bar") if not already had literally "foo"
  """
  Then I expect no match for:
  | "foobar"|
  When I use the text "fobar"
  Then I expect the first capture to be:
  | 0 | bar  |
  