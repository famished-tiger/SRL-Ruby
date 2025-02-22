# frozen_string_literal: true

# File: monadic_expression_spec.rb
require_relative '../spec_helper' # Use the RSpec test framework
require_relative '../../lib/regex/monadic_expression'

# Reopen the module, in order to get rid of fully qualified names
module Regex # This module is used as a namespace
  describe MonadicExpression do
    let(:sample_child) { double('fake_regex') }

    subject(:monadic_expr) { described_class.new(sample_child) }

    context 'Creation & initialisation' do
      it 'is created with a child expression' do
        expect { described_class.new(sample_child) }.not_to raise_error
      end

      it 'Knows its child' do
         expect(monadic_expr.child).to eq(sample_child)
      end

      it 'Know that it is not atomic' do
        expect(monadic_expr).not_to be_atomic
      end
    end # context

    context 'Provided services' do
      it 'Propagates done! notification' do
        allow(sample_child).to receive(:done!)
        expect { monadic_expr.done! }.not_to raise_error
      end

      it 'is unchanged by a lazy! notification' do
        allow(sample_child).to receive(:lazy!)
        expect { monadic_expr.lazy! }.not_to raise_error
      end
    end # context
  end # describe
end # module
