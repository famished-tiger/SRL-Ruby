Feature: Defining literal strings as patterns
	As a shy Rubyist,
  I want to use basic SRL literal strings patterns
	So that I can use them when crafting my regular expressions


Scenario: defining a literal string as pattern
  When I define the following SRL expression:
  """
  literally "aba"
  """
  Then I expect the generated regular expression source to be "aba"
  Then I expect matching for:
  | "nabab  "  |
  | "alibaba"  |
  | "<abakka>" |

  And I expect no match for:
  | "a ba"|
  | "%[_]"|
  | "?;!" |
  | "srl" |
  | "SRL" |
  | "123" |


Scenario: defining a character from a set as pattern
  When I define the following SRL expression:
  """
  one of "13579"
  """
  Then I expect the generated regular expression source to be "[13579]"
  Then I expect matching for:
  | "NCC-1701-A"  |
  | "even24685"   |

  And I expect no match for:
  | "a ba"|
  | "%[_]"|
  | "?;!" |
  | "srl" |
  | "SRL" |
  | "246" |

  
Scenario: defining a character not from a  given set
  When I define the following SRL expression:
  """
  none of "13579"
  """
  Then I expect the generated regular expression source to be "[^13579]"
  Then I expect matching for:
  |  "42"   |
  | "text"  |
  | "%[_]?" |

  And I expect no match for:
  | "13" |