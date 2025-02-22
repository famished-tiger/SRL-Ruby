# frozen_string_literal: true

require_relative '../spec_helper'
require_relative 'support/rule_file_parser'
require_relative '../../lib/srl_ruby'

##############################
# Some rule files contain undocumented and unsupportd SRL expression:
# | File name        | unrecognized input |
# | no_word.rule     | 'no word'          |
# | none_of.rule     | 'none of abcd'     |
# | word.rule        | '(word)'           |


RSpec.describe SrlRuby do
  def rule_path
    __FILE__.sub(/spec\/.+$/, 'srl_test/Test-Rules/')
  end

  def load_file(aFilename)
    Acceptance::RuleFileParser.load_file(rule_path + aFilename)
  end

  def test_rule_file(aRuleFileRepr)
    regex = SrlRuby::parse(aRuleFileRepr.srl.value)
    # puts regex.source
    expect(regex).to be_a(Regexp)

    aRuleFileRepr.match_tests.each do |test|
      expect(test.test_string.value).to match(regex)
    end
    aRuleFileRepr.no_match_tests.each do |test|
      expect(regex.match(test.test_string.value)).to be_nil
    end
    aRuleFileRepr.capture_tests.each do |cp_test|
      test_string = cp_test.test_string.value
      expect(test_string).to match(regex)
      if regex.names.empty?
        indices = cp_test.expectations.map { |exp| exp.result_index.value.to_s }
        actual_names = indices.uniq.sort
      else
        actual_names = regex.names
      end

      # CaptureExpectation = Struct.new(:result_index, :var_name, :captured_text)
      # Compare actual vs. expected capture names
      cp_test.expectations.each do |expec|
        expected_name = expec.var_name.value.to_s
        unless actual_names.empty?
          expect(actual_names).to include(expected_name)
        end
      end

      scan_results = test_string.scan(regex)
      actual_captures = scan_results.map do |capture_tuples|
        actual_names.zip(capture_tuples).to_h
      end

      # Compare actual vs. expected captured texts
      cp_test.expectations.each do |expec|
        index =  expec.result_index.value
        var_name = expec.var_name.value.to_s
        expected_capture = expec.captured_text.value
        names2val = actual_captures[index]
        actual = names2val[var_name].nil? ? '' : names2val[var_name]
        expect(actual).to eq(expected_capture)
      end
    end
  end

  it 'matches a backslash' do
    rule_file_repr = load_file('backslash.rule')
    test_rule_file(rule_file_repr)
  end

  it 'supports named capture group' do
    rule_file_repr = load_file('basename_capture_group.rule')
    test_rule_file(rule_file_repr)
  end

  it 'matches uppercase letter(s)' do
    rule_file_repr = load_file('issue_17_uppercase_letter.rule')
    test_rule_file(rule_file_repr)
  end

  it "doesn't trim literal strings" do
    rule_file_repr = load_file('literally_spaces.rule')
    test_rule_file(rule_file_repr)
  end

  it 'supports non word boundary' do
    rule_file_repr = load_file('no_word.rule')
    test_rule_file(rule_file_repr)
  end

  it 'matches non digit pattern' do
    rule_file_repr = load_file('nondigit.rule')
    test_rule_file(rule_file_repr)
  end

  it 'supports negative character class' do
    rule_file_repr = load_file('none_of.rule')
    test_rule_file(rule_file_repr)
  end

  it 'supports negative character class' do
    rule_file_repr = load_file('sample_capture.rule')
    test_rule_file(rule_file_repr)
  end

  it 'matches a tab' do
    rule_file_repr = load_file('tab.rule')
    test_rule_file(rule_file_repr)
  end

  it 'matches mail address' do
    rule_file_repr = load_file('website_example_email.rule')
    test_rule_file(rule_file_repr)
  end

  it 'matches mail address' do
    rule_file_repr = load_file('website_example_email_capture.rule')
    test_rule_file(rule_file_repr)
  end

  it 'supports lookahead' do
    rule_file_repr = load_file('website_example_lookahead.rule')
    test_rule_file(rule_file_repr)
  end

  it "doesn't trim literal strings" do
    rule_file_repr = load_file('website_example_password.rule')
    test_rule_file(rule_file_repr)
  end

  it 'processes an URL' do
    rule_file_repr = load_file('website_example_url.rule')
    test_rule_file(rule_file_repr)
  end

  it 'matches a word boundary' do
    rule_file_repr = load_file('word.rule')
    test_rule_file(rule_file_repr)
  end
end # describe
