Feature: Defining an email validation pattern
	As a shy Rubyist,
  I want to use SRL to specify valid email address pattern
	So that I can use its regex representation in my code

Background:
  Given I define the following SRL expression:
  """
  begin with capture (letter once or more) as "protocol",
  literally "://",
  capture (
      letter once or more,
      any of (letter, literally ".") once or more,
      letter at least 2 times
  ) as "domain",
  (literally ":", capture (digit once or more) as "port") optional,
  capture (literally "/", anything never or more) as "path" until (any of (literally "?", must end)),
  literally "?" optional,
  capture (anything never or more) as "parameters" optional,
  must end,
  case insensitive
  """  
  
Scenario: defining url capturing expression
  When I use the text "https://example.domain.com:1234/a/path?query=param"
  Then I expect the first capture to be:
  | protocol   | https      |
  | domain     | example.domain.com  |
  | port       | 1234        |
  | path       | /a/path     |
  | parameters | query=param |