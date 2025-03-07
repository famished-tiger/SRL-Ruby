# frozen_string_literal: true

# File: rule_tokenizer.rb
# Tokenizer for SimpleRegex Test-Rule files
# [File format](https://github.com/SimpleRegex/Test-Rules/blob/master/README.md)
require 'strscan'
require 'rley'

module Acceptance
  # The tokenizer should recognize:
  # Keywords: as, capture, letter
  # Integer literals including single digit
  # String literals (quote delimited)
  # Single character literal
  # Delimiters: parentheses '(' and ')'
  # Separators: comma (optional)
  class RuleFileTokenizer
    # @return [StringScanner]
    attr_reader(:scanner)

    # @return [Integer] current line number
    attr_reader(:lineno)

    # @return [Integer] offset of start of current line within input
    attr_reader(:line_start)

    # Can be :default, :expecting_srl
    attr_reader(:state)

    @@lexeme2name = {
      ':' => 'COLON',
      '-' => 'DASH'
    }.freeze

    # Here are all the Rule file keywords
    @@keywords = %w[
      capture
      for
      match:
      no
      srl:
    ].to_h { |x| [x, x.upcase] }

    class ScanError < StandardError; end

    def initialize(source)
      @scanner = StringScanner.new(source)
      @lineno = 1
      @line_start = 0
      @state = :default
    end

    def tokens
      tok_sequence = []
      until @scanner.eos?
        token = _next_token
        tok_sequence << token unless token.nil?
      end

      tok_sequence
    end

    private

    def _next_token
      skip_noise
      curr_ch = scanner.peek(1)
      return nil if curr_ch.nil? || curr_ch.empty?

      if state == :default
        default_mode
      else
        expecting_srl
      end
    end

    def default_mode
      curr_ch = scanner.peek(1)
      token = nil

      if '-:'.include? curr_ch
        # Delimiters, separators => single character token
        token = build_token(@@lexeme2name[curr_ch], scanner.getch)
      elsif (lexeme = scanner.scan(/[0-9]+/))
        token = build_token('INTEGER', lexeme)
      elsif (lexeme = scanner.scan(/srl:|match:/))
        token = build_token(@@keywords[lexeme].chop, lexeme.chop)
        @state = :expecting_srl if lexeme == 'srl:'
      elsif (lexeme = scanner.scan(/[a-zA-Z_][a-zA-Z0-9_]*/))
        keyw = @@keywords[lexeme]
        token_type = keyw || 'IDENTIFIER'
        token = build_token(token_type, lexeme)
      elsif (lexeme = scanner.scan(/"([^"]|\\")*"/)) # Double quotes literal?
        unquoted = lexeme.gsub(/(^")|("$)/, '')
        token = build_token('STRING_LIT', unquoted)
      else # Unknown token
        erroneous = curr_ch.nil? ? '' : curr_ch
        sequel = scanner.scan(/.{1,20}/)
        erroneous += sequel unless sequel.nil?
        raise ScanError, "Unknown token #{erroneous}"
      end

      token
    end

    def expecting_srl
      scanner.skip(/^:/)
      lexeme = scanner.scan(/[^\r\n]*/)
      @state = :default
      build_token('SRL_SOURCE', lexeme)
    end

    def build_token(aSymbolName, aLexeme)
      begin
        col = scanner.pos - aLexeme.size - @line_start + 1
        pos = Rley::Lexical::Position.new(@lineno, col)
        token = Rley::Lexical::Token.new(aLexeme, aSymbolName, pos)
      rescue StandardError => e
        puts "Failing with '#{aSymbolName}' and '#{aLexeme}'"
        raise e
      end

      token
    end

    def skip_noise
      loop do
        noise_found = false
        noise_found = true if skip_whitespaces
        noise_found = true if skip_comment
        break unless noise_found
      end
    end

    def skip_whitespaces
      pre_pos = scanner.pos

      loop do
        ws_found = false
        found = scanner.skip(/[ \t\f]+/)
        ws_found = true if found
        found = scanner.skip(/(?:\r\n)|\r|\n/)
        if found
          ws_found = true
          @lineno += 1
          @line_start = scanner.pos
        end
        break unless ws_found
      end

      curr_pos = scanner.pos
      curr_pos != pre_pos
    end

    def skip_comment
      scanner.skip(/#[^\n\r]+/)
    end
  end # class
end # module
