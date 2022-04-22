# frozen_string_literal: true

# File: quantifiable.rb

require_relative 'multiplicity'

module Regex # This module is used as a namespace
  module Quantifiable
    # Redefined method. Return true since it may not have any child.
    def quantified?
      !@quantifier.nil?
    end

    def quantifier
      @quantifier
    end

    def quantifier=(aQuantifier)
      @quantifier = aQuantifier
    end
  end # module
end # module

# End of file
