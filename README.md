# SrlRuby
[![Build Status](https://travis-ci.org/famished-tiger/SRL-Ruby.svg?branch=master)](https://travis-ci.org/famished-tiger/SRL-Ruby)

This project implements a [Simple Regex Language](https://simple-regex.com) interpreter in Ruby.

## What is SRL?
SRL is a small language lets you write regular expressions
with a readable syntax that bears some resemblance with English.
Here are a couple of hyperlinks of interest:  
[Main SRL website](https://simple-regex.com)  
[SRL libraries](https://github.com/SimpleRegex)


## An example
Let's assume that we want to create a regular expression that recognizes time in a day in the 24 hours format hh:mm:ss.
In SRL:
```
digit from 0 to 2, digit,
(literally ':', digit from 0 to 5, digit) twice
```

If one runs the `srl_ruby` command-line like this:

```
srl_ruby "digit from 0 to 2, digit, (literally ':', digit from 0 to 5, digit) twice"
```
It replies with:
```
SRL input: digit from 0 to 2, digit, (literally ':', digit from 0 to 5, digit) twice
Resulting Regexp: /[0-2]\d(?::[0-5]\d){2}/
```

In other words, it translates a readable SRL expression into its regexp equivalent.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'srl_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install srl_ruby

## Usage

TODO: Write usage instructions here


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/famished-tiger/SRL-Ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SrlRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/srl_ruby/blob/master/CODE_OF_CONDUCT.md).
