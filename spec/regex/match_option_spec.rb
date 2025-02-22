# frozen_string_literal: true

# File: match_option_spec.rb

require_relative '../spec_helper' # Use the RSpec test framework
require_relative '../../lib/regex/match_option'

# Reopen the module, in order to get rid of fully qualified names
module Regex # This module is used as a namespace
  describe MatchOption do
    let(:sample_child) { double('fake-child') }

    subject(:option) { described_class.new(sample_child, [Regexp::MULTILINE, Regexp::IGNORECASE]) }

    context 'Creation & initialisation' do
      it 'is created with a child and flags' do
        expect { described_class.new(sample_child, []) }.not_to raise_error
      end

      it 'Knows its child' do
        expect(option.child).to eq(sample_child)
      end

      it 'Knows its flags' do
        expect(option.flags).to eq([Regexp::MULTILINE, Regexp::IGNORECASE])
      end
    end # context

    context 'Provided services' do
      it 'Combines the flag bits' do
        expect(option.combine_opts).to eq(Regexp::MULTILINE | Regexp::IGNORECASE)
      end
    end # context
  end # describe
end # module
