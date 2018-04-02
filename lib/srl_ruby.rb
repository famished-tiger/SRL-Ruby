require_relative './srl_ruby/version'
require_relative './srl_ruby/tokenizer'
require_relative './srl_ruby/grammar'
require_relative './srl_ruby/ast_builder'

module SrlRuby # This module is used as a namespace
  # Load the SRL expression contained in filename. 
  # Returns an equivalent Regexp object. 
  # @param filename [String] file name to parse.
  # @return [Regexp]
  def self.load_file(filename)
    source = nil
    File.open(filename, 'r') { |f| source = f.read }
    return source if source.nil? || source.empty?
    
    return parse(source)
  end
  
  # Parse the SRL expression into its Regexp equivalent.
  # @param source [String] the SRL source to parse and convert.
  # @return [Regexp]  
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
    # puts root.to_str # TODO remove this line
    # pp root
    return Regexp.new(root.to_str)
  end
end # module
