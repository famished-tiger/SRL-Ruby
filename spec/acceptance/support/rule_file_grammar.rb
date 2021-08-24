# frozen_string_literal: true

# File: rule_file_grammar.rb
require 'rley' # Load the Rley gem

# Grammar for Test-Rule files
# [File format](https://github.com/SimpleRegex/Test-Rules/blob/master/README.md)
########################################
# Define a grammar for basic arithmetical expressions
builder = Rley::Notation::GrammarBuilder.new do
  # Punctuation
  add_terminals('COLON', 'DASH')

  # Keywords
  add_terminals('CAPTURE', 'FOR')
  add_terminals('MATCH', 'NO', 'SRL')

  # Literals
  add_terminals('INTEGER', 'STRING_LIT')
  add_terminals('IDENTIFIER', 'SRL_SOURCE')

  rule('rule_file' => 'srl_heading srl_tests').as 'start_rule'
  rule('srl_heading' => 'SRL SRL_SOURCE').as 'srl_source'
  rule('srl_tests' => 'srl_tests single_test').as 'test_list'
  rule('srl_tests' => 'single_test').as 'one_test'
  rule('single_test' => 'atomic_test').as 'single_atomic_test'
  rule('single_test' => 'compound_test').as 'single_compound_test'
  rule('atomic_test' => 'match_test').as 'atomic_match'
  rule('atomic_test' => 'no_match_test').as 'atomic_no_match'
  rule('compound_test' => 'capture_test').as 'compound_capture'
  rule('match_test' => 'MATCH STRING_LIT').as 'match_string'
  rule('no_match_test' => 'NO MATCH STRING_LIT').as 'no_match_string'
  rule('capture_test' => 'capture_heading capture_expectations').as 'capture_test'
  rule('capture_heading' => 'CAPTURE FOR STRING_LIT COLON').as 'capture_string'
  rule('capture_expectations' => 'capture_expectations single_expectation').as 'assertion_list'
  rule('capture_expectations' => 'single_expectation').as 'one_expectation'
  rule('single_expectation' => 'DASH INTEGER COLON capture_variable COLON STRING_LIT').as 'capture_expectation'
  rule('capture_variable' => 'INTEGER').as 'var_integer'
  rule('capture_variable' => 'IDENTIFIER').as 'var_identifier'
end

# And now build the grammar...
RuleFileGrammar = builder.grammar
