# srl_ruby
[![Linux Build Status](https://travis-ci.org/famished-tiger/SRL-Ruby.svg?branch=master)](https://travis-ci.org/famished-tiger/SRL-Ruby)
[![Build status](https://ci.appveyor.com/api/projects/status/l5adgcbfo128rvo9?svg=true)](https://ci.appveyor.com/project/famished-tiger/srl-ruby)
[![Gem Version](https://badge.fury.io/rb/srl_ruby.svg)](https://badge.fury.io/rb/srl_ruby)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/famished-tiger/SRL-Ruby/blob/master/LICENSE.txt)


Welcome to the first Ruby implementation of a [Simple Regex Language](https://simple-regex.com) (SRL) parser and compiler.  
It allows you to write __highly-readable__ text patterns in SRL and then generate their Ruby `Regexp` counterparts.  
Ever wanted to write challenging regular expressions but were intimided by their arcane, cryptic syntax?  
With **srl_ruby** you can easily design your patterns in SRL and let *srl_ruby* transform them into terse `Regexp`.

### Features:
- Command-line SRL-to-Ruby compiler with customizable output.
- Ruby API for integrating a SRL parser or compiler with your code.
- 100% pure Ruby with clean design (_not a port from some other language_)
- Minimal runtime dependency ([Rley](https://rubygems.org/gems/rley) gem). Won't drag a bunch of gems...
- Compatibility: works with Ruby 2.3+ MRI, JRuby
- Portability: tested on both Linux and Windows,...

## Installation

### ...with Bundler
Add this line to your application's Gemfile:

    gem 'srl_ruby'

And then execute:

    $ bundle

### ...with Rubygem
Or install it directly yourself with the command line:

    $ gem install srl_ruby

## Usage
Let's test the installation by launching the __srl2ruby__ (SRL-to-Ruby) command-line compiler with the help option:

    $ srl2ruby --help

It should output something similar to:

```
Usage: srl2ruby SRL_FILE [options]

Description:
  Parses a SRL file and compiles it into a Ruby Regexp literal.
  Simple Regex Language (SRL) website: https://simple-regex.com

Examples:
  srl2ruby example.srl
  srl2ruby -p 'begin with literally "Hello world!"'
  srl2ruby example.srl -o example_re.rb -t srl_and_ruby.erb

Options:
    -p, --pattern SRL_PATT           One-liner SRL pattern.
    -o, --output-file PATH           Output to a file with specified name.
    -t, --template-file TEMPLATE     Use given ERB template for the Ruby code generation. srl2ruby looks for
the template file in current dir first then in its gem's /templates dir.

        --version                    Display the program version then quit.
    -?, -h, --help                   Display this help then quit.
```

## A quick intro to SRL and srl2ruby
### What is SRL?
SRL is a small language that lets you write pattern matching expressions
in a readable syntax that bears some resemblance with English.
For SRL documentation and examples, we cannot but recommend you to jump to the [official SRL website](https://simple-regex.com).

### Why SRL?
It is a well-known fact: regexes can be really hard to write and even harder to read ('decipher' verb is closer to reality).  
Alas, the path of creating and maintaining regexes can be full of frustration.

There comes SRL. The intent is to let developers define self-documenting patterns with an easy syntax.
And then let your computer translate SRL expressions into terse regular expressions.

### Our first SRL pattern
Let's succumb to the traditional 'hello world' example. True, it is a contrived example that doesn't make justice to SRL expressiveness. On the other hand, it is a starting point good enough to learn the compile cycle.

As a first step, let's create a file named `hello.srl` with just the following line:  
```
begin with literally "Hello world!"
```

It should read as 'Match any text that begins with the exact text "Hello world!"'  
Now, if one invokes the `srl2ruby` compiler with the command line...

    $ srl2ruby hello.srl


... one gets the following output:
```
Parsing file 'hello.srl'
/^Hello world!/
```

The last displayed line is the Ruby `Regexp` representation of the above SRL line. It can be pasted as such in your Ruby code, like in the following Ruby snippet:
```ruby
subject = 'Hello world! Welcome to SRL...'
puts 'It matches!' if subject =~ /^Hello world!/  
```

As expected the snippet results in the message:
```
It matches!
```

**Quick recap:**  
- `srl2ruby` expects a SRL file (typically with a .srl extension)  
- It parses the _Simple Regex Language_ content...  
- ... then generates the `Regexp` that is equivalent to the SRL input  
- Finally, it prints the results to the console.

Feature: with the command-line `-o` option the compiler will send the output to a file with specified name.  


### Gears up
Let's admit it, our first example wasn't really impressive.  
So, let's try with a more imposing example inspired from the [official SRL website](https://simple-regex.com): an email validation pattern.

```
begin with any of (digit, letter, one of "._%+-") once or more,
literally "@",
any of (digit, letter, one of ".-") once or more,
( literally ".",
  letter at least 2 times
) optional,
must end,
case insensitive
```

Assume that the previous SRL pattern was put in a file named `email_validation.srl` and that we invoked `srl2ruby` with the following command-line:

    $ srl2ruby email_validation.srl

Then the output should be:
```
Parsing file 'email_validation.srl'
/(?i-mx:^(?:\d|[a-z]|[._%+\-])+@(?:\d|[a-z]|[.\-])+(?:\.[a-z]{2,})?$)/
```

The resulting regexp isn't for the fainted hearts: who's ready to maintain it? In addition, the above pattern covers only the most frequent cases.  
If you were asked to cover more exotic cases, and knowing that it means an expression at least twice as complex, which version are you willing to update the SRL or the Regexp one?

#### Good to know: customizable output
In fact, if one wants to update or maintain a pattern, it would be practical to have the SRL expression and its equivalent Regexp next to each other in our Ruby source code.  
Can the `srl2ruby` compiler help there?  The answer is ... yes.  
First, it is good to know that the output of the `srl2ruby` compiler can be tailored with an ERB template. For instance, the output of all the previous examples is relying on a default template called `base.erb`. It is bundled in the `srl_ruby` gem as another template called `srl_and_ruby.erb`. This second template will emit the SRL code (in Ruby comments) followed by the Regexp literal.  
So let's use it with our email validation example:

    $ srl2ruby email_validation.srl --template-file srl_and_ruby.erb

The shorter option `-t` syntax is also possible:

    $ srl2ruby email_validation.srl -t srl_and_ruby.erb

The compiler's output contains now the original SRL expression in comments:  

```
Parsing file 'email_validation.srl'
# SRL expression follows:
# begin with any of (digit, letter, one of "._%+-") once or more,
# literally "@",
# any of (digit, letter, one of ".-") once or more,
# ( literally ".",
#   letter at least 2 times
# ) optional,
# must end,
# case insensitive
#
# ... and its Regexp equivalent:
/(?i-mx:^(?:\d|[a-z]|[._%+\-])+@(?:\d|[a-z]|[.\-])+(?:\.[a-z]{2,})?$)/
```
The above SRL code in comments can be safely inserted in a Ruby file.

**Quick recap:**  
- SRL can be used to specify much more challenging patterns than our boring 'Hello world!'.  
- The `srl2ruby` compiler uses a ERB template to format its output.  
- It is possible to choose a specific template via the `-t` option.  

_Feature_: When given the name of a template via the `-t` option, the compiler will look first for such a template in the current directory, then, if not found, in its `templates` directory. This gives the opportunity to use customized local template files.  

## Time for yet another example

As an example, let's assume that we are asked to create a regular expression that matches the time in 12 hour clock format (say, _hh:mm AM/PM_).
In addition, the hour and minute values must be put (= captured) in a variable named `hour` and `min` respectively.  

We will proceed in multiple iterations of increasing complexity.  
However, for those that are always in a hurry and like movie spoils, here is the requested `Regexp`:
```ruby
/(?i-mx:^(?<hour>(?:(?:0?\d)|(?:1[01]))):(?<min>(?:0?|[1-5])\d)\s?[AP]M$)/
```
Want to jump directly to the latest [iteration](#iteration-5)?...


### Iteration 1
Here is a very naive SRL expression that matches the requested time format:
```
begin with digit twice,
literally ":",
digit twice
literally " ",
one of "AP", literally "M",
must end
```

If one compiles the above SRL expression with `srl2ruby` as explained earlier in ['Our first SRL pattern'](#our-first-srl-pattern) section, it will generate the following Regexp literal:
```ruby
/^\d{2}:\d{2} [AP]M$/
```

When I want to test regular expressions, one of my favorite tool is the
[Rubular website](http://rubular.com/). Tom Lovitt created a great Regexp editor and tester specifically for the Ruby community.

By the way, perhaps some lynx-eyed readers spotted a small "mistake" on the third line of the SRL snippet: it doesn't end with a comma.  
My apologies... For style consistency this line should be written as:  
```
digit twice,
```
In reality, SRL happily ignores comma. Well..., most of the time. There is one exception: for the `any of` construct commas are used to separate alternatives (see example in [Iteration 3](#iteration-3)).

### Iteration 2
Tests won't take a long time to show that the previous pattern is much too 'lenient' and will accept grossly incorrect entries such as 45:67 PM.  

For our next iteration, we keep note that:  
- The first digit (from the left) can take the values 0 or 1 only.  
- The third digit may run from 0 to 5 since the highest value for the minutes is 59.  

Here is the improved SRL version:
```
begin with digit from 0 to 1,
digit,
literally ":",
digit from 0 to 5,
digit,
literally " ",
one of "AP", literally "M"
must end
```

`srl2ruby` will swallow the SRL file and will spit out the next Regexp:
```ruby
/^[0-1]\d:[0-5]\d [AP]M$/
```
### Iteration 3
Erroneous values like 45:67 PM are no more accepted this time. That's definitively better...
But other tests will reveal that our pattern is still too permissive since it accepts values like 17:23 PM. A hour value of 17 is OK in 24 hour format but here we fail meeting our requirements...

So, for our third try, we keep note that:
- If the first hour digit is 1, then the second digit can take the values 0 or 1 only.

Let's refactor our pattern:
```
begin with any of (
  (literally "0", digit),
  (literally "1", one of "01")
)
literally ":",
digit from 0 to 5,
digit,
literally " ",
one of "AP", literally "M"
must end
```

Remarks:  
- The indentation isn't required by SRL, but I find that it contributes to the readability...

`srl2ruby` will transform this into:
```ruby
/^(?:(?:0\d)|(?:1[01])):[0-5]\d [AP]M$/
```

### Iteration 4
This time the pattern works correctly. But in the meantime, our customer changed his requirements (*of course, such things never happen in real life...*). He asks for more flexibility in the pattern:
- If the most significant digit value is zero, it is optional (i.e. some clock models won't display it).
- The space between the minute value and the AM/PM indicator is now optional.
- The AM/PM indicator can sometimes be written in small letters (am/pm).

Let's go for another tour:
```
begin with any of (
  (literally "0" optional, digit),
  (literally "1", one of "01")
)
literally ":",
any of (
  literally "0" optional,
  digit from 1 to 5
),
digit,
whitespace optional,
one of "AP", literally "M"
must end,
case insensitive
```

Here is the Regexp counterpart generated by `srl2ruby`:
```ruby
/(?i-mx:^(?:(?:0?\d)|(?:1[01])):(?:0?|[1-5])\d\s?[AP]M$)/
```
### Iteration 5
Are we done? No: we were asked to capture the values of hours and minutes.

SRL allows for named captures, so here is the updated version:
```
begin with capture(
  any of (
    (literally "0" optional, digit),
    (literally "1", one of "01")
  )
) as "hour",
literally ":",
capture(
  any of (
    literally "0" optional,
    digit from 1 to 5
  ),
  digit
) as "min",
whitespace optional,
one of "AP", literally "M"
must end,
case insensitive
```

`srl2ruby` will swiftly swallow the above SRL pattern and generate the following Regexp:
```ruby
/(?i-mx:^(?<hour>(?:(?:0?\d)|(?:1[01]))):(?<min>(?:0?|[1-5])\d)\s?[AP]M$)/
```

That Regexp is becoming insane...


#### Does this last Regexp really work?
Glad you asked... Here is a Ruby snippet that can be used to test the last generated Regexp:

```ruby
# Next Regexp was copy-pasted from srl2ruby output
pattern = /(?i-mx:^(?<hour>(?:(?:0?\d)|(?:1[01]))):(?<min>(?:0?|[1-5])\d)\s?[AP]M$)/
text = '1:43am'

matching = pattern.match(text)
if matching
  print 'Capture names: '; p(matching.names) # => Capture names: ["hour", "min"]
  puts "Value of 'hour': #{matching[:hour]}" # => Value of 'hour': 1
  puts "Value of 'min': #{matching[:min]}" # => Value of 'min': 43
else
  puts "Text '#{text}' doesn't match."
end
```

Running this snippet, gives the following output:
```
Capture names: ["hour", "min"]
Value of 'hour': 1
Value of 'min': 43
```
As one can see, from the input '1:43am', the Regexp captured the hour and minute values in the appropriate capture variable. Mission accomplished...   

## srl_ruby API

The method `SrlRuby#parse` accepts a Simple Regex Language string as input, and returns the corresponding regular expression as a `Regexp` instance.

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


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/famished-tiger/SRL-Ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SrlRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/srl_ruby/blob/master/CODE_OF_CONDUCT.md).
