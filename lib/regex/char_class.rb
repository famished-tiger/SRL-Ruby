# frozen_string_literal: true

# File: char_class.rb

require_relative 'polyadic_expression' # Access the superclass

module Regex # This module is used as a namespace
  # Abstract class. A n-ary matching operator.
  # It succeeds when one child expression succeeds to match the subject text.
  class CharClass < PolyadicExpression
    # These are characters with special meaning in character classes
    Metachars = ']\^-'.codepoints
    # A flag that indicates whether the character is negated
    attr_reader(:negated)

    # Constructor.
    def initialize(to_negate, *theChildren)
      super(theChildren)
      @negated = to_negate
    end

    protected

    # Conversion method re-definition.
    # Purpose: Return the String representation of the character class.
    def text_repr
      result_children = children.inject(+'') do |sub_result, child|
        if child.kind_of?(Regex::Character) && Metachars.include?(child.codepoint)
          sub_result << '\\' # Escape meta-character...
        end
        sub_result << child.to_str
      end
      "[#{negated ? '^' : ''}#{result_children}]"
    end
  end # class
end # module

# End of file
