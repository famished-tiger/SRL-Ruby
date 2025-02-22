## [0.4.13] - 2025-02-22
- Tested against MRI Ruby 3.4.1

### Changed
- Shortened `.rubocop.yml` file

### Fixed
- Fixed all "offences" reported by Rubocop 1.72.2 

## [0.4.12] - 2022-04-22
- Code refactoring.

### Changed
- Refactoring class `SrlRuby::Tokenizer`: use of manifest constants, simplified newline and whitespace processing.
- Updated of `.rubocop.yml` to integrate newer cops (from version 1.28)
- Code refactoring: removal of redundant `return`

## [0.4.11] - 2022-04-17
- Fixed code breaking change in Ruby 3.1+: prime library is no longer part of stdlib.

### Fixed
- File `srl-ruby.gemspec` has a dependency to `Rley 0.8.11`. Necessary to fix change in CRuby 3.1:  `prime` library is no more part of stdlib.

### Changed
- Minor style refactoring to please Runocop 1.27

## [0.4.9] - 2021-11-01
- Code update to align with `Rley` v. 0.8.08

### Changed
- File `ast_builder.rb` Updated some `reduce_...` methods to cope with ? quantifier change
- File `srl_ruby.gemspec` Updated the dependency towards Rley
- File `.rubocop.yml` Added newest cops from 1.21 and 1.22

### Fixed
- File `grammar.rb` is now calling `Rley::grammar_builder` factory method.
- File `rule_file_grammar.rb` is now calling `Rley::grammar_builder` factory method.

## [0.4.8] - 2021-08-27
- Updated dependencies (Bundler >~ 2.2), (Rley >~ 0.8.03)
- Grammar refactoring to take profit of new Rley rule syntax.

### Changed
- File `srl_ruby.gemspec` Updated the dependencies
- File `grammar.rb` Grammar refactored (use  ? * + modifiers in production rules)
- class `ASTBuilder` updated `reduce_` to reflect new refactored production rules.

## [0.4.7] - 2021-08-24
- Updated dependencies (Ruby >= 2.5), (Rley >= 0.8.02)
- Code restyling to please rubocop 1.19.1. 
### Changed
- File `srl_ruby.gemspec` Updated the dependencies
- File `.rubocop.yml` Added configuration for newest cops

## [0.4.6] - 2019-08-17
- Code refactoring to use string frozen magic comments (as a consequence, skeem runs only on Rubies 2.3 or newer).  
- Code restyling to please rubocop 0.7.40. 
### Changed
- File `README.md` updated note on compatibility with Rubies


## [0.4.5] - 2019-01-13
- Removed Ruby versions older than 2.3 in CI testing because of breaking changes by Bundler 2.0  

### Changed
* Files `.travis.yml`, `appveyor.yml` updated.

## [0.4.5] - 2019-01-02
### Changed
- Minor code re-styling to please Rubocop 0.62.0.
- File `.travis.yml` Updated Ruby versions for CI builds
- File `.appveyor.yml` Sequence of Ruby versions refactored
- File `LICENSE.txt`: updated years in copyright text.

### Fixed
- Method `ASTBuilder#reduce_pattern_sequence` was broken for lookbehind assertions.

## [0.4.4] - 2018-11-24
### Changed
- File `srl_ruby.gemspec` Updated Rley dependency.

### Removed
- Class `SrlRuby::SrlToken` since it became completely redundant with `Token` class from Rley.
- Class `Acceptance::RuleFileToken` since it became completely redundant with `Token` class from Rley.

### Fixed
- Method `SrlRuby::Tokenizer#build_token` now instantiates a `Rley::Lexical::Token`
- Method `Acceptance::RuleFileTokenizer#build_token` now instantiates a `Rley::Lexical::Token`

## [0.4.3] - 2018-06-24
### Changed
- File `srl_ruby.gemspec` Updated Rley dependency.

## [0.4.2] - 2018-05-30
### Changed
- File `srl_ruby.gemspec` Updated Rley dependency.

## [0.4.1] - 2018-05-25
### Added
- Command-line option -p, --pattern SRL_PATT, that allows users to enter directly short one-liner SRL patterns.
  Thanks to `KarimGeiger` for suggesting me this enhancement.
- Directory `examples` with SRL examples from `README` and more...

### Changed
- File `README.md` updated with new text of command-line help.

## [0.4.0] - 2018-05-13
Version bump: SrlRuby has a command-line compiler `srl2ruby`

### Added
- File `bin/srl2ruby` A compiler that parses SRL expressions and transform them into regular Regexp.
- File `srl2ruby_cli_parser.rb` Implementation of the CLI of the `srl2ruby` compiler.
- Directory `templates` contains ERB templates that can be used to format `srl2ruby` output.

### Changed
- File `README.md` vastly expanded in order to cover `srl2ruby` compiler and a couple of SRL examples
- File `.rubocop.yml` enabled some of the complaining cops

### Removed
- File `srl_ruby` the previous binary of the gem is now replaced by `srl2ruby`.

### Fixed
- Method `Tokenizer#_next_token` failed to recognize digit or integer value immediately followed by a closing parenthesis ')'.
- Many classes lightly refactored in order to please Rubocop.


## [0.3.5] - 2018-04-29

### Added
- Support for SRL flags (i.e. 'case insensitive', 'multi line', 'all lazy'). 
  This marks a milestone: all SRL can be, in principle, parsed and compiled.

### Changed
- Methods `SrlRuby#load_file`, `SrlRuby#parse` now return a Regexp object initialized with options parsed from SRL
- New feature step defined in file `features/lib/step_definitions/srl_testing_steps.rb`
- File `.rubocop.yml` enabled some of the complaining cops


## [0.3.4] - 2018-04-20

### Fixed
- Method `Tokenizer#_next_token` failed to recognize digit or integer value immediately followed by a comma

## [0.3.3] - 2018-04-19
### Changed
- Binary `srl_ruby` now accepts a SRL filename as command-line argument. Command-line documentation updated.

### Fixed
- Method `Tokenizer#_next_token` failed to recognize single letter followed by a comma
- Binary `srl_ruby` now loads source files from correct filepath
- Module `SRL` is no more an ancestor of class `Multiplicity`.


## [0.3.2] - 2018-04-13
### Added
- `Cucumber` feature files are now part of the gem.
- Added `floatingpoint.feature` as test and demo for validating flating point numbers


## [0.3.1] - 2018-04-12
### Added
- Added `Cucumber` feature files both for additional testing and demo purposes.  
    Almost all examples from SRL websites are "featured".

### Changed
- All regex node classes support the `done!` method. It signals the end of aprsing, this is the right moment to finalize/tune 
    the parse tree or parse forest to build.

### Fixed
- Method `PolyadicExpression#done!` fixes an issue with lookbehind regex generation. The lookbehind expression precede the
  expression to be mathced/capture. In SRL, lookbehind syntax the expression to capture or match...
- Class `SrlRuby::ASTBuilder` improved support "from ... to ..." syntax: supports the case when boundaries are swapped.
  If last captured subexpression is a repetition, then it is made lazy (instead of greedy).

## [0.3.0] - 2018-04-04
Version bump: SrlRuby passes the complete official SRL test suite! 
### Changed
- File `acceptance/srl_test_suite_spec.rb`. 15 test files from official test suite are passing.

### Fixed
- Class `SrlRuby::ASTBuilder` Fixing the capture...until semantic.
  If last captured subexpression is a repetition, then it is made lazy (instead of greedy).


## [0.2.6] - 2018-04-03
SrlRuby passes 13 tests out of 15 from standard SRL test suite. 
### Changed
- Class `SrlRuby#Tokenizer` added CHAR_CLASS literal and keywords EITHER, NONE, EITHER,
- Grammar expanded to support 'CARRIAGE RETURN', 'VERTICAL TAB', 'WORD', 'NO WORD' expressions
- Class `SrlRuby::ASTBuilder` updates to reflect changes in the grammar.
- File `acceptance/srl_test_suite_spec.rb`. 13 test files from official test suite are passing.


## [0.2.5] - 2018-04-02
SrlRuby passes 12 tests out of 15 from standard SRL test suite. 
### Changed
- Class `SrlRuby#Tokenizer` added keywords CARRIAGE, RETURN, VERTICAL, WORD
- Grammar expanded to support 'CARRIAGE RETURN', 'VERTICAL TAB', 'WORD', 'NO WORD' expressions
- Class `SrlRuby::ASTBuilder` updates to reflect changes in the grammar.
- File `acceptance/srl_test_suite_spec.rb`. 12 test files from official test suite are passing.


## [0.2.4] - 2018-04-02
SrlRuby passes 10 tests out of 15 from standard SRL test suite. 
### Changed
- File `lib/srl_ruby/grammar.rb` grammar refactoring. Added support for new 'no digit' SRL expression.
- Class `SrlRuby::ASTBuilder` updates to reflect changes in the grammar.
- Class `Regex::Lookaround` refactored: now inherits from `Regex::MonadicExpression`
- File `spec/integration_spec` renamed to `spec/srl_ruby_spec.rb`, ssytematic use of the API of SrlRuby module.

### Fixed
- Method `SrlRuby::ASTBuilder#reduce_one_of` now escapes character inside a character class.

## [0.2.3] - 2018-03-15
### Fixed
- Fixed a number of Yard warnings.

## [0.2.2] - 2018-03-15
### Fixed
- Fixed rley version dependency

## [0.2.1] - 2018-03-15
SrlRuby passes 7 tests out of 15 from standard SRL test suite.  
### Changed
- File `acceptance/srl_test_suite_spec.rb`. More examples in spec file.
- File `ast_builder.rb` updates to reflect grammar changes.

### Fixed
- SRL grammar now accepts a comma before 'must end' anchor
- SRL grammar now accepts a comma before an option
- Class `Tokenizer#_next_token` now recognizes correctly escaped quotes within string literal
- File `ast_builder.rb` fixed anchor implementation.

## [0.2.0] - 2018-03-14
SrlRuby passes 3 tests out of 15 from standard SRL test suite.
### Added
- Added `spec/acceptance/support` directory. It contains test harness to use the .rule files from standard SRL test suite. 
- Added `acceptance/srl_test_suite_spec.rb`file. Spec file designed to standard SRL test suite. At this date, SrlRuby passes 3 tests out of 15 tests in total.

### Changed
- API Change. Method SrlRuby#parse returns a Regexp instance (previously it was a String)
- API Change. Method SrlRuby#load_file returns a Regexp instance (previously it was a String)

### Fixed
- SRL 'backslash' produces now 4 consecutive backslashes (required by the conversion into Regexp)

## [0.1.1] - 2018-03-10
### Changed
- Parse error location is now given in line number, column number position.
- Updated dependencies upon Rley parser.

## [0.1.0] - 2018-03-08
### Added
- Version bump. Added new API methods `SrlRuby#load_file` and `SrlRuby#parse`

### Changed
- File `README.md` vastly improved with examples and usage snippet.

## [0.0.2] - 2018-03-07
### Added
- File `CHANGELOG.md`. This file. Adopting `keepachangelog.com` recommended format.
- File `appveyor.yml`. Configuration file for the AppVeyor CI (automated builds on Windows)

### Changed
- File `README.md` added badges (Appveyor build status, Gem version, license)

## [0.0.1] - 2018-03-06
### Added
- Initial working Github commit

## Unreleased
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

