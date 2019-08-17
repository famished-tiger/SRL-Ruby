Feature: Defining capture patterns
	As a shy Rubyist,
  I want to use intermediate SRL capture patterns
	So that I can use them when crafting my regular expressions


Scenario: using named captures
  Given I define the following SRL expression:
  """
  capture (anything once or more) as "first", 
  literally " - ", 
  capture (literally "second part") as "second"
  """
  When I use the text "first part - second part"
  Then I expect the first captures to be:
  |first | first part  |
  |second| second part |


Scenario: using anonymous captures
  Given I define the following SRL expression:
  """
  capture (anything once or more), 
  literally " - ", 
  capture (literally "second part")
  """
  When I use the text "first part - second part"
  Then I expect the first captures to be:
  | 0 | first part  |
  | 1 | second part |

  
Scenario: using capture ... until
  Given I define the following SRL expression:
  """
  begin with capture (
    anything once or more
  ) until literally "m"
  """
  When I use the text "this is an example"
  Then I expect the first capture to be:
  | 0 | this is an exa  |
  
  
Scenario: using any of
  Given I define the following SRL expression:
  """
  capture (any of (literally "sample", (digit once or more)))
  """
  When I use the text "sample && 1234"
  Then I expect the first captures to be:
  | 0 | sample  |
  | 1 | 1234    |
  
  
Scenario: using either of (synonym of any of)
  Given I define the following SRL expression:
  """
  capture (either of (literally "sample", (digit once or more)))
  """
  When I use the text "sample && 1234"
  Then I expect the first captures to be:
  | 0 | sample  |
  | 1 | 1234    |
  

Scenario: using captures and greedy lode (default)
  Given I define the following SRL expression:
  """
  capture(letter once or more)
  """
  When I use the text "this is a sample"
  Then I expect the first captures to be:
  | 0 | this  |
  | 1 | is    |
  | 2 | a     |
  | 3 | sample|   

  
Scenario: using captures and lazy flag
  Given I define the following SRL expression:
  """
  capture(letter once or more),
  all lazy
  """
  When I use the text "this is a sample"
  Then I expect the first captures to be:
  | 0 | t  |
  | 1 | h  |
  | 2 | i  |
  | 3 | s  | 
  | 4 | i  |
  | 5 | s  |
  | 6 | a  |
  | 7 | s  |
  | 8 | a  |
  | 9 | m  |
  | 10| p  |
  | 11| l  |
  | 12| E  |  
