# frozen_string_literal: true

require_relative 'srl_ruby/version'
require_relative 'srl_ruby/tokenizer'
require_relative 'srl_ruby/grammar'
require_relative 'srl_ruby/ast_builder'

module SrlRuby
  # Compile the SRL expression in given filename into a Regexp object.
  # @param filename [String] Name of SRL file to parse
  # @return [Regexp] A regexp object equivalent to the SRL expression.
  def self.load_file(filename)
    source = nil
    File.open(filename, 'r') { |f| source = f.read }
    return source if source.nil? || source.empty?

    parse(source)
  end

  # Compile the given SRL expression into its Regexp equivalent.
  # @param source [String] SRL expression to parse
  # @return [Regexp] A regexp object equivalent to the SRL expression.
  # @example Matching a (signed) integer literal
  #   some_srl =<<-SRL
  #     begin with
  #       (one of "+-") optional,
  #       digit once or more,
  #     must end
  #   SRL
  #   regex = SrlRuby::API.parse(some_srl) # => regex == /^[+\-]?\d+$/
  def self.parse(source)
    # Create a Rley facade object
    engine = Rley::Engine.new { |cfg| cfg.diagnose = true }

    # Step 1. Load SRL grammar
    engine.use_grammar(SrlRuby::Grammar)

    lexer = SrlRuby::Tokenizer.new(source)
    result = engine.parse(lexer.tokens)

    unless result.success?
      # Stop if the parse failed...
      line1 = "Parsing failed\n"
      line2 = "Reason: #{result.failure_reason.message}"
      raise StandardError, line1 + line2
    end

    # Generate an abstract syntax tree (AST) from the parse result
    engine.configuration.repr_builder = SrlRuby::ASTBuilder
    ast_ptree = engine.convert(result)

    # Now output the regexp literal
    root = ast_ptree.root
    options = root.is_a?(Regex::MatchOption) ? root.combine_opts : nil
    Regexp.new(root.to_str, options)
  end
end # module
