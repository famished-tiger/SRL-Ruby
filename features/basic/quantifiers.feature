Feature: Defining quntifiers for patterns
	As a shy Rubyist,
  I want to use quantifiers for patterns
	So that I can use them when crafting my regular expressions


Scenario: Repeat a pattern an exact number of times
  When I define the following SRL expression:
  """
  (uppercase letter,
  digit) exactly 2 times
  """
  Then I expect the generated regular expression to be "(?:[A-Z]\d){2}"
  Then I expect matching for:
  | "R2D2" |

  And I expect no match for:
  | "r2D2"|
  | "%[_]"|
  | "?;!" |
  | "SRL" |
  | "123" |


Scenario: Repeat a pattern a number from range
  When I define the following SRL expression:
  """
  begin with
  (uppercase letter,
  digit) between 2 and 4 times
  must end
  """
  Then I expect the generated regular expression to be "^(?:[A-Z]\d){2,4}$"
  Then I expect matching for:
  | "R2D2"     |
  | "A1B2C3"   |
  | "A1B2C3D4" |

  And I expect no match for:
  | "R2"          |
  | "R2d2"        |
  | "A1B2C3D4E5"  |
  | "%[_]"        |
  | "?;!"         |
  | "SRL"         |
  | "123"         |
  
  
Scenario: Repeat a pattern a number from range (without 'times' keyword)
  When I define the following SRL expression:
  """
  begin with
  (uppercase letter,
  digit) between 2 and 4
  must end
  """
  Then I expect the generated regular expression to be "^(?:[A-Z]\d){2,4}$"
  Then I expect matching for:
  | "R2D2"     |
  | "A1B2C3"   |
  | "A1B2C3D4" |

  And I expect no match for:
  | "R2"          |
  | "R2d2"        |
  | "A1B2C3D4E5"  |
  | "%[_]"        |
  | "?;!"         |
  | "SRL"         |
  | "123"         |


Scenario: Repeat a pattern zero or one times
  When I define the following SRL expression:
  """
  begin with one of "+-" optional,
  digit
  """
  Then I expect the generated regular expression to be "^[+\-]?\d"
  Then I expect matching for:
  | "42  "       |
  | "+42 "       |
  | "-42 "       |
  | "99 bottles" |

  And I expect no match for:
  | "R2"         |
  | "++42"       |


Scenario: Repeat a pattern zero or more times
  When I define the following SRL expression:
  """
  begin with one of "+-" optional,
  digit never or more,
  letter
  """
  Then I expect the generated regular expression to be "^[+\-]?\d*[a-z]"
  Then I expect matching for:
  | "42cm  "   |
  | "+42cm "   |
  | "-42cm "   |
  | "50cents"  |
  | "cents"    |
  | "-cents"   |

  And I expect no match for:
  | "++42"     |
  | "+42Km"    |


Scenario: Repeat a pattern one or more times
  When I define the following SRL expression:
  """
  begin with one of "+-" optional,
  digit once or more,
  letter
  """
  Then I expect the generated regular expression to be "^[+\-]?\d+[a-z]"
  Then I expect matching for:
  | "42cm  "   |
  | "+42cm "   |
  | "-42cm "   |
  | "50cents"  |

  And I expect no match for:
  | "++42"     |
  | "+42Km"    |
  | "cents"    |
  | "-cents"   |

  
Scenario: Repeat a pattern n times or more
  When I define the following SRL expression:
  """
  begin with letter at least 2 times,
  must end
  """
  Then I expect the generated regular expression to be "^[a-z]{2,}$"
  Then I expect matching for:
  | "ab"       |
  | "abcdef"   |

  And I expect no match for:
  | "a"        |


# This one won't very much in use
Scenario: Repeat a pattern exactly once
  When I define the following SRL expression:
  """
  begin with (uppercase letter, digit) once,
  must end
  """
  Then I expect the generated regular expression to be "^(?:[A-Z]\d){1}$"
  Then I expect matching for:
  | "R2"       |

  And I expect no match for:
  | "r2"     |
  | "R2D2"   |  


Scenario: Repeat a pattern twice
  When I define the following SRL expression:
  """
  begin with (uppercase letter, digit,
  literally "-" optional) twice,
  must end
  """
  Then I expect the generated regular expression to be "^(?:[A-Z]\d-?){2}$"
  Then I expect matching for:
  | "R2D2"     |
  | "R2-D2"    |
  | "R2-D2-"   |

  And I expect no match for:
  | "r2d2"     |
  | "R2D2E3"   |
  | "R2--D2"   |