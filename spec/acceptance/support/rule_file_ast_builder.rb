require_relative 'rule_file_nodes'

module Acceptance
  # The purpose of a ASTBuilder is to build piece by piece an AST
  # (Abstract Syntax Tree) from a sequence of input tokens and
  # visit events produced by walking over a GFGParsing object.
  # Uses the Builder GoF pattern.
  # The Builder pattern creates a complex object
  # (say, a parse tree) from simpler objects (terminal and non-terminal
  # nodes) and using a step by step approach.
  class RuleFileASTBuilder < Rley::ParseRep::ASTBaseBuilder
    Terminal2NodeClass = {
      # Lexical ambiguity: integer literal represents two very different concepts:
      # An index or a capture variable name
      'INTEGER' => IntegerNode,
      'STRING_LIT' => StringLitNode,
      'IDENTIFIER' => VarnameNode,
      'SRL_SOURCE' => SRLSourceNode
    }.freeze

    attr_reader :options

    def done!()
      # Do nothing!
    end

    protected

    def terminal2node()
      Terminal2NodeClass
    end

    # rule('rule_file' => %w[srl_heading srl_tests]).as 'start_rule'
    def reduce_start_rule(_production, _range, _tokens, theChildren)
      rule_file = RuleFileTests.new(theChildren[0])
      tests = theChildren.last.flatten
      tests.each do |t|
        case t
        when MatchTest then rule_file.match_tests << t
        when NoMatchTest then rule_file.no_match_tests << t
        when CaptureTest then rule_file.capture_tests << t
        else
          raise StandardError, 'Internal error'
        end
      end

      return rule_file
    end

    # rule('srl_heading' => %w[SRL: SRL_SOURCE]).as 'srl_source'
    def reduce_srl_source(_production, _range, _tokens, theChildren)
      return theChildren.last
    end

    # rule('srl_tests' => %w[srl_tests single_test]).as 'test_list'
    def reduce_test_list(_production, _range, _tokens, theChildren)
      return theChildren[0] << theChildren[1]
    end

    # rule('srl_tests' => 'single_test').as 'one_test'
    def reduce_one_test(_production, _range, _tokens, theChildren)
      return [theChildren.last]
    end

    # rule('match_test' => %w[MATCH: STRING_LIT]).as 'match_string'
    def reduce_match_string(_production, _range, _tokens, theChildren)
      MatchTest.new(theChildren.last)
    end

    # rule('no_match_test' => %w[NO MATCH: STRING_LIT]).as 'no_match_string'
    def reduce_no_match_string(_production, _range, _tokens, theChildren)
      NoMatchTest.new(theChildren.last)
    end

    # rule('capture_test' => %w[capture_heading capture_expectations])
    #  .as 'capture_test'
    def reduce_capture_test(_production, _range, _tokens, theChildren)
      CaptureTest.new(theChildren[0], theChildren.last)
    end

    # rule('capture_heading' => %w[CAPTURE FOR STRING_LIT COLON]).as 'capture_string'
    def reduce_capture_string(_production, _range, _tokens, theChildren)
      return theChildren[2]
    end

    # rule('capture_expectations' => %w[capture_expectations
    #   single_expectation]).as 'assertion_list'
    def reduce_assertion_list(_production, _range, _tokens, theChildren)
      return theChildren[0] << theChildren[1]
    end

    # rule('capture_expectations' => 'single_expectation').as 'one_expectation'
    def reduce_one_expectation(_production, _range, _tokens, theChildren)
      return [theChildren.last]
    end

    # rule('single_expectation' => %w[DASH INTEGER COLON capture_variable
    #   COLON STRING_LIT]).as 'capture_expectation'
    def reduce_capture_expectation(_production, _range, _tokens, theChildren)
      CaptureExpectation.new(theChildren[1], theChildren[3], theChildren[5])
    end
  end # class
end # module
