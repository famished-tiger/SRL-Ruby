# frozen_string_literal: true

# Classes that implement nodes of Abstract Syntax Trees (AST) representing
# rule file contents.

module Acceptance
  RuleFileTerminalNode = Struct.new(:value) do
    def initialize(aToken, _position)
      init_value(aToken.lexeme)
    end
  end

  class IntegerNode < RuleFileTerminalNode
    def init_value(aLiteral)
      self.value = aLiteral.to_i
    end
  end

  class StringLitNode < RuleFileTerminalNode
    def init_value(aLiteral)
      self.value = aLiteral.dup
    end
  end

  class SRLSourceNode < RuleFileTerminalNode
    def init_value(aLiteral)
      self.value = aLiteral.dup
    end
  end

  class VarnameNode < RuleFileTerminalNode
    def init_value(aLiteral)
      self.value = aLiteral.dup
    end
  end

  RuleFileTests = Struct.new(:srl, :match_tests, :no_match_tests, :capture_tests) do
    def initialize(aSRLExpression)
      self.srl = aSRLExpression.dup
      self.match_tests = []
      self.no_match_tests = []
      self.capture_tests = []
    end
  end

  MatchTest = Struct.new(:test_string)
  NoMatchTest = Struct.new(:test_string)

  CaptureExpectation = Struct.new(:result_index, :var_name, :captured_text)
  CaptureTest = Struct.new(:test_string, :expectations)
end # module
