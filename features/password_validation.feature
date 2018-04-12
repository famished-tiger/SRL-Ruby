Feature: Defining a password validation pattern
	As a shy Rubyist,
  I want to use SRL to specify password pattern
	So that I can use its regex representation in my code


Scenario: defining a password validation expression
  When I define the following SRL expression:
  """
  if followed by (anything never or more, letter),
  if followed by (anything never or more, uppercase letter),
  if followed by (anything never or more, digit),
  if followed by (anything never or more, one of "!@#$%^&*[]\"';:_-<>., =+/\\"),
  anything at least 8 times
  """
  Then I expect matching for:
  | Sup3r $ecure! |
  | P@sSword1     |
  | Pass-w0rd     |

  And I expect no match for:
  | Password       |
  | P@sS1          |
  | justalongpassword  |
  | m1ss1ng upper  |
  | missing Number |
  | M1SS1NG LOWER  |
  | m1ss1ngSpec1al |