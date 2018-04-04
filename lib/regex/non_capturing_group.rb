# File: non_capturing_group.rb

require_relative 'monadic_expression' # Access the superclass

module Regex # This module is used as a namespace
  # A non-capturing group, in other word it is a pure grouping 
  # of sub-expressions
  class NonCapturingGroup < MonadicExpression
    # Constructor.
    # [aChild]  A sub-expression to match. When successful
    # the matching text is assigned to the capture variable.
    def initialize(aChild)
      # If necessary get rid of nested non-capturing groups
      effective_child = aChild.kind_of?(self.class) ? aChild.child : aChild
      super(effective_child)
    end

    protected

    # Conversion method re-definition.
    # Purpose: Return the String representation of the captured expression.
    def text_repr()
      result = '(?:' + all_child_text + ')'
      return result
    end
  end # class
end # module

# End of file
