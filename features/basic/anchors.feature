Feature: Defining anchors as patterns
	As a shy Rubyist,
  I want to use basic SRL anchors patterns
	So that I can use them when crafting my regular expressions


Scenario: defining a begin anchor as pattern
  When I define the following SRL expression:
  """
  begin with uppercase letter,
  digit
  """
  Then I expect the generated regular expression to be "^[A-Z]\d"
  Then I expect matching for:
  | "R2"   |
  | "A10"  |

  And I expect no match for:
  | " R2 " |
  | "r2  " |
  | "%[_]" |
  | "?;!"  |
  | "SRL"  |
  | "123"  |
  

Scenario: defining a begin anchor as pattern (alternative syntax)
  When I define the following SRL expression:
  """
  starts with uppercase letter,
  digit
  """
  Then I expect the generated regular expression to be "^[A-Z]\d"
  Then I expect matching for:
  | "R2"   |
  | "A10"  |

  And I expect no match for:
  | " R2 " |
  | "r2  " |


Scenario: defining an end anchor as pattern
  When I define the following SRL expression:
  """
  uppercase letter,
  digit,
  must end
  """
  Then I expect the generated regular expression to be "[A-Z]\d$"
  Then I expect matching for:
  | "r2-D2"   |
  | "! B1"    |

  And I expect no match for:
  | " R2 " |
  | "  r2" |
  | "%[_]" |
  | "?;!"  |
  | "SRL"  |
  | "123"  |