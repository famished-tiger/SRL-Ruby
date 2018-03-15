require_relative '../spec_helper'
require_relative './support/rule_file_parser'
require_relative '../../lib/srl_ruby'

##############################
# Understand how parser fails when first rule begins with %[...] instead of %w[...]
##############################

RSpec.describe Acceptance do
  def rule_path
    __FILE__.sub(/spec\/.+$/, 'srl_test/Test-Rules/')
  end

  def load_file(aFilename)
    return Acceptance::RuleFileParser.load_file(rule_path + aFilename)
  end

  def test_rule_file(aRuleFileRepr)
    regex = SrlRuby::parse(aRuleFileRepr.srl.value)
    expect(regex).not_to be_nil
     
    aRuleFileRepr.match_tests.each do |test|
      expect(regex.match(test.test_string.value)).not_to be_nil
    end
    aRuleFileRepr.no_match_tests.each do |test|
      expect(regex.match(test.test_string.value)).to be_nil
    end
    aRuleFileRepr.capture_tests.each do |test|
      matching = regex.match(test.test_string.value)
      expect(matching).not_to be_nil
      test.expectations do |exp|
        var = exp.var_name.value.to_s
        captured = exp.captured_text.value
        name_index = matching.names.index(var)
        expect(name_index).not_to be_nil
        expect(matching.captures[name_index]).to eq(captured)
      end
    end
  end

  it 'should match a backslash' do
    rule_file_repr = load_file('backslash.rule')
    test_rule_file(rule_file_repr)
  end
  
  it 'should support named capture group' do
    rule_file_repr = load_file('basename_capture_group.rule')
    test_rule_file(rule_file_repr)
  end
  
  it 'should match uppercase letter(s)' do
    rule_file_repr = load_file('issue_17_uppercase_letter.rule')
    test_rule_file(rule_file_repr)
  end 
  
  it 'should not trim literal strings' do
    rule_file_repr = load_file('literally_spaces.rule')
    test_rule_file(rule_file_repr)
  end 

  it 'should match a tab' do
    rule_file_repr = load_file('tab.rule')
    test_rule_file(rule_file_repr)
  end

  it 'should match mail address' do
    rule_file_repr = load_file('website_example_email.rule')
    test_rule_file(rule_file_repr)
  end

  it 'should support lookahead' do
    rule_file_repr = load_file('website_example_lookahead.rule')
    test_rule_file(rule_file_repr)
  end
end