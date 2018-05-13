require 'rley' # Load the Rley gem

module Acceptance
  Position = Struct.new(:line, :column) do
    def to_s
      "line #{line}, column #{column}"
    end
  end

  # Specialization of Token class.
  # It stores the position in (line, row) of the token
  class RuleFileToken < Rley::Lexical::Token
    attr_reader(:position)

    def initialize(theLexeme, aTerminal, aPosition)
      super(theLexeme, aTerminal)
      @position = aPosition
    end
  end # class
end # module

# End of file
