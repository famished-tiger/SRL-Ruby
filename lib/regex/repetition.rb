# File: repetition.rb

require_relative 'monadic_expression' # Access the superclass

module Regex # This module is used as a namespace
  # Represents the repetition of a child element.
  # The number of repetitions is constrained by the multiplicity
  class Repetition < MonadicExpression
    # @return [Regex::Multiplicity]
    attr_reader(:multiplicity)

    # Constructor.
    # @param childExpressionToRepeat [Regex::Expression]
    # @param aMultiplicity [Regex::Multiplicity]
    def initialize(childExpressionToRepeat, aMultiplicity)
      super(childExpressionToRepeat)
      @multiplicity = aMultiplicity
    end

    # Apply the `lazy` flag.
    def lazy!()
      multiplicity.policy = :lazy
      super
    end

    protected

    # Conversion method re-definition.
    # @return [String] String representation of the concatented expressions.
    def text_repr()
      result = all_child_text + multiplicity.to_str
      return result
    end
  end # class
end # module

# End of file
