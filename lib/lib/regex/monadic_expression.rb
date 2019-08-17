# frozen_string_literal: true

# File: monadic_expression.rb

require_relative 'compound_expression' # Access the superclass

module Regex # This module is used as a namespace
  # Abstract class. An element that is part of a regular expression &
  # that can have up to one child sub-expression.
  class MonadicExpression < CompoundExpression
    # The (optional) child sub-expression
    attr_reader(:child)

    # Constructor.
    # @param theChild [Regex::Expression] Child (sub)expression
    def initialize(theChild)
      super()
      @child = theChild
    end

    # Notification that the parse tree construction is complete.
    def done!
      child.done!
    end

    # Notification that all quantifiers are lazy
    def lazy!
      child.lazy!
    end

    protected

    # Return the text representation of the child (if any)
    def all_child_text
      result = child.nil? ? '' : child.to_str

      return result
    end
  end # class
end # module
# End of file
