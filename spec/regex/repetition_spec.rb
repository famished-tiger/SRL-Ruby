# File: repetition_spec.rb
require_relative '../spec_helper' # Use the RSpec test framework
require_relative '../../lib/regex/repetition'

# Reopen the module, in order to get rid of fully qualified names
module Regex # This module is used as a namespace
  describe Repetition do
    let(:optional) { Multiplicity.new(0, 1, :possessive) }
    let(:sample_child) { double('fake_regex') }
    subject { Repetition.new(sample_child, optional) }

    context 'Creation & initialisation' do
      it 'should be created with a child expression and a multiplicity' do
        expect { Repetition.new(sample_child, optional) }.not_to raise_error
      end

      it 'should its multiplicity' do
        expect(subject.multiplicity).to eq(optional)
      end
    end # context

    context 'Provided services' do
      it 'should change its policy with lazy! notification' do
        expect(sample_child).to receive(:lazy!)
        expect { subject.lazy! }.not_to raise_error
        expect(subject.multiplicity.policy).to eq(:lazy)
      end
    end # context
  end # describe
end # module
