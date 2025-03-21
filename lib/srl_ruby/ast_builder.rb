# frozen_string_literal: true

require 'stringio'
require_relative 'regex_repr'

module SrlRuby
  # The purpose of a ASTBuilder is to build piece by piece an AST
  # (Abstract Syntax Tree) from a sequence of input tokens and
  # visit events produced by walking over a GFGParsing object.
  # Uses the Builder GoF pattern.
  # The Builder pattern creates a complex object
  # (say, a parse tree) from simpler objects (terminal and non-terminal
  # nodes) and using a step by step approach.
  class ASTBuilder < Rley::ParseRep::ASTBaseBuilder
    # @return [Hash]
    Terminal2NodeClass = {}.freeze

    # @return [Array<Symbol>] Options for the regular expression
    attr_reader :options

    # Create a new AST builder instance.
    # @param theTokens [Array<Token>] The sequence of input tokens.
    def initialize(theTokens)
      super
      @options = []
    end

    # Notification that the parse tree construction is complete.
    # @return [void]
    def done!
      apply_options
      super
    end

    protected

    # @return [Hash]
    def terminal2node
      Terminal2NodeClass
    end

    # @return [void]
    def apply_options
      tree_root = result.root
      regexp_opts = []
      options.each do |opt|
        if opt == :ALL_LAZY
          tree_root.lazy!
        else
          regexp_opts << opt
        end
      end
      return if regexp_opts.empty?

      new_root = Regex::MatchOption.new(tree_root, regexp_opts)
      result.instance_variable_set(:@root, new_root)
    end

    # Overriding method.
    # Factory method for creating a node object for the given
    # input token.
    # @param _production [Rley::Syntax::Production]
    # @param _terminal [Rley::Syntax::Terminal] Terminal symbol associated with the token
    # @param aTokenPosition [Integer] Position of token in the input stream
    # @param aToken [Rley::Lexical::Token] The input token
    def new_leaf_node(_production, _terminal, aTokenPosition, aToken)
      Rley::PTree::TerminalNode.new(aToken, aTokenPosition)
    end

    # @param lowerBound [Integer]
    # @param upperBound [Integer, Symbol]
    # @return [Regex::Multiplicity]
    def multiplicity(lowerBound, upperBound)
      Regex::Multiplicity.new(lowerBound, upperBound, :greedy)
    end

    # rubocop: disable Style/OptionalBooleanParameter

    # @param aString [String]
    # @param [Array<Regex::Character>, Regex::Concatenation, Regex::Character]
    def string_literal(aString, to_escape = true)
      if aString.size > 1
        chars = []
        aString.each_char do |ch|
          if to_escape && Regex::Character::MetaChars.include?(ch)
            chars << Regex::Character.new('\\')
          end
          chars << Regex::Character.new(ch)
        end
        result = Regex::Concatenation.new(*chars)
      elsif to_escape && Regex::Character::MetaChars.include?(aString)
        backslash = Regex::Character.new('\\')
        a_string = Regex::Character.new(aString)
        result = Regex::Concatenation.new(backslash, a_string)
      else
        result = Regex::Character.new(aString)
      end

      result
    end
    # rubocop: enable Style/OptionalBooleanParameter

    # @param lowerBound [Integer]
    # @param upperBound [Integer]
    def char_range(lowerBound, upperBound)
      lower = Regex::Character.new(lowerBound)
      upper = Regex::Character.new(upperBound)
      Regex::CharRange.new(lower, upper)
    end

    def char_class(toNegate, *theChildren)
      Regex::CharClass.new(toNegate, *theChildren)
    end

    def char_shorthand(shortName)
      Regex::CharShorthand.new(shortName)
    end

    def wildcard
      Regex::Wildcard.new
    end

    def repetition(expressionToRepeat, aMultiplicity)
      Regex::Repetition.new(expressionToRepeat, aMultiplicity)
    end

    def begin_anchor
      Regex::Anchor.new('^')
    end

    # rule('expression' => 'pattern (flags)?').tag 'flagged_expr'
    def reduce_flagged_expr(_production, aRange, theTokens, theChildren)
      @options = theChildren[1].first if theChildren[1]
      return_first_child(aRange, theTokens, theChildren)
    end

    # rule('pattern' => 'subpattern (separator sub_pattern)*').tag 'pattern_sequence'
    def reduce_pattern_sequence(_production, _range, _tokens, theChildren)
      return theChildren[0] if theChildren[1].empty?

      successors = theChildren[1].map { |pair| pair[1] }
      if successors[0].kind_of?(Regex::Lookaround) && successors[0].dir == :behind
        Regex::Concatenation.new(successors.shift, theChildren[0], *successors)
      else
        Regex::Concatenation.new(theChildren[0], *successors)
      end
    end

    # rule('sub_pattern' => 'assertion').tag 'assertion_sub_pattern'
    def reduce_assertion_sub_pattern(_production, aRange, theTokens, theChildren)
      return_first_child(aRange, theTokens, theChildren)
    end

    # rule('flags' => '(separator single_flag)+').tag 'flag_sequence'
    def reduce_flag_sequence(_production, _range, _tokens, theChildren)
      theChildren[0].map { |(_, flag)| flag }
    end

    # rule('single_flag' => %w[CASE INSENSITIVE]).tag 'case_insensitive'
    def reduce_case_insensitive(_production, _range, _tokens, _children)
      Regexp::IGNORECASE
    end

    # rule('single_flag' => %w[MULTI LINE]).tag 'multi_line'
    def reduce_multi_line(_production, _range, _tokens, _children)
      Regexp::MULTILINE
    end

    # rule('single_flag' => %w[ALL LAZY]).tag 'all_lazy'
    def reduce_all_lazy(_production, _range, _tokens, _children)
      :ALL_LAZY
    end

    # rule('quantifiable' => 'begin_anchor? anchorable end_anchor?')
    def reduce_quantifiable(_production, _range, _tokens, theChildren)
      Regex::Concatenation.new(*theChildren.flatten.compact)
    end

    # rule 'begin_anchor' => %w[STARTS WITH]
    def reduce_starts_with(_production, _range, _tokens, _children)
      begin_anchor
    end

    # rule 'begin_anchor' => %w[BEGIN WITH]
    def reduce_begin_with(_production, _range, _tokens, _children)
      begin_anchor
    end

    # rule('end_anchor' => %w[separator MUST END]).tag 'end_anchor'
    def reduce_end_anchor(_production, _range, _tokens, _children)
      Regex::Anchor.new('$')
    end

    # rule('assertion' => 'IF NOT? FOLLOWED BY assertable')
    def reduce_if_followed(_production, _range, _tokens, theChildren)
      polarity = theChildren[1] ? :negative : :positive
      Regex::Lookaround.new(theChildren.last, :ahead, polarity)
    end

    # rule('assertion' => 'IF NOT? ALREADY HAD assertable')
    def reduce_if_had(_production, _range, _tokens, theChildren)
      polarity = theChildren[1] ? :negative : :positive
      Regex::Lookaround.new(theChildren.last, :behind, polarity)
    end

    # rule('assertable' => 'term quantifier?').tag 'assertable'
    def reduce_assertable(_production, _range, _tokens, theChildren)
      (term, quantifier) = theChildren.flatten
      quantifier ? repetition(term, quantifier) : term
    end

    # rule('letter_range' => %w[LETTER FROM LETTER_LIT TO LETTER_LIT]).tag 'lowercase_from_to'
    def reduce_lowercase_from_to(_production, _range, _tokens, theChildren)
      raw_range = [theChildren[2].token.lexeme, theChildren[4].token.lexeme]
      range_sorted = raw_range.sort
      ch_range = char_range(range_sorted[0], range_sorted[1])
      char_class(false, ch_range)
    end

    # rule('letter_range' => %w[UPPERCASE LETTER FROM LETTER_LIT TO LETTER_LIT]).tag 'uppercase_from_to'
    def reduce_uppercase_from_to(_production, _range, _tokens, theChildren)
      raw_range = [theChildren[3].token.lexeme, theChildren[5].token.lexeme]
      range_sorted = raw_range.sort
      ch_range = char_range(range_sorted[0], range_sorted[1])
      char_class(false, ch_range)
    end

    # rule('letter_range' => 'LETTER').tag 'any_lowercase'
    def reduce_any_lowercase(_production, _range, _tokens, _children)
      ch_range = char_range('a', 'z')
      char_class(false, ch_range)
    end

    # rule('letter_range' => %w[UPPERCASE LETTER]).tag 'any_uppercase'
    def reduce_any_uppercase(_production, _range, _tokens, _children)
      ch_range = char_range('A', 'Z')
      char_class(false, ch_range)
    end

    # rule('digit_range' => %w[digit_or_number FROM DIGIT_LIT TO DIGIT_LIT]).tag 'digits_from_to'
    def reduce_digits_from_to(_production, _range, _tokens, theChildren)
      raw_range = [theChildren[2].token.lexeme, theChildren[4].token.lexeme]
      range_sorted = raw_range.map(&:to_i).sort
      ch_range = char_range(range_sorted[0].to_s, range_sorted[1].to_s)
      char_class(false, ch_range)
    end

    # rule('character_class' => %w[ANY CHARACTER]).tag 'any_character'
    def reduce_any_character(_production, _range, _tokens, _children)
      char_shorthand('w')
    end

    # rule('character_class' => %w[NO CHARACTER]).tag 'no_character'
    def reduce_no_character(_production, _range, _tokens, _children)
      char_shorthand('W')
    end

    # rule('character_class' => 'digit_or_number').tag 'digit'
    def reduce_digit(_production, _range, _tokens, _children)
      char_shorthand('d')
    end

    # rule('character_class' => %w[NO DIGIT]).tag 'non_digit'
    def reduce_non_digit(_production, _range, _tokens, _children)
      char_shorthand('D')
    end

    # rule('character_class' => 'WHITESPACE').tag 'whitespace'
    def reduce_whitespace(_production, _range, _tokens, _children)
      char_shorthand('s')
    end

    # rule('character_class' => %w[NO WHITESPACE]).tag 'no_whitespace'
    def reduce_no_whitespace(_production, _range, _tokens, _children)
      char_shorthand('S')
    end

    # rule('character_class' => 'ANYTHING').tag 'anything'
    def reduce_anything(_production, _range, _tokens, _children)
      wildcard
    end

    # rule('character_class' => %w[ONE OF STRING_LIT]).tag 'one_of'
    def reduce_one_of(_production, _range, _tokens, theChildren)
      raw_literal = theChildren[-1].token.lexeme.dup
      alternatives = raw_literal.chars.map do |ch|
        if Regex::Character::MetaCharsInClass.include?(ch)
          chars = [Regex::Character.new('\\'), Regex::Character.new(ch)]
          Regex::Concatenation.new(*chars)
        else
          Regex::Character.new(ch)
        end
      end

      # TODO check other implementations
      Regex::CharClass.new(false, *alternatives)
    end

    # rule('character_class' => %w[NONE OF STRING_LIT]).tag 'none_of'
    def reduce_none_of(_production, _range, _tokens, theChildren)
      raw_literal = theChildren[-1].token.lexeme.dup
      chars = raw_literal.chars.map do |ch|
        Regex::Character.new(ch)
      end
      Regex::CharClass.new(true, *chars)
    end

    # rule('special_char' => 'TAB').tag 'tab'
    def reduce_tab(_production, _range, _tokens, _children)
      Regex::Character.new('\t')
    end

    # rule('special_char' => ' VERTICAL TAB').tag 'vtab'
    def reduce_vtab(_production, _range, _tokens, _children)
      Regex::Character.new('\v')
    end

    # rule('special_char' => 'BACKSLASH').tag 'backslash'
    def reduce_backslash(_production, _range, _tokens, _children)
      # Double the backslash (because of escaping)
      string_literal('\\', true)
    end

    # rule('special_char' => %w[NEW LINE]).tag 'new_line'
    def reduce_new_line(_production, _range, _tokens, _children)
      # TODO: control portability
      Regex::Character.new('\n')
    end

    # rule('special_char' => %w[CARRIAGE RETURN]).tag 'carriage_return'
    def reduce_carriage_return(_production, _range, _tokens, _children)
      Regex::Character.new('\r')
    end

    # rule('special_char' => %w[WORD]).tag 'word'
    def reduce_word(_production, _range, _tokens, _children)
      Regex::Anchor.new('\b')
    end

    # rule('special_char' => %w[NO WORD]).tag 'no word'
    def reduce_no_word(_production, _range, _tokens, _children)
      Regex::Anchor.new('\B')
    end

    # rule('literal' => %w[LITERALLY STRING_LIT]).tag 'literally'
    def reduce_literally(_production, _range, _tokens, theChildren)
      # What if literal is empty?...

      raw_literal = theChildren[-1].token.lexeme.dup
      string_literal(raw_literal)
    end

    # rule('raw' => %w[RAW STRING_LIT]).tag 'raw_literal'
    def reduce_raw_literal(_production, _range, _tokens, theChildren)
      raw_literal = theChildren[-1].token.lexeme.dup
      Regex::RawExpression.new(raw_literal)
    end

    # rule('alternation' => %w[ANY OF LPAREN alternatives RPAREN]).tag 'any_of'
    def reduce_any_of(_production, _range, _tokens, theChildren)
      first_alternative = theChildren[3].first
      result = nil

      # Ugly: in SRL, comma is a dummy separator except in any of construct...
      if theChildren[3].size == 1 && first_alternative.kind_of?(Regex::Concatenation)
        result = Regex::Alternation.new(*first_alternative.children)
      else
        result = Regex::Alternation.new(*theChildren[3])
      end

      result
    end

    # rule('alternatives' => %w[alternatives separator quantifiable]).tag 'alternative_list'
    def reduce_alternative_list(_production, _range, _tokens, theChildren)
      theChildren[0] << theChildren[-1]
    end

    # rule('alternatives' => 'quantifiable').tag 'simple_alternative'
    def reduce_simple_alternative(_production, _range, _tokens, theChildren)
      [theChildren.last]
    end

    # rule('grouping' => %w[LPAREN pattern RPAREN]).tag 'grouping_parenthenses'
    def reduce_grouping_parenthenses(_production, _range, _tokens, theChildren)
      Regex::NonCapturingGroup.new(theChildren[1])
    end

    # If the rightmost (sub)expression is a repetition, then make it lazy
    def make_last_repetition_lazy(anExpr)
      sub_expr = anExpr
      loop do
        if sub_expr.is_a?(Regex::Repetition)
            # Make repetition lazy
            cardinality = sub_expr.multiplicity
            cardinality.instance_variable_set(:@policy, :lazy)
            break
        elsif sub_expr.kind_of?(Regex::PolyadicExpression)
          sub_expr = sub_expr.children.last
        elsif sub_expr.kind_of?(Regex::MonadicExpression)
          sub_expr = sub_expr.child
        elsif sub_expr.kind_of?(Regex::AtomicExpression)
          break
        end
      end
    end

    # rule('capturing_group' => 'CAPTURE assertable (UNTIL assertable)?').tag
    # 'capture'
    def reduce_capture(_production, _range, _tokens, theChildren)
      return Regex::CapturingGroup.new(theChildren[1]) unless theChildren[2]

      # Until semantic requires that the last pattern in capture to be lazy
      make_last_repetition_lazy(theChildren[1])

      group = Regex::CapturingGroup.new(theChildren[1])
      (_, until_expr) = theChildren[2]
      Regex::Concatenation.new(group, until_expr)
    end

    # rule('capturing_group' => 'CAPTURE assertable AS var_name (UNTIL assertable)?').tag
    # 'named_capture'
    def reduce_named_capture(_production, _range, _tokens, theChildren)
      name = theChildren[3].token.lexeme.dup
      return Regex::CapturingGroup.new(theChildren[1], name) unless theChildren[4]

      # Until semantic requires that the last pattern in capture to be lazy
      make_last_repetition_lazy(theChildren[1])
      group = Regex::CapturingGroup.new(theChildren[1], name)
      (_, until_expr) = theChildren[4]
      Regex::Concatenation.new(group, until_expr)
    end

    # rule('quantifier' => 'ONCE').tag 'once'
    def reduce_once(_production, _range, _tokens, _children)
      multiplicity(1, 1)
    end

    # rule('quantifier' => 'TWICE').tag 'twice'
    def reduce_twice(_production, _range, _tokens, _children)
      multiplicity(2, 2)
    end

    # rule('quantifier' => %w[EXACTLY count TIMES]).tag 'exactly'
    def reduce_exactly(_production, _range, _tokens, theChildren)
      count = theChildren[1].token.lexeme.to_i
      multiplicity(count, count)
    end

    # rule('quantifier' => 'BETWEEN count AND count times_suffix').tag
    #   'between_and'
    def reduce_between_and(_production, _range, _tokens, theChildren)
      lower = theChildren[1].token.lexeme.to_i
      upper = theChildren[3].token.lexeme.to_i
      multiplicity(lower, upper)
    end

    # rule('quantifier' => 'OPTIONAL').tag 'optional'
    def reduce_optional(_production, _range, _tokens, _children)
      multiplicity(0, 1)
    end

    # rule('quantifier' => %w[ONCE OR MORE]).tag 'once_or_more'
    def reduce_once_or_more(_production, _range, _tokens, _children)
      multiplicity(1, :more)
    end

    # rule('quantifier' => %w[NEVER OR MORE]).tag 'never_or_more'
    def reduce_never_or_more(_production, _range, _tokens, _children)
      multiplicity(0, :more)
    end

    # rule('quantifier' => %w[AT LEAST count TIMES]).tag 'at_least'
    def reduce_at_least(_production, _range, _tokens, theChildren)
      count = theChildren[2].token.lexeme.to_i
      multiplicity(count, :more)
    end
  end # class
end # module
# End of file
