# frozen_string_literal: true

# File: multiplicity_spec.rb

require_relative '../spec_helper' # Use the RSpec test framework
require_relative '../../lib/regex/multiplicity'

# Reopen the module, in order to get rid of fully qualified names
module Regex # This module is used as a namespace
  describe Multiplicity do
    context 'Creation & initialisation' do
      it 'is created with 3 arguments' do
        # Valid cases: initialized with two integer values and a policy symbol
        %i[greedy lazy possessive].each do |policy|
          expect { described_class.new(0, 1, policy) }.not_to raise_error
        end

        # Invalid case: initialized with invalid policy value
        err = StandardError
        msg = "Invalid repetition policy 'KO'."
        expect { described_class.new(0, :more, 'KO') }.to raise_error(err, msg)
      end
    end

    context 'Provided services' do
      # rubocop: disable Style/CombinableLoops
      it 'Knows its text representation' do
        policy2text = { greedy: '', lazy: '?', possessive: '+' }

        # Case: zero or one
        policy2text.each_key do |policy|
          multi = described_class.new(0, 1, policy)
          expect(multi.to_str).to eq("?#{policy2text[policy]}")
        end

        # Case: zero or more
        policy2text.each_key do |policy|
          multi = described_class.new(0, :more, policy)
          expect(multi.to_str).to eq("*#{policy2text[policy]}")
        end

        # Case: one or more
        policy2text.each_key do |policy|
          multi = described_class.new(1, :more, policy)
          expect(multi.to_str).to eq("+#{policy2text[policy]}")
        end

        # Case: exactly m times
        policy2text.each_key do |policy|
          samples = [1, 2, 5, 100]
          samples.each do |count|
            multi = described_class.new(count, count, policy)
            expect(multi.to_str).to eq("{#{count}}#{policy2text[policy]}")
          end
        end

        # Case: m, n times
        policy2text.each_key do |policy|
          samples = [1, 2, 5, 100]
          samples.each do |count|
            upper = count + 1 + rand(20)
            multi = described_class.new(count, upper, policy)
            expectation = "{#{count},#{upper}}#{policy2text[policy]}"
            expect(multi.to_str).to eq(expectation)
          end
        end

        # Case: m or more
        policy2text.each_key do |policy|
          samples = [2, 3, 5, 100]
          samples.each do |count|
            multi = described_class.new(count, :more, policy)
            expect(multi.to_str).to eq("{#{count},}#{policy2text[policy]}")
          end
        end
      end
      # rubocop: enable Style/CombinableLoops
    end
  end
end # module
# End of file
