# frozen_string_literal: true

# File: atomic_expression_spec.rb
require_relative '../spec_helper' # Use the RSpec test framework
require_relative '../../lib/regex/atomic_expression'

# Reopen the module, in order to get rid of fully qualified names
module Regex # This module is used as a namespace
  describe AtomicExpression do
    subject(:atomic_expr) { described_class.new }

    context 'Creation & initialisation' do
      it 'is created without argument' do
        expect { described_class.new }.not_to raise_error
      end

      it 'knows that it is atomic' do
        expect(atomic_expr).to be_atomic
      end
    end # context

    context 'Provided services' do
      it 'is unchanged by a done! notification' do
        pre_snapshot = Marshal.dump(atomic_expr)
        expect { atomic_expr.done! }.not_to raise_error
        post_snapshot = Marshal.dump(atomic_expr)
        expect(post_snapshot).to eq(pre_snapshot)
      end

      it 'is unchanged by a lazy! notification' do
        pre_snapshot = Marshal.dump(atomic_expr)
        expect { atomic_expr.lazy! }.not_to raise_error
        post_snapshot = Marshal.dump(atomic_expr)
        expect(post_snapshot).to eq(pre_snapshot)
      end
    end # context
  end # describe
end # module
