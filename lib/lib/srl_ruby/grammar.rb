# frozen_string_literal: true

# Grammar for SRL (Simple Regex Language)
require 'rley' # Load the gem
module SrlRuby
  ########################################
  # SRL grammar
  builder = Rley::Syntax::GrammarBuilder.new do
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
    rule('srl' => 'expression').as 'start_rule'
    rule('expression' => %w[pattern flags]).as 'flagged_expr'
    rule('expression' => 'pattern').as 'simple_expr'
    rule('pattern' => %w[pattern separator sub_pattern]).as 'pattern_sequence'
    rule('pattern' => 'sub_pattern').as 'basic_pattern'
    rule('sub_pattern' => 'quantifiable').as 'quantifiable_sub_pattern'
    rule('sub_pattern' => 'assertion').as 'assertion_sub_pattern'
    rule('separator' => 'COMMA').as 'comma_separator'
    rule('separator' => []).as 'void_separator'
    rule('flags' => %w[flags separator single_flag]).as 'flag_sequence'
    rule('flags' => %w[separator single_flag]).as 'flag_simple'
    rule('single_flag' => %w[CASE INSENSITIVE]).as 'case_insensitive'
    rule('single_flag' => %w[MULTI LINE]).as 'multi_line'
    rule('single_flag' => %w[ALL LAZY]).as 'all_lazy'
    rule('quantifiable' => %w[begin_anchor anchorable end_anchor]).as 'pinned_quantifiable'
    rule('quantifiable' => %w[begin_anchor anchorable]).as 'begin_anchor_quantifiable'
    rule('quantifiable' => %w[anchorable end_anchor]).as 'end_anchor_quantifiable'
    rule('quantifiable' => 'anchorable').as 'simple_quantifiable'
    rule('begin_anchor' => %w[STARTS WITH]).as 'starts_with'
    rule('begin_anchor' => %w[BEGIN WITH]).as 'begin_with'
    rule('end_anchor' => %w[separator MUST END]).as 'end_anchor'
    rule('anchorable' => 'assertable').as 'simple_anchorable'
    rule('assertion' => %w[IF FOLLOWED BY assertable]).as 'if_followed'
    rule('assertion' => %w[IF NOT FOLLOWED BY assertable]).as 'if_not_followed'
    rule('assertion' => %w[IF ALREADY HAD assertable]).as 'if_had'
    rule('assertion' => %w[IF NOT ALREADY HAD assertable]).as 'if_not_had'
    rule('assertable' => 'term').as 'simple_assertable'
    rule('assertable' => %w[term quantifier]).as 'quantified_assertable'
    rule('term' => 'atom').as 'atom_term'
    rule('term' => 'alternation').as 'alternation_term'
    rule('term' => 'grouping').as 'grouping_term'
    rule('term' => 'capturing_group').as 'capturing_group_atom'
    rule('atom' => 'letter_range').as 'letter_range_atom'
    rule('atom' => 'digit_range').as 'digit_range_atom'
    rule('atom' => 'character_class').as 'character_class_atom'
    rule('atom' => 'special_char').as 'special_char_atom'
    rule('atom' => 'literal').as 'literal_atom'
    rule('atom' => 'raw').as 'raw_atom'
    rule('letter_range' => %w[LETTER FROM LETTER_LIT TO LETTER_LIT]).as 'lowercase_from_to'
    rule('letter_range' => %w[UPPERCASE LETTER FROM LETTER_LIT TO LETTER_LIT]).as 'uppercase_from_to'
    rule('letter_range' => 'LETTER').as 'any_lowercase'
    rule('letter_range' => %w[UPPERCASE LETTER]).as 'any_uppercase'
    rule('digit_range' => %w[digit_or_number FROM DIGIT_LIT TO DIGIT_LIT]).as 'digits_from_to'
    rule('character_class' => %w[ANY CHARACTER]).as 'any_character'
    rule('character_class' => %w[NO CHARACTER]).as 'no_character'
    rule('character_class' => 'digit_or_number').as 'digit'
    rule('character_class' => %w[NO DIGIT]).as 'non_digit'
    rule('character_class' => 'WHITESPACE').as 'whitespace'
    rule('character_class' => %w[NO WHITESPACE]).as 'no_whitespace'
    rule('character_class' => 'ANYTHING').as 'anything'
    rule('character_class' => %w[ONE OF cclass]).as 'one_of'
    rule('character_class' => %w[NONE OF cclass]).as 'none_of'
    rule('cclass' => 'STRING_LIT').as 'quoted_cclass' # Preferred syntax
    rule('cclass' => 'INTEGER').as 'digits_cclass'
    rule('cclass' => 'IDENTIFIER').as 'identifier_cclass'
    rule('cclass' => 'CHAR_CLASS').as 'unquoted_cclass'
    rule('special_char' => 'TAB').as 'tab'
    rule('special_char' => 'VERTICAL TAB').as 'vtab'
    rule('special_char' => 'BACKSLASH').as 'backslash'
    rule('special_char' => %w[NEW LINE]).as 'new_line'
    rule('special_char' => %w[CARRIAGE RETURN]).as 'carriage_return'
    rule('special_char' => %w[WORD]).as 'word'
    rule('special_char' => %w[NO WORD]).as 'no_word'
    rule('literal' => %w[LITERALLY STRING_LIT]).as 'literally'
    rule('raw' => 'RAW STRING_LIT').as 'raw_literal'
    rule('alternation' => %w[any_or_either OF LPAREN alternatives RPAREN]).as 'any_of'
    rule('alternatives' => %w[alternatives separator quantifiable]).as 'alternative_list'
    rule('alternatives' => 'quantifiable').as 'simple_alternative'
    rule('any_or_either' => 'ANY').as 'any_keyword'
    rule('any_or_either' => 'EITHER').as 'either_keyword'
    rule('grouping' => %w[LPAREN pattern RPAREN]).as 'grouping_parenthenses'
    rule('capturing_group' => %w[CAPTURE assertable]).as 'capture'
    rule('capturing_group' => %w[CAPTURE assertable UNTIL assertable]).as 'capture_until'
    rule('capturing_group' => %w[CAPTURE assertable AS var_name]).as 'named_capture'
    rule('capturing_group' => %w[CAPTURE assertable AS var_name UNTIL assertable]).as 'named_capture_until'
    rule('var_name' => 'STRING_LIT').as 'var_name'
    rule('var_name' => 'IDENTIFIER').as 'var_ident' # capture name not enclosed between quotes
    rule('quantifier' => 'ONCE').as 'once'
    rule('quantifier' => 'TWICE').as 'twice'
    rule('quantifier' => %w[EXACTLY count TIMES]).as 'exactly'
    rule('quantifier' => %w[BETWEEN count AND count times_suffix]).as 'between_and'
    rule('quantifier' => 'OPTIONAL').as 'optional'
    rule('quantifier' => %w[ONCE OR MORE]).as 'once_or_more'
    rule('quantifier' => %w[NEVER OR MORE]).as 'never_or_more'
    rule('quantifier' => %w[AT LEAST count TIMES]).as 'at_least'
    rule('digit_or_number' => 'DIGIT').as 'digit_keyword'
    rule('digit_or_number' => 'NUMBER').as 'number_keyword'
    rule('count' => 'DIGIT_LIT').as 'single_digit'
    rule('count' => 'INTEGER').as 'integer_count'
    rule('times_suffix' => 'TIMES').as 'times_keyword'
    rule('times_suffix' => []).as 'times_dropped'
  end

  # And now build the grammar and make it accessible via a global constant
  # [Rley::Syntax::Grammar]
  Grammar = builder.grammar
end # module
