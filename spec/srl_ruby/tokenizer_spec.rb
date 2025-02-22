# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework
require_relative '../../lib/srl_ruby/tokenizer' # Load the class under test

module SrlRuby
  describe Tokenizer do
    def match_expectations(aTokenizer, theExpectations)
      aTokenizer.tokens.each_with_index do |token, i|
        terminal, lexeme = theExpectations[i]
        expect(token.terminal).to eq(terminal)
        expect(token.lexeme).to eq(lexeme)
      end
    end

    subject(:tokenizer) { described_class.new('') }

    context 'Initialization:' do
      it 'is initialized with a text to tokenize' do
        expect { described_class.new('anything') }.not_to raise_error
      end

      it 'has its scanner initialized' do
        expect(tokenizer.scanner).to be_a(StringScanner)
      end
    end # context

    context 'Single token recognition:' do
      it 'tokenizes delimiters and separators' do
        tokenizer.scanner.string = ','
        token = tokenizer.tokens.first
        expect(token).to be_a(Rley::Lexical::Token)
        expect(token.terminal).to eq('COMMA')
        expect(token.lexeme).to eq(',')
      end

      it 'tokenizes keywords' do
        sample = 'between Exactly oncE optional TWICE'
        tokenizer.scanner.string = sample
        tokenizer.tokens.each do |tok|
          expect(tok).to be_a(Rley::Lexical::Token)
          expect(tok.terminal).to eq(tok.lexeme.upcase)
        end
      end

      it 'tokenizes integer values' do
        tokenizer.scanner.string = ' 123 '
        token = tokenizer.tokens.first
        expect(token).to be_a(Rley::Lexical::Token)
        expect(token.terminal).to eq('INTEGER')
        expect(token.lexeme).to eq('123')
      end

      it 'tokenizes single digits' do
        tokenizer.scanner.string = ' 1 '
        token = tokenizer.tokens.first
        expect(token).to be_a(Rley::Lexical::Token)
        expect(token.terminal).to eq('DIGIT_LIT')
        expect(token.lexeme).to eq('1')
      end
    end # context

    context 'String literal tokenization:' do
      it "Recognizes 'literally ...'" do
        input = 'literally "hello"'
        tokenizer.scanner.string = input
        expectations = [
          %w[LITERALLY literally],
          %w[STRING_LIT hello]
        ]
        match_expectations(tokenizer, expectations)
      end
    end # context

    context 'Character range tokenization:' do
      it "recognizes 'letter from ... to ...'" do
        input = 'letter a to f'
        tokenizer.scanner.string = input
        expectations = [
          %w[LETTER letter],
          %w[LETTER_LIT a],
          %w[TO to],
          %w[LETTER_LIT f]
        ]
        match_expectations(tokenizer, expectations)
      end

      it "recognizes 'letter from ... to ... followed by comma'" do
        input = 'letter a to f,'
        tokenizer.scanner.string = input
        expectations = [
          %w[LETTER letter],
          %w[LETTER_LIT a],
          %w[TO to],
          %w[LETTER_LIT f],
          %w[COMMA ,]
        ]
        match_expectations(tokenizer, expectations)
      end
    end # context

    context 'Quantifier tokenization:' do
      it "recognizes 'exactly ... times'" do
        input = 'exactly 4 Times'
        tokenizer.scanner.string = input
        expectations = [
          %w[EXACTLY exactly],
          %w[DIGIT_LIT 4],
          %w[TIMES Times]
        ]
        match_expectations(tokenizer, expectations)
      end

      it "recognizes 'between ... and ... times'" do
        input = 'Between 2 AND 4 times'
        tokenizer.scanner.string = input
        expectations = [
          %w[BETWEEN Between],
          %w[DIGIT_LIT 2],
          %w[AND AND],
          %w[DIGIT_LIT 4],
          %w[TIMES times]
        ]
        match_expectations(tokenizer, expectations)
      end

      it "recognizes 'once or more'" do
        input = 'Once or MORE'
        tokenizer.scanner.string = input
        expectations = [
          %w[ONCE Once],
          %w[OR or],
          %w[MORE MORE]
        ]
        match_expectations(tokenizer, expectations)
      end

      it "recognizes 'never or more'" do
        input = 'never or more'
        tokenizer.scanner.string = input
        expectations = [
          %w[NEVER never],
          %w[OR or],
          %w[MORE more]
        ]
        match_expectations(tokenizer, expectations)
      end

      it "recognizes 'at least ... times'" do
        input = 'at least 10 times'
        tokenizer.scanner.string = input
        expectations = [
          %w[AT at],
          %w[LEAST least],
          %w[INTEGER 10],
          %w[TIMES times]
        ]
        match_expectations(tokenizer, expectations)
      end
    end # context
  end # describe
end # module
