# frozen_string_literal: true

# File: atomic_expression_spec.rb
require_relative '../spec_helper' # Use the RSpec test framework
require_relative '../../lib/regex/atomic_expression'

# Reopen the module, in order to get rid of fully qualified names
module Regex # This module is used as a namespace
  describe AtomicExpression do
    subject { AtomicExpression.new }

    context 'Creation & initialisation' do
      it 'should be created without argument' do
        expect { AtomicExpression.new }.not_to raise_error
      end

      it 'should know that it is atomic' do
        expect(subject).to be_atomic
      end
    end # context

    context 'Provided services' do
      it 'should be unchanged by a done! notification' do
        pre_snapshot = Marshal.dump(subject)
        expect { subject.done! }.not_to raise_error
        post_snapshot = Marshal.dump(subject)
        expect(post_snapshot).to eq(pre_snapshot)
      end

      it 'should be unchanged by a lazy! notification' do
        pre_snapshot = Marshal.dump(subject)
        expect { subject.lazy! }.not_to raise_error
        post_snapshot = Marshal.dump(subject)
        expect(post_snapshot).to eq(pre_snapshot)
      end
    end # context
  end # describe
end # module
