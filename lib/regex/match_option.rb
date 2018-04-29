# File: MatchOption.rb
require_relative 'monadic_expression'


module Regex # This module is used as a namespace
  # Represents a set of options that influences the way a regular (sub)expression
  # can perform its matching.
  class MatchOption < MonadicExpression
    # @return [Array] Array of Regexp flags
    attr_reader(:flags)

    # Constructor.
    # @param theChild [Regex::Expression] Child expression on which options apply.
    # @param theFlags [Array] An array of Regexp options
    def initialize(theChild, theFlags)
      super(theChild)
      @flags = theFlags
    end

    # Combine all options/flags into one integer value that
    # is compliant as second argument of with Regexp#new method.
    # return [Integer]
    def combine_opts()
      result = 0
      flags.each { |f| result |= f }

      return result
    end

    # Equality operator
    # @param other [Regex::MatchOption]
    def ==(other)
      return true if object_id == other.object_id

      if other.kind_of?(MatchOption)
        isEqual = ((flags == other.flags) && (child == other.child))
      else
        isEqual = false
      end

      return isEqual
    end

    protected

    # Conversion method re-definition.
    # Purpose: Return the String representation of the concatented expressions.
    def text_repr()
      all_child_text
    end
  end # class
end # module

# End of file
