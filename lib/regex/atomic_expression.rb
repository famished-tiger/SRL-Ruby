# File: atomic_expression.rb

require_relative 'expression' # Access the superclass

module Regex # This module is used as a namespace
  # Abstract class. A valid regular expression that
  # cannot be further decomposed into sub-expressions.
  class AtomicExpression < Expression
    # Redefined method.
    # @return [TrueClass] Return true since it may not have any child.
    def atomic?
      return true
    end

    # Notification that the parse tree construction is complete.
    def done!()
      # Do nothing
    end

    # Notification that all quantifiers are lazy
    def lazy!()
      # Do nothing
    end
  end # class
end # module

# End of file
