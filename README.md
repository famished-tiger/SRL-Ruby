# srl_ruby
[![Linux Build Status](https://travis-ci.org/famished-tiger/SRL-Ruby.svg?branch=master)](https://travis-ci.org/famished-tiger/SRL-Ruby)
[![Build status](https://ci.appveyor.com/api/projects/status/l5adgcbfo128rvo9?svg=true)](https://ci.appveyor.com/project/famished-tiger/srl-ruby)
[![Gem Version](https://badge.fury.io/rb/srl_ruby.svg)](https://badge.fury.io/rb/srl_ruby)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/famished-tiger/SRL-Ruby/blob/master/LICENSE.txt)


This project implements a [Simple Regex Language](https://simple-regex.com) parser and interpreter in Ruby.

## What is SRL?
[SRL](https://github.com/SimpleRegex) is a small language that lets you write pattern matching expressions
in a readable syntax that bears some resemblance with English.

As an example, let's assume that our mission is to create a regular expression
that matches the time in 12 hour clock format.  
Here is a SRL expression that matches the _hh:mm AM/PM_ time format:
```
digit from 0 to 1,
digit optional,
literally ":",
digit from 0 to 5, digit,
literally " ",
one of "AP", literally "M"
```

### Learn more about Simple Regex Language
Here are a couple of hyperlinks of interest:  
[Main SRL website](https://simple-regex.com)  
[SRL libraries](https://github.com/SimpleRegex)


## Why SRL?
Even without knowing SRL, a reader can easily grasp the details of the above SRL expression.
This is where SRL shines over the traditional regular expressions: high readability.
For instance, a regex for the clock format problem may look like this:
```
/[0-1]?\d:[0-5]\d [AP]M/
```

In terms of terseness, regexes are hard to beat. But it is also a well-known fact: regexes can be really hard to write and even harder to read ('decipher' verb is closer to reality).  
Alas, the path of creating and maintaining regexes can be full of frustration.

There comes SRL. The intent is to let developers define self-documenting patterns with an easy syntax.
And then let your computer translate SRL expressions into regular expressions.
`srl_ruby` allows you to craft self-documenting patterns in SRL and then generate
their Ruby regular expression representation.


Ah, by the way, our clock format pattern isn't completely correct. It will match invalid times like 19:34 PM.
The problem arises when the first digit in the hour field is a one: in that case the second digit can only be
zero or one.

Let's fix the issue in SRL:
```
any of (
  (literally "0" optional, digit),
  (literally "1", one of "01")
),
literally ":",
digit from 0 to 5, digit,
literally " ",
one of "AP", literally "M"
```

And there is the equivalent regex found by `srl_ruby`:  
```
/(?:(?:0?\d)|(?:1[01])):[0-5]\d [AP]M/
```


## Usage

The method `SrlRuby#parse` accepts a Simple Regex Language string as input, and returns the corresponding regular expression.

For instance, the following snippet...  

```ruby
require 'srl_ruby' # Load srl_ruby library


# Here is a multiline SRL expression that matches dates
# in yyyy-mm-dd format
some_srl = <<-END_SRL
  any of (literally "19", literally "20"), digit twice,
  literally "-",
  any of (
    (literally "0", digit),
    (literally "1", one of "012")
  ),
  literally "-",
  any of (
    (literally "0", digit),
    (one of "12", digit),
    (literally "3", one of "01")
  )  
END_SRL

# Next line launches the SRL parser, it returns the corresponding regex literal
result = SrlRuby.parse(some_srl)

puts 'Equivalent regexp: /' + result + '/'
```

...  produces the following output:
```
Equivalent regexp: /(?:19|20)\d{2}-(?:(?:0\d)|(?:1[012]))-(?:(?:0\d)|(?:[12]\d)|(?:3[01]))/
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'srl_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install srl_ruby


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/famished-tiger/SRL-Ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SrlRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/srl_ruby/blob/master/CODE_OF_CONDUCT.md).
