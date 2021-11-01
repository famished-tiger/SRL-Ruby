# frozen_string_literal: true

# Grammar for SRL (Simple Regex Language)
require 'rley' # Load the gem
module SrlRuby
  ########################################
  # SRL grammar
  builder = Rley::grammar_builder do
    # Separators...
    add_terminals('LPAREN', 'RPAREN', 'COMMA')

    # Literal values...
    add_terminals('DIGIT_LIT', 'INTEGER', 'LETTER_LIT', 'CHAR_CLASS')
    add_terminals('LITERALLY', 'STRING_LIT', 'IDENTIFIER')

    # Keywords...
    add_terminals('BEGIN', 'STARTS', 'WITH')
    add_terminals('MUST', 'END', 'RAW')
    add_terminals('UPPERCASE', 'LETTER', 'FROM', 'TO')
    add_terminals('DIGIT', 'NUMBER', 'ANY', 'EITHER', 'NO')
    add_terminals('CHARACTER', 'WHITESPACE', 'ANYTHING')
    add_terminals('TAB', 'BACKSLASH', 'NEW', 'LINE', 'WORD')
    add_terminals('CARRIAGE', 'RETURN', 'VERTICAL', 'OF', 'NONE')
    add_terminals('ONE', 'EXACTLY', 'TIMES', 'ONCE', 'TWICE')
    add_terminals('BETWEEN', 'AND', 'OPTIONAL', 'OR')
    add_terminals('MORE', 'NEVER', 'AT', 'LEAST')
    add_terminals('IF', 'FOLLOWED', 'BY', 'NOT')
    add_terminals('ALREADY', 'HAD')
    add_terminals('CAPTURE', 'AS', 'UNTIL')
    add_terminals('CASE', 'INSENSITIVE', 'MULTI', 'ALL')
    add_terminals('LAZY')

    # Grammar rules...
    rule('srl' => 'expression').tag 'start_rule'
    rule('expression' => 'pattern flags?').tag 'flagged_expr'
    rule('pattern' => 'sub_pattern (separator sub_pattern)*').tag 'pattern_sequence'
    rule('sub_pattern' => 'quantifiable').tag 'quantifiable_sub_pattern'
    rule('sub_pattern' => 'assertion').tag 'assertion_sub_pattern'
    rule('separator' => 'COMMA?')
    rule('flags' => '(separator single_flag)+').tag 'flag_sequence'
    rule('single_flag' => 'CASE INSENSITIVE').tag 'case_insensitive'
    rule('single_flag' => 'MULTI LINE').tag 'multi_line'
    rule('single_flag' => 'ALL LAZY').tag 'all_lazy'
    rule('quantifiable' => 'begin_anchor? anchorable end_anchor?').tag 'quantifiable'
    rule('begin_anchor' => 'STARTS WITH').tag 'starts_with'
    rule('begin_anchor' => 'BEGIN WITH').tag 'begin_with'
    rule('end_anchor' => 'separator MUST END').tag 'end_anchor'
    rule('anchorable' => 'assertable').tag 'simple_anchorable'
    rule('assertion' => 'IF NOT? FOLLOWED BY assertable').tag 'if_followed'
    rule('assertion' => 'IF NOT? ALREADY HAD assertable').tag 'if_had'
    rule('assertable' => 'term quantifier?').tag 'assertable'
    rule('term' => 'atom').tag 'atom_term'
    rule('term' => 'alternation').tag 'alternation_term'
    rule('term' => 'grouping').tag 'grouping_term'
    rule('term' => 'capturing_group').tag 'capturing_group_atom'
    rule('atom' => 'letter_range').tag 'letter_range_atom'
    rule('atom' => 'digit_range').tag 'digit_range_atom'
    rule('atom' => 'character_class').tag 'character_class_atom'
    rule('atom' => 'special_char').tag 'special_char_atom'
    rule('atom' => 'literal').tag 'literal_atom'
    rule('atom' => 'raw').tag 'raw_atom'
    rule('letter_range' => 'LETTER FROM LETTER_LIT TO LETTER_LIT').tag 'lowercase_from_to'
    rule('letter_range' => 'UPPERCASE LETTER FROM LETTER_LIT TO LETTER_LIT').tag 'uppercase_from_to'
    rule('letter_range' => 'LETTER').tag 'any_lowercase'
    rule('letter_range' => 'UPPERCASE LETTER').tag 'any_uppercase'
    rule('digit_range' => 'digit_or_number FROM DIGIT_LIT TO DIGIT_LIT').tag 'digits_from_to'
    rule('character_class' => 'ANY CHARACTER').tag 'any_character'
    rule('character_class' => 'NO CHARACTER').tag 'no_character'
    rule('character_class' => 'digit_or_number').tag 'digit'
    rule('character_class' => 'NO DIGIT').tag 'non_digit'
    rule('character_class' => 'WHITESPACE').tag 'whitespace'
    rule('character_class' => 'NO WHITESPACE').tag 'no_whitespace'
    rule('character_class' => 'ANYTHING').tag 'anything'
    rule('character_class' => 'ONE OF cclass').tag 'one_of'
    rule('character_class' => 'NONE OF cclass').tag 'none_of'
    rule('cclass' => 'STRING_LIT').tag 'quoted_cclass' # Preferred syntax
    rule('cclass' => 'INTEGER').tag 'digits_cclass'
    rule('cclass' => 'IDENTIFIER').tag 'identifier_cclass'
    rule('cclass' => 'CHAR_CLASS').tag 'unquoted_cclass'
    rule('special_char' => 'TAB').tag 'tab'
    rule('special_char' => 'VERTICAL TAB').tag 'vtab'
    rule('special_char' => 'BACKSLASH').tag 'backslash'
    rule('special_char' => 'NEW LINE').tag 'new_line'
    rule('special_char' => 'CARRIAGE RETURN').tag 'carriage_return'
    rule('special_char' => 'WORD').tag 'word'
    rule('special_char' => 'NO WORD').tag 'no_word'
    rule('literal' => 'LITERALLY STRING_LIT').tag 'literally'
    rule('raw' => 'RAW STRING_LIT').tag 'raw_literal'
    rule('alternation' => 'any_or_either OF LPAREN alternatives RPAREN').tag 'any_of'
    rule('alternatives' => 'alternatives separator quantifiable').tag 'alternative_list'
    rule('alternatives' => 'quantifiable').tag 'simple_alternative'
    rule('any_or_either' => 'ANY').tag 'any_keyword'
    rule('any_or_either' => 'EITHER').tag 'either_keyword'
    rule('grouping' => 'LPAREN pattern RPAREN').tag 'grouping_parenthenses'
    rule('capturing_group' => 'CAPTURE assertable (UNTIL assertable)?').tag 'capture'
    rule('capturing_group' => 'CAPTURE assertable AS var_name (UNTIL assertable)?').tag 'named_capture'
    rule('var_name' => 'STRING_LIT').tag 'var_name'
    rule('var_name' => 'IDENTIFIER').tag 'var_ident' # capture name not enclosed between quotes
    rule('quantifier' => 'ONCE').tag 'once'
    rule('quantifier' => 'TWICE').tag 'twice'
    rule('quantifier' => 'EXACTLY count TIMES').tag 'exactly'
    rule('quantifier' => 'BETWEEN count AND count TIMES?').tag 'between_and'
    rule('quantifier' => 'OPTIONAL').tag 'optional'
    rule('quantifier' => 'ONCE OR MORE').tag 'once_or_more'
    rule('quantifier' => 'NEVER OR MORE').tag 'never_or_more'
    rule('quantifier' => 'AT LEAST count TIMES').tag 'at_least'
    rule('digit_or_number' => 'DIGIT').tag 'digit_keyword'
    rule('digit_or_number' => 'NUMBER').tag 'number_keyword'
    rule('count' => 'DIGIT_LIT').tag 'single_digit'
    rule('count' => 'INTEGER').tag 'integer_count'
  end

  # And now build the grammar and make it accessible via a global constant
  # [Rley::Syntax::Grammar]
  Grammar = builder.grammar
end # module
