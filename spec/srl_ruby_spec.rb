# frozen_string_literal: true

require_relative 'spec_helper' # Use the RSpec framework
require_relative '../lib/srl_ruby'

describe SrlRuby do
  context 'Parsing character ranges:' do
    it "parses 'letter from ... to ...' syntax" do
      regexp = described_class.parse('letter from a to f')
      expect(regexp.source).to eq('[a-f]')
    end

    it "parses 'uppercase letter from ... to ...' syntax" do
      regexp = described_class.parse('UPPERCASE letter from A to F')
      expect(regexp.source).to eq('[A-F]')
    end

    it "parses 'letter' syntax" do
      regexp = described_class.parse('letter')
      expect(regexp.source).to eq('[a-z]')
    end

    it "parses 'uppercase letter' syntax" do
      regexp = described_class.parse('uppercase letter')
      expect(regexp.source).to eq('[A-Z]')
    end

    it "parses 'digit from ... to ...' syntax" do
      regexp = described_class.parse('digit from 1 to 4')
      expect(regexp.source).to eq('[1-4]')
    end
  end # context

  context 'Parsing string literals:' do
    it 'parses double quotes literal string' do
      regexp = described_class.parse('literally "hello"')
      expect(regexp.source).to eq('hello')
    end

    it 'parses single quotes literal string' do
      regexp = described_class.parse("literally 'hello'")
      expect(regexp.source).to eq('hello')
    end

    it 'Escapes special characters' do
      regexp = described_class.parse("literally '.'")
      expect(regexp.source).to eq('\.')
    end

    it 'parses single quotes literal string' do
      regexp = described_class.parse('literally "an", whitespace, raw "[a-zA-Z]"')
      expect(regexp.source).to eq('an\s[a-zA-Z]')
    end
  end # context

  context 'Parsing character classes:' do
    it "parses 'digit' syntax" do
      regexp = described_class.parse('digit')
      expect(regexp.source).to eq('\d')
    end

    it "parses 'number' syntax" do
      regexp = described_class.parse('number')
      expect(regexp.source).to eq('\d')
    end

    it "parses 'no digit' syntax" do
      regexp = described_class.parse('no digit')
      expect(regexp.source).to eq('\D')
    end

    it "parses 'any character' syntax" do
      regexp = described_class.parse('any character')
      expect(regexp.source).to eq('\w')
    end

    it "parses 'no character' syntax" do
      regexp = described_class.parse('no character')
      expect(regexp.source).to eq('\W')
    end

    it "parses 'whitespace' syntax" do
      regexp = described_class.parse('whitespace')
      expect(regexp.source).to eq('\s')
    end

    it "parses 'no whitespace' syntax" do
      regexp = described_class.parse('no whitespace')
      expect(regexp.source).to eq('\S')
    end

    it "parses 'anything' syntax" do
      regexp = described_class.parse('anything')
      expect(regexp.source).to eq('.')
    end

    it "parses 'one of' syntax" do
      regexp = described_class.parse('one of "._%+-"')
      # Remark: reference implementation less readable
      # (escapes more characters than required)
      expect(regexp.source).to eq('[._%+\-]')
    end

    it "parses 'one of' with unquoted character class syntax" do
      # Case of digit sequence
      regexp = described_class.parse('one of 13579, must end')
      expect(regexp.source).to eq('[13579]$')

      # Case of identifier-like character class
      regexp = described_class.parse('one of abcd, must end')
      expect(regexp.source).to eq('[abcd]$')

      # Case of arbitrary character class
      regexp = described_class.parse('one of 12hms:, must end')
      expect(regexp.source).to eq('[12hms:]$')
    end

    it "parses 'none of' syntax" do
      regexp = described_class.parse('none of "._%+-"')
      # Remark: reference implementation less readable
      # (escapes more characters than required)
      expect(regexp.source).to eq('[^._%+\-]')
    end

    it "parses 'none of' with unquoted character class syntax" do
      # Case of digit sequence
      regexp = described_class.parse('none of 13579, must end')
      expect(regexp.source).to eq('[^13579]$')

      # Case of identifier-like character class
      regexp = described_class.parse('none of abcd, must end')
      expect(regexp.source).to eq('[^abcd]$')

      # Case of arbitrary character class
      regexp = described_class.parse('none of 12hms:^, must end')
      expect(regexp.source).to eq('[^12hms:\^]$')
    end
  end # context

  context 'Parsing special character declarations:' do
    it "parses 'tab' syntax" do
      regexp = described_class.parse('tab')
      expect(regexp.source).to eq('\t')
    end

    it "parses 'vertical tab' syntax" do
      regexp = described_class.parse('vertical tab')
      expect(regexp.source).to eq('\v')
    end

    it "parses 'backslash' syntax" do
      regexp = described_class.parse('backslash')
      expect(regexp.source).to eq('\\\\')
    end

    it "parses 'new line' syntax" do
      regexp = described_class.parse('new line')
      expect(regexp.source).to eq('\n')
    end

    it "parses 'carriage return' syntax" do
      regexp = described_class.parse('carriage return')
      expect(regexp.source).to eq('\r')
    end

    it "parses 'word' syntax" do
      regexp = described_class.parse('word, literally "is"')
      expect(regexp.source).to eq('\bis')
    end

    it "parses 'no word' syntax" do
      regexp = described_class.parse('no word, literally "is"')
      expect(regexp.source).to eq('\Bis')
    end
  end # context

  context 'Parsing alternations:' do
    it "parses 'any of' syntax" do
      source = 'any of (any character, one of "._%-+")'
      regexp = described_class.parse(source)
      expect(regexp.source).to eq('(?:\w|[._%\-+])')
    end

    it "parses 'either of' syntax" do
      source = 'either of (any character, one of "._%-+")'
      regexp = described_class.parse(source)
      expect(regexp.source).to eq('(?:\w|[._%\-+])')
    end

    it 'Anchors as alternative' do
      regexp = described_class.parse('any of (literally "?", must end)')
      expect(regexp.source).to eq('(?:\\?|$)')
    end
  end # context

  context 'Parsing concatenation:' do
    it 'Rejects dangling comma' do
      source = 'literally "a",'
      err = StandardError
      msg_pattern = /Premature end of input after ',' at position line 1, column 14/
      expect { described_class.parse(source) }.to raise_error(err, msg_pattern)
    end

    it 'parses concatenation' do
      regexp = described_class.parse('any of (literally "sample", (digit once or more))')
      expect(regexp.source).to eq('(?:sample|(?:\d+))')
    end

    it 'parses a long sequence of patterns' do
      source = <<-SRL
      any of (any character, one of "._%-+") once or more,
      literally "@",
      any of (digit, letter, one of ".-") once or more,
      literally ".",
      letter at least 2 times
SRL

      regexp = described_class.parse(source)
      # SRL: (?:\w|[\._%\-\+])+(?:@)(?:[0-9]|[a-z]|[\.\-])+(?:\.)[a-z]{2,}
      expectation = '(?:\w|[._%\-+])+@(?:\d|[a-z]|[.\-])+\.[a-z]{2,}'
      expect(regexp.source).to eq(expectation)
    end
  end # context

  context 'Parsing quantifiers:' do
    let(:prefix) { 'letter from p to t ' }

    it "parses 'once' syntax" do
      regexp = described_class.parse("#{prefix}once")
      expect(regexp.source).to eq('[p-t]{1}')
    end

    it "parses 'twice' syntax" do
      regexp = described_class.parse('digit twice')
      expect(regexp.source).to eq('\d{2}')
    end

    it "parses 'optional' syntax" do
      regexp = described_class.parse('anything optional')
      expect(regexp.source).to eq('.?')
    end

    it "parses 'exactly ... times' syntax" do
      regexp = described_class.parse('letter from a to f exactly 4 times')
      expect(regexp.source).to eq('[a-f]{4}')
    end

    it "parses 'between ... and ... times' syntax" do
      regexp = described_class.parse("#{prefix}between 2 and 4 times")
      expect(regexp.source).to eq('[p-t]{2,4}')

      # Dropping 'times' keyword is a shorter alternative syntax
      regexp = described_class.parse("#{prefix}between 2 and 4")
      expect(regexp.source).to eq('[p-t]{2,4}')
    end

    it "parses 'once or more' syntax" do
      regexp = described_class.parse("#{prefix}once or more")
      expect(regexp.source).to eq('[p-t]+')
    end

    it "parses 'never or more' syntax" do
      regexp = described_class.parse("#{prefix}never or more")
      expect(regexp.source).to eq('[p-t]*')
    end

    it "parses 'at least ... times' syntax" do
      regexp = described_class.parse("#{prefix}at least 10 times")
      expect(regexp.source).to eq('[p-t]{10,}')
    end
  end # context

  context 'Parsing lookaround:' do
    it 'parses positive lookahead' do
      regexp = described_class.parse('letter if followed by (anything once or more, digit)')
      expect(regexp.source).to eq('[a-z](?=(?:.+\d))')
    end

    it 'parses negative lookahead' do
      regexp = described_class.parse('letter if not followed by (anything once or more, digit)')
      expect(regexp.source).to eq('[a-z](?!(?:.+\d))')
    end

    it 'parses positive lookbehind' do
      regexp = described_class.parse('literally "bar" if already had literally "foo"')
      expect(regexp.source).to eq('(?<=foo)bar')
    end

    it 'parses negative lookbehind' do
      regexp = described_class.parse('literally "bar" if not already had literally "foo"')
      expect(regexp.source).to eq('(?<!foo)bar')
    end
  end # context

  context 'Parsing capturing group:' do
    it 'parses simple anonymous capturing group' do
      regexp = described_class.parse('capture(literally "sample")')
      expect(regexp.source).to eq('(sample)')
    end

    it 'parses complex anonymous capturing group' do
      source = 'capture(any of (literally "sample", (digit once or more)))'
      regexp = described_class.parse(source)
      expect(regexp.source).to eq('((?:sample|(?:\d+)))')
    end

    it 'parses simple anonymous until capturing group' do
      regexp = described_class.parse('capture anything once or more until literally "!"')
      expect(regexp.source).to eq('(.+?)!')
    end

    it 'parses unquoted named capturing group' do
      source = 'capture (anything once or more) as first, must end'
      regexp = described_class.parse(source)
      expect(regexp.source).to eq('(?<first>.+)$')
    end

    it 'parses complex named capturing group' do
      source = <<-SRL
  capture(any of (literally "sample", (digit once or more)))
  as "foo"
SRL
      regexp = described_class.parse(source)
      expect(regexp.source).to eq('(?<foo>(?:sample|(?:\d+)))')
    end

    it 'parses a sequence with named capturing groups' do
      source = <<-SRL
      capture (anything once or more) as "first",
      literally " - ",
      capture literally "second part" as "second"
SRL
      regexp = described_class.parse(source)
      expect(regexp.source).to eq('(?<first>.+) - (?<second>second part)')
    end

    it 'parses complex named until capturing group' do
      source = 'capture (anything once or more) as "foo" until literally "m"'
      regexp = described_class.parse(source)
      expect(regexp.source).to eq('(?<foo>.+?)m')
    end
  end # context

  context 'Parsing anchors:' do
    it 'parses begin anchors' do
      regexp = described_class.parse('starts with literally "match"')
      expect(regexp.source).to eq('^match')
      expect(regexp.to_s).to eq('(?-mix:^match)')
    end

    it 'parses begin anchors (alternative syntax)' do
      regexp = described_class.parse('begin with literally "match"')
      expect(regexp.source).to eq('^match')
    end

    it 'parses end anchors' do
      regexp = described_class.parse('literally "match" must end')
      expect(regexp.source).to eq('match$')
    end

    it 'parses combination of begin and end anchors' do
      regexp = described_class.parse('starts with literally "match" must end')
      expect(regexp.source).to eq('^match$')
    end

    it 'Accepts anchor with a sequence of patterns' do
      source = <<-SRL
      begin with any of (digit, letter, one of ".-") once or more,
      literally ".",
      letter at least 2 times must end
SRL

      regexp = described_class.parse(source)
      # SRL: (?:\w|[\._%\-\+])+(?:@)(?:[0-9]|[a-z]|[\.\-])+(?:\.)[a-z]{2,}
      expect(regexp.source).to eq('^(?:\d|[a-z]|[.\-])+\.[a-z]{2,}$')
    end
  end # context

  context 'Parsing flags' do
    it "parses 'case insensitive'" do
      regexp = described_class.parse('starts with literally "hello", case insensitive')
      expect(regexp.source).to eq('^hello')
      expect(regexp.to_s).to eq('(?i-mx:^hello)')
    end

    it "parses 'multi line'" do
      regexp = described_class.parse('starts with literally "hello", multi line')
      expect(regexp.source).to eq('^hello')
      expect(regexp.to_s).to eq('(?m-ix:^hello)')
    end

    it 'parses combined flags' do
      source = <<-SRL
      starts with literally "hello",
      multi line,
      case insensitive
SRL
      regexp = described_class.parse(source)
      expect(regexp.source).to eq('^hello')
      expect(regexp.to_s).to eq('(?mi-x:^hello)')
    end

    it "parses 'all lazy' flag" do
      source = <<-SRL
      begin with any of (digit, letter, one of ".-") once or more,
      literally ".",
      letter at least 2 times,
      must end,
      all lazy
SRL

      regexp = described_class.parse(source)
      expect(regexp.source).to eq('^(?:\d|[a-z]|[.\-])+?\.[a-z]{2,}?$')
    end
  end # context
end # describe
# End of file
