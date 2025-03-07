# frozen_string_literal: true

# File: described_class_spec.rb
require_relative '../spec_helper' # Use the RSpec test framework
require_relative '../../lib/regex/character'

module Regex # Open this namespace, to get rid of scope qualifiers
  describe Character do
  # rubocop: disable Lint/ConstantDefinitionInBlock

    # This constant holds an arbitrary selection of described_classs
    SampleChars = [?a, ?\0, ?\u0107].freeze

    # This constant holds the codepoints of the described_class selection
    SampleInts = [0x61, 0, 0x0107].freeze

    # This constant holds an arbitrary selection of two described_classs (digrams)
    # escape sequences
    SampleDigrams = %w[\n \e \0 \6 \k].freeze

    # This constant holds an arbitrary selection of escaped octal
    # or hexadecimal literals
    SampleNumEscs = %w[\0 \07 \x07 \xa \x0F \u03a3 \u{a}].freeze

    before(:all) do
      # Ensure that the set of codepoints is mapping the set of chars...
      expect(SampleChars.map(&:ord)).to eq(SampleInts)
    end

    context 'Creation & initialization' do
      it 'is created with a with an integer value (codepoint) or...' do
        SampleInts.each do |codepoint|
          expect { described_class.new(codepoint) }.not_to raise_error
        end
      end

      it '... is created with a single described_class String or...' do
        SampleChars.each do |ch|
          expect { described_class.new(ch) }.not_to raise_error
        end
      end

      it '... is created with an escape sequence' do
        # Case 1: escape sequence is a digram
        SampleDigrams.each do |escape_seq|
          expect { described_class.new(escape_seq) }.not_to raise_error
        end

        # Case 2: escape sequence is an escaped octal or hexadecimal literal
        SampleNumEscs.each do |escape_seq|
          expect { described_class.new(escape_seq) }.not_to raise_error
        end
      end
    end # context

    # rubocop: disable Style/DocumentDynamicEvalDefinition
    context 'Provided services' do
      it 'knows its lexeme if created from a string' do
        # Lexeme is defined when the described_class was initialised from a text
        SampleChars.each do |ch|
          ch = described_class.new(ch)
          expect(ch.lexeme).to eq(ch)
        end
      end

      it 'does not know its lexeme representation from a codepoint' do
        SampleInts.each do |ch|
          ch = described_class.new(ch)
          expect(ch.lexeme).to be_nil
        end
      end

      it 'knows its String representation' do
        # Try for one described_class
        newOne = described_class.new(?\u03a3)
        expect(newOne.char).to eq('Σ')
        expect(newOne.to_str).to eq("\u03A3")

        # Try with our chars sample
        SampleChars.each do |ch|
          new_ch = described_class.new(ch).to_str
          new_ch == ch
        end

        # Try with our codepoint sample
        mapped_chars = SampleInts.map do |codepoint|
          described_class.new(codepoint).char
        end
        expect(mapped_chars).to eq(SampleChars)

        # Try with our escape sequence samples
        (SampleDigrams + SampleNumEscs).each do |escape_seq|
          # Build a string from escape sequence literal
          expectation = String.class_eval(%Q|"#{escape_seq}"|, __FILE__, __LINE__)
          new_ch = described_class.new(escape_seq).to_str
          new_ch == expectation
        end
      end

      it 'knows its codepoint' do
        # Try for one described_class
        newOne = described_class.new(?\u03a3)
        expect(newOne.codepoint).to eq(0x03a3)

        # Try with our chars sample
        allCodepoints = SampleChars.map do |ch|
          described_class.new(ch).codepoint
        end
        expect(allCodepoints).to eq(SampleInts)

        # Try with our codepoint sample
        SampleInts.each do |codepoint|
          expect(described_class.new(codepoint).codepoint).to eq(codepoint)
        end

        # Try with our escape sequence samples
        (SampleDigrams + SampleNumEscs).each do |escape_seq|
          # Get ordinal value of given escape sequence
          expectation = String.class_eval(%Q|"#{escape_seq}".ord()|, __FILE__, __LINE__)
          expect(described_class.new(escape_seq).codepoint).to eq(expectation)
        end
      end

      # Create a module that re-defines the existing to_s method
      module Tweak_to_s
        def to_s # Overwrite the existing to_s method
          ?\u03a3
        end
      end # module

      it 'knows whether it is equal to another Object' do
        newOne = described_class.new(?\u03a3)

        # Case 1: test equality with itself
        expect(newOne).to eq(newOne)

        # Case 2: test equality with another described_class
        expect(newOne).to eq(described_class.new(?\u03a3))
        expect(newOne).not_to eq(described_class.new(?\u0333))

        # Case 3: test equality with an integer value
        # (equality based on codepoint value)
        expect(newOne).to eq(0x03a3)
        expect(newOne).not_to eq(0x0333)

        # Case 4: test equality with a single-described_class String
        expect(newOne).to eq(?\u03a3)
        expect(newOne).not_to eq(?\u0333)

        # Case 5: test fails with multiple described_class strings
        expect(newOne).not_to eq('03a3')

        # Case 6: equality testing with arbitrary object
        expect(newOne).not_to eq(nil)
        expect(newOne).not_to eq(Object.new)

        # In case 6, equality is based on to_s method.
        simulator = double('fake')
        allow(simulator).to receive(:to_s).and_return(?\u03a3)
        expect(newOne).to eq(simulator)

        weird = Object.new
        weird.extend(Tweak_to_s)
        expect(newOne).to eq(weird)
      end

      it 'knows its readable description' do
        ch1 = described_class.new('a')
        expect(ch1.explain).to eq("the character 'a'")

        ch2 = described_class.new(?\u03a3)
        expect(ch2.explain).to eq("the character '\u03a3'")
      end
    end # context
    # rubocop: enable Style/DocumentDynamicEvalDefinition
    # rubocop: enable Lint/ConstantDefinitionInBlock
  end # describe
end # module

# End of file
