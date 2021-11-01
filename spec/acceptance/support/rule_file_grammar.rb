# frozen_string_literal: true

# File: rule_file_grammar.rb
require 'rley' # Load the Rley gem

# Grammar for Test-Rule files
# [File format](https://github.com/SimpleRegex/Test-Rules/blob/master/README.md)
########################################
builder = Rley::grammar_builder do
  # Punctuation
  add_terminals('COLON', 'DASH')

  # Keywords
  add_terminals('CAPTURE', 'FOR')
  add_terminals('MATCH', 'NO', 'SRL')

  # Literals
  add_terminals('INTEGER', 'STRING_LIT')
  add_terminals('IDENTIFIER', 'SRL_SOURCE')

  rule('rule_file' => 'srl_heading srl_test+').tag 'start_rule'
  rule('srl_heading' => 'SRL SRL_SOURCE').tag 'srl_source'
  rule('srl_test' => 'atomic_test').tag 'single_atomic_test'
  rule('srl_test' => 'compound_test').tag 'single_compound_test'
  rule('atomic_test' => 'match_test').tag 'atomic_match'
  rule('atomic_test' => 'no_match_test').tag 'atomic_no_match'
  rule('compound_test' => 'capture_test').tag 'compound_capture'
  rule('match_test' => 'MATCH STRING_LIT').tag 'match_string'
  rule('no_match_test' => 'NO MATCH STRING_LIT').tag 'no_match_string'
  rule('capture_test' => 'capture_heading capture_expectation+').tag 'capture_test'
  rule('capture_heading' => 'CAPTURE FOR STRING_LIT COLON').tag 'capture_string'
  rule('capture_expectation' => 'DASH INTEGER COLON capture_variable COLON STRING_LIT').tag 'capture_expectation'
  rule('capture_variable' => 'INTEGER').tag 'var_integer'
  rule('capture_variable' => 'IDENTIFIER').tag 'var_identifier'
end

# And now build the grammar...
RuleFileGrammar = builder.grammar
