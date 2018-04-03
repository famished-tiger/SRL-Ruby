# File: srl_tokenizer.rb
# Tokenizer for SRL (Simple Regex Language)
require 'strscan'
require_relative 'srl_token'


module SrlRuby
  # The tokenizer should recognize:
  # Keywords: as, capture, letter
  # Integer literals including single digit
  # String literals (quote delimited)
  # Single character literal
  # Delimiters: parentheses '(' and ')'
  # Separators: comma (optional)
  class Tokenizer
    attr_reader(:scanner)
    attr_reader(:lineno)
    attr_reader(:line_start)
    # attr_reader(:column)

    @@lexeme2name = {
      '(' => 'LPAREN',
      ')' => 'RPAREN',
      ',' => 'COMMA'
    }.freeze

    # Here are all the SRL keywords (in uppercase)
    @@keywords = %w[
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
    ].map { |x| [x, x] } .to_h

    class ScanError < StandardError; end

    def initialize(source)
      @scanner = StringScanner.new(source)
      @lineno = 1
      @line_start = 0
    end

    def tokens()
      tok_sequence = []
      until @scanner.eos?
        token = _next_token
        tok_sequence << token unless token.nil?
      end

      return tok_sequence
    end

    private

    def _next_token()
      skip_whitespaces
      curr_ch = scanner.peek(1)
      return nil if curr_ch.nil? || curr_ch.empty?

      token = nil

      if '(),'.include? curr_ch
        # Delimiters, separators => single character token
        token = build_token(@@lexeme2name[curr_ch], scanner.getch)
      elsif (lexeme = scanner.scan(/[0-9]{2,}((?=\s)|$)/))
        token = build_token('INTEGER', lexeme) # An integer has 2..* digits
      elsif (lexeme = scanner.scan(/[0-9]((?=\s)|$)/))
        token = build_token('DIGIT_LIT', lexeme)
      elsif (lexeme = scanner.scan(/"(?:\\"|[^"])*"/)) # Double quotes literal?
        unquoted = lexeme.gsub(/(^")|("$)/, '')
        token = build_token('STRING_LIT', unquoted)
      elsif (lexeme = scanner.scan(/'(?:\\'|[^'])*'/)) # Single quotes literal?
        unquoted = lexeme.gsub(/(^')|('$)/, '')
        token = build_token('STRING_LIT', unquoted)
      elsif (lexeme = scanner.scan(/[a-zA-Z]((?=\s)|$)/))        
        token = build_token('LETTER_LIT', lexeme)
      elsif (lexeme = scanner.scan(/[a-zA-Z_][a-zA-Z0-9_]+/))
        keyw = @@keywords[lexeme.upcase]
        tok_type = keyw ? keyw : 'IDENTIFIER'
        token = build_token(tok_type, lexeme)       
      elsif (lexeme = scanner.scan(/[^,"\s]{2,}/))
        token = build_token('CHAR_CLASS', lexeme)
      else # Unknown token
        erroneous = curr_ch.nil? ? '' : curr_ch
        sequel = scanner.scan(/.{1,20}/)
        erroneous += sequel unless sequel.nil?
        raise ScanError.new("Unknown token #{erroneous} on line #{lineno}")
      end

      return token
    end

    def build_token(aSymbolName, aLexeme)
      begin
        col = scanner.pos - aLexeme.size - @line_start + 1
        pos = Position.new(@lineno, col)
        token = SrlToken.new(aLexeme, aSymbolName, pos)
      rescue Exception => exc
        puts "Failing with '#{aSymbolName}' and '#{aLexeme}'"
        raise exc
      end

      return token
    end

    def skip_whitespaces()
      pre_pos = scanner.pos

      begin
        ws_found = false
        found = scanner.skip(/[ \t\f]+/)
        ws_found = true if found
        found = scanner.skip(/(?:\r\n)|\r|\n/)
        if found
          ws_found = true
          @lineno += 1
          @line_start = scanner.pos
        end
      end while ws_found

      curr_pos = scanner.pos
      return if curr_pos == pre_pos
      # skipped = scanner.string.slice(Range.new(pre_pos, curr_pos))
      # triplet = skipped.rpartition(/\n|\r/)
      # @column = 1 unless triplet[1].empty?
      
      # Correction for the tabs
      # tab_count = triplet[2].chars.count { |ch| ch =~ /\t/ }
      # @column += triplet[2].size + tab_count * (tab_size - 1) - 1    
    end

    def tab_size()
      2
    end
  end # class
end # module
