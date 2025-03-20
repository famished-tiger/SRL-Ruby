# frozen_string_literal: true

# File: srl_tokenizer.rb
# Tokenizer for SRL (Simple Regex Language)
require 'strscan'
require 'rley'


module SrlRuby
  # A tokenizer for the Simple Regex Language.
  # Responsibility: break input SRL into a sequence of token objects.
  # The tokenizer should recognize:
  # Keywords: as, capture, letter
  # Integer literals including single digit
  # String literals (quote delimited)
  # Single character literal
  # Delimiters: parentheses '(' and ')'
  # Separators: comma (optional)
  class Tokenizer
    # @return [Regexp] Matches a SRL character class
    PATT_CHAR_CLASS = /[^,"\s]{2,}/

    # @return [Regexp] Matches single digit
    PATT_DIGIT_LIT = /[0-9]((?=\s|,|\))|$)/

    # @return [Regexp] Matches a SRL identifier
    PATT_IDENTIFIER = /[a-zA-Z_][a-zA-Z0-9_]+/

    # @return [Regexp] Matches a decimal integer. An integer has 2..* digits
    PATT_INTEGER = /[0-9]{2,}((?=\s|,|\))|$)/

    # @return [Regexp] Matches a single letter.
    PATT_LETTER_LIT = /[a-zA-Z]((?=\s|,|\))|$)/

    # @return [Regexp] Matches a new line (cross-platform)
    PATT_NEWLINE = /(?:\r\n)|\r|\n/

    # @return [Regexp] Matches a text enclosed in double quotes
    PATT_STR_DBL_QUOTE = /"(?:\\"|[^"])*"/

    # @return [Regexp] Matches a text enclosed in single quotes
    PATT_STR_SNGL_QUOTE = /'(?:\\'|[^'])*'/

    # @return [Regexp] Matches SRL blank(s)
    PATT_WHITESPACE = /[ \t\f]+/

    # @return [StringScanner]
    attr_reader(:scanner)

    # @return [Integer] current line number
    attr_reader(:lineno)

    # @return [Integer] offset of start of current line within input
    attr_reader(:line_start)

    # @return [{String => String}] Mapping special single characters to symbolic names.
    Lexeme2name = {
      '(' => 'LPAREN',
      ')' => 'RPAREN',
      ',' => 'COMMA'
    }.freeze

    # Here are all the SRL keywords (in uppercase)
    # @return [{String => String}]
    Keywords = %w[
      ALL
      ALREADY
      AND
      ANY
      ANYTHING
      AS
      AT
      BACKSLASH
      BEGIN
      BETWEEN
      BY
      CAPTURE
      CARRIAGE
      CASE
      CHARACTER
      DIGIT
      EITHER
      END
      EXACTLY
      FOLLOWED
      FROM
      HAD
      IF
      INSENSITIVE
      LAZY
      LEAST
      LETTER
      LINE
      LITERALLY
      MORE
      MULTI
      MUST
      NEVER
      NEW
      NO
      NONE
      NOT
      NUMBER
      OF
      ONCE
      ONE
      OPTIONAL
      OR
      RAW
      RETURN
      STARTS
      TAB
      TIMES
      TO
      TWICE
      UNTIL
      UPPERCASE
      VERTICAL
      WHITESPACE
      WITH
      WORD
    ].to_h { |x| [x, x] }

    # Exception class for scanner/tokenizer failures.
    class ScanError < StandardError; end

    # Constructor. Initialize a tokenizer for SRL.
    # @param source [String] SRL text to tokenize.
    def initialize(source)
      @scanner = StringScanner.new(source)
      @lineno = 1
      @line_start = 0
    end

    # Returns the sequence of tokens recognized from the input text given at initialization.
    # @return [Array<Rley::Lexical::Token>]
    def tokens
      tok_sequence = []
      until @scanner.eos?
        token = _next_token
        tok_sequence << token unless token.nil?
      end

      tok_sequence
    end

    private

    # @return [Rley::Lexical::Token]
    def _next_token
      token = nil

      # Loop until end of input reached or token found
      until token || scanner.eos?

        if scanner.skip(PATT_NEWLINE)
          next_line_scanned
          next
        end
        next if scanner.skip(PATT_WHITESPACE) # Skip whitespaces

        curr_ch = scanner.peek(1)

        token = if '(),'.include? curr_ch
          # Delimiters, separators => single character token
          build_token(Lexeme2name[curr_ch], scanner.getch)
        elsif (lexeme = scanner.scan(PATT_INTEGER))
          build_token('INTEGER', lexeme)
        elsif (lexeme = scanner.scan(PATT_DIGIT_LIT))
          build_token('DIGIT_LIT', lexeme)
        elsif (lexeme = scanner.scan(PATT_STR_DBL_QUOTE))
          unquoted = lexeme.gsub(/(^")|("$)/, '')
          build_token('STRING_LIT', unquoted)
        elsif (lexeme = scanner.scan(PATT_STR_SNGL_QUOTE))
          unquoted = lexeme.gsub(/(^')|('$)/, '')
          build_token('STRING_LIT', unquoted)
        elsif (lexeme = scanner.scan(PATT_LETTER_LIT))
          build_token('LETTER_LIT', lexeme)
        elsif (lexeme = scanner.scan(PATT_IDENTIFIER))
          keyw = Keywords[lexeme.upcase]
          tok_type = keyw || 'IDENTIFIER'
          build_token(tok_type, lexeme)
        elsif (lexeme = scanner.scan(PATT_CHAR_CLASS))
          build_token('CHAR_CLASS', lexeme)
        else # Unknown token
          erroneous = curr_ch.nil? ? '' : scanner.scan(/./)
          sequel = scanner.scan(/.{1,20}/)
          erroneous += sequel unless sequel.nil?
          raise ScanError, "Unknown token #{erroneous} on line #{lineno}"
        end
      end # until

      token
    end

    # @param aSymbolName [String]
    # @param aLexeme [String]
    # @return [Rley::Lexical::Token]
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

    # Event: next line detected.
    # @return [Integer] Current scanning position (offset)
    def next_line_scanned
      @lineno += 1
      @line_start = scanner.pos
    end
  end # class
end # module
