# frozen_string_literal: true

require_relative 'rule_file_tokenizer'
require_relative 'rule_file_grammar'
require_relative 'rule_file_ast_builder'

module Acceptance # This module is used as a namespace
  module RuleFileParser
    # Load the rule file
    # Returns the test rule representation
    # @param filename [String] file name to parse.
    def self.load_file(filename)
      source = nil
      File.open(filename, 'r') { |f| source = f.read }
      return source if source.nil? || source.empty?

      return parse(source)
    end

    # Parse the rule file
    # @param source [String] the SRL source to parse and convert.
    def self.parse(source)
      # Create a Rley facade object
      engine = Rley::Engine.new

      # Step 1. Load SRL grammar
      engine.use_grammar(RuleFileGrammar)

      lexer = RuleFileTokenizer.new(source)
      result = engine.parse(lexer.tokens)

      unless result.success?
        # Stop if the parse failed...
        line1 = "Parsing failed\n"
        line2 = "Reason: #{result.failure_reason.message}"
        raise StandardError, line1 + line2
      end

      # Generate an abstract syntax tree (AST) from the parse result
      engine.configuration.repr_builder = RuleFileASTBuilder
      ast_ptree = engine.convert(result)

      # Now output the regexp literal
      root = ast_ptree.root
      return root
    end
  end
end # module
