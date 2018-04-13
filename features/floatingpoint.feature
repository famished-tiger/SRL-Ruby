Feature: Defining a floating-point number pattern
	As a Rubyist,
  I want to use SRL to specify a pattern for floating points
	So that I can use its regex representation in my code


Scenario: defining a floating-point number expression
  When I define the following SRL expression:
  """
  begin with one of "-+" optional, 
  digit once or more,
  literally "." optional, 
  digit never or more,
  (
    one of "eE",
    one of "-+" optional,
     digit once or more
  ) optional,
  must end
  """
  Then I expect the generated regular expression to be "^[\-+]?\d+\.?\d*(?:[eE][\-+]?\d+)?$"
  Then I expect matching for:
  | 1        |
  | +2       |
  | -3       |
  | +5.      |
  | -6.      |
  | 7.123    |
  | 8.123E3  |
  | 9.123e-4 |

  And I expect no match for:
  | text   |
  | 1c     |
  | 1,5    |
  | 3E3+5  |
