# frozen_string_literal: true

# File: monadic_expression_spec.rb
require_relative '../spec_helper' # Use the RSpec test framework
require_relative '../../lib/regex/monadic_expression'

# Reopen the module, in order to get rid of fully qualified names
module Regex # This module is used as a namespace
  describe MonadicExpression do
    let(:sample_child) { double('fake_regex') }
    subject { MonadicExpression.new(sample_child) }

    context 'Creation & initialisation' do
      it 'should be created with a child expression' do
        expect { MonadicExpression.new(sample_child) }.not_to raise_error
      end

      it 'should know its child' do
         expect(subject.child).to eq(sample_child)
      end

      it 'should know that it is not atomic' do
        expect(subject).not_to be_atomic
      end
    end # context

    context 'Provided services' do
      it 'should propagate done! notification' do
        expect(sample_child).to receive(:done!)
        expect { subject.done! }.not_to raise_error
      end

      it 'should be unchanged by a lazy! notification' do
        expect(sample_child).to receive(:lazy!)
        expect { subject.lazy! }.not_to raise_error
      end
    end # context
  end # describe
end # module
