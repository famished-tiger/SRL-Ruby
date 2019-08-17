# frozen_string_literal: true

# File: match_option_spec.rb

require_relative '../spec_helper' # Use the RSpec test framework
require_relative '../../lib/regex/match_option'

# Reopen the module, in order to get rid of fully qualified names
module Regex # This module is used as a namespace
  describe MatchOption do
    let(:sample_child) { double('fake-child') }
    subject { MatchOption.new(sample_child, [Regexp::MULTILINE, Regexp::IGNORECASE]) }

    context 'Creation & initialisation' do
      it 'should be created with a child and flags' do
        expect { MatchOption.new(sample_child, []) }.not_to raise_error
      end

      it 'should know its child' do
        expect(subject.child).to eq(sample_child)
      end

      it 'should know its flags' do
        expect(subject.flags).to eq([Regexp::MULTILINE, Regexp::IGNORECASE])
      end
    end # context

    context 'Provided services' do
      it 'should combine the flag bits' do
        expect(subject.combine_opts).to eq(Regexp::MULTILINE | Regexp::IGNORECASE)
      end
    end # context
  end # describe
end # module
