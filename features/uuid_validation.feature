Feature: Defining a UUID validation pattern
	As a shy Rubyist,
  I want to use SRL to specify password pattern
	So that I can use its regex representation in my code


Scenario: defining a UUID validation expression
  # The pattern is based on the 8-4-4-4-12 syntax
  When I define the following SRL expression:
  """
  begin with (any of(digit, letter from a to f)) exactly 8 times,
  literally "-",
  (
    (any of(digit, letter from a to f)) exactly 4 times,
    literally "-"
  ) exactly 3 times,
  (any of(digit, letter from a to f)) exactly 12 times
  """
  Then I expect matching for:
  | 123e4567-e89b-12d3-a456-426655440000 |
  | 00112233-4455-6677-8899-aabbccddeeff |

  And I expect no match for:
  | 123e4567e89b12d3a456426655440000 |