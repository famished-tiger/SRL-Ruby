require_relative 'atomic_expression' # Access the superclass

module Regex # This module is used as a namespace
  # A raw expression is a string that will be copied verbatim (as is)
  # in the generated regular expression.
  class RawExpression < AtomicExpression
  attr_reader :raw
  
    # Constructor
    def initialize(rawLiteral)
      super()
      @raw = rawLiteral
    end

    protected

    # Conversion method re-definition.
    # Purpose: Return the String representation of the expression.
  alias_method :text_repr, :raw
  end # class
end # module

# End of file
