# frozen_string_literal: true

# File: repetition_spec.rb
require_relative '../spec_helper' # Use the RSpec test framework
require_relative '../../lib/regex/repetition'

# Reopen the module, in order to get rid of fully qualified names
module Regex # This module is used as a namespace
  describe Repetition do
    let(:optional) { Multiplicity.new(0, 1, :possessive) }
    let(:sample_child) { double('fake_regex') }

    subject(:repetition) { described_class.new(sample_child, optional) }

    context 'Creation & initialisation' do
      it 'is created with a child expression and a multiplicity' do
        expect { described_class.new(sample_child, optional) }.not_to raise_error
      end

      it 'Knows its multiplicity' do
        expect(repetition.multiplicity).to eq(optional)
      end
    end # context

    context 'Provided services' do
      it 'Changes its policy with lazy! notification' do
        allow(sample_child).to receive(:lazy!)
        expect { repetition.lazy! }.not_to raise_error
        expect(repetition.multiplicity.policy).to eq(:lazy)
      end
    end # context
  end # describe
end # module
