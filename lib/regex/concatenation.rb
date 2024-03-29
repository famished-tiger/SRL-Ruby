# frozen_string_literal: true

# File: concatenation.rb

require_relative 'polyadic_expression' # Access the superclass

module Regex # This module is used as a namespace
  # Abstract class. A n-ary matching operator.
  # It succeeds when each child succeeds to match the subject text in the same
  # serial arrangement than defined by this concatenation.
  class Concatenation < PolyadicExpression
    # Constructor.
    def initialize(*theChildren)
      super(theChildren)
    end

    protected

    # Conversion method re-definition.
    # Purpose: Return the String representation of the concatented expressions.
    def text_repr
      children.inject(+'') do |result, child|
        result << child.to_str
      end
    end
  end # class
end # module

# End of file
