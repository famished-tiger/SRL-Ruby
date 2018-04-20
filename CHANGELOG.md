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

