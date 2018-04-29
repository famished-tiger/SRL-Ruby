Feature: Defining an email validation pattern
	As a shy Rubyist,
  I want to use SRL to specify valid email address pattern
	So that I can use its regex representation in my code


Scenario: defining email validating expression
  # The expression isn't 100 reliable but suffice in a vast majority of cases
  When I define the following SRL expression:
  """
  begin with any of (digit, letter, one of "._%+-") once or more,
  literally "@",
  any of (digit, letter, one of ".-") once or more,
  ( literally ".",
    letter at least 2 times ) optional,
  must end, 
  case insensitive
  """
  Then I expect the generated regular expression source to be "^(?:\d|[a-z]|[._%+\-])+@(?:\d|[a-z]|[.\-])+(?:\.[a-z]{2,})?$"
  Then I expect matching for:
  | s@example.com |
  | simple@example.com    |
  | john.doe@example.com  |
  | disposable.style.email.with+symbol@example.com |
  | other.email-with-dash@example.com  |
  | fully-qualified-domain@example.com |
  | user.name+tag+sorting@example.com  |
  | example-indeed@strange-example.com |
  | example@s.solutions |
  | user@localserver    |

  And I expect no match for:
  | admin.example.com      |
  | @office.info.com |
  | method()*@example.com  |
  | a@b@c@example.com      |
  
 