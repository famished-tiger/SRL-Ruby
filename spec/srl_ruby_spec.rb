require_relative 'spec_helper' # Use the RSpec framework
require_relative '../lib/srl_ruby'

describe SrlRuby do
  context 'Parsing character ranges:' do
    it "should parse 'letter from ... to ...' syntax" do
      regexp = SrlRuby.parse('letter from a to f')
      expect(regexp.source).to eq('[a-f]')
    end

    it "should parse 'uppercase letter from ... to ...' syntax" do
      regexp = SrlRuby.parse('UPPERCASE letter from A to F')
      expect(regexp.source).to eq('[A-F]')
    end

    it "should parse 'letter' syntax" do
      regexp = SrlRuby.parse('letter')
      expect(regexp.source).to eq('[a-z]')
    end

    it "should parse 'uppercase letter' syntax" do
      regexp = SrlRuby.parse('uppercase letter')
      expect(regexp.source).to eq('[A-Z]')
    end

    it "should parse 'digit from ... to ...' syntax" do
      regexp = SrlRuby.parse('digit from 1 to 4')
      expect(regexp.source).to eq('[1-4]')
    end
  end # context

  context 'Parsing string literals:' do
    it 'should parse double quotes literal string' do
      regexp = SrlRuby.parse('literally "hello"')
      expect(regexp.source).to eq('hello')
    end

    it 'should parse single quotes literal string' do
      regexp = SrlRuby.parse("literally 'hello'")
      expect(regexp.source).to eq('hello')
    end

    it 'should escape special characters' do
      regexp = SrlRuby.parse("literally '.'")
      expect(regexp.source).to eq('\.')
    end
    
    it 'should parse single quotes literal string' do
      regexp = SrlRuby.parse('literally "an", whitespace, raw "[a-zA-Z]"')
      expect(regexp.source).to eq('an\s[a-zA-Z]')
    end
  end # context

  context 'Parsing character classes:' do
    it "should parse 'digit' syntax" do
      regexp = SrlRuby.parse('digit')
      expect(regexp.source).to eq('\d')
    end

    it "should parse 'number' syntax" do
      regexp = SrlRuby.parse('number')
      expect(regexp.source).to eq('\d')
    end
    
    it "should parse 'no digit' syntax" do
      regexp = SrlRuby.parse('no digit')
      expect(regexp.source).to eq('\D')
    end

    it "should parse 'any character' syntax" do
      regexp = SrlRuby.parse('any character')
      expect(regexp.source).to eq('\w')
    end

    it "should parse 'no character' syntax" do
      regexp = SrlRuby.parse('no character')
      expect(regexp.source).to eq('\W')
    end

    it "should parse 'whitespace' syntax" do
      regexp = SrlRuby.parse('whitespace')
      expect(regexp.source).to eq('\s')
    end

    it "should parse 'no whitespace' syntax" do
      regexp = SrlRuby.parse('no whitespace')
      expect(regexp.source).to eq('\S')
    end

    it "should parse 'anything' syntax" do
      regexp = SrlRuby.parse('anything')
      expect(regexp.source).to eq('.')
    end

    it "should parse 'one of' syntax" do
      regexp = SrlRuby.parse('one of "._%+-"')
      # Remark: reference implementation less readable
      # (escapes more characters than required)
      expect(regexp.source).to eq('[._%+\-]')
    end
    
    it "should parse 'one of' with unquoted character class syntax" do
      # Case of digit sequence
      regexp = SrlRuby.parse('one of 13579, must end')
      expect(regexp.source).to eq('[13579]$')
      
      # Case of identifier-like character class
      regexp = SrlRuby.parse('one of abcd, must end')
      expect(regexp.source).to eq('[abcd]$')

      # Case of arbitrary character class
      regexp = SrlRuby.parse('one of 12hms:, must end')
      expect(regexp.source).to eq('[12hms:]$')       
    end    
    
    it "should parse 'none of' syntax" do
      regexp = SrlRuby.parse('none of "._%+-"')
      # Remark: reference implementation less readable
      # (escapes more characters than required)
      expect(regexp.source).to eq('[^._%+\-]')
    end 

    it "should parse 'none of' with unquoted character class syntax" do
      # Case of digit sequence
      regexp = SrlRuby.parse('none of 13579, must end')
      expect(regexp.source).to eq('[^13579]$')
      
      # Case of identifier-like character class
      regexp = SrlRuby.parse('none of abcd, must end')
      expect(regexp.source).to eq('[^abcd]$')

      # Case of arbitrary character class
      regexp = SrlRuby.parse('none of 12hms:^, must end')
      expect(regexp.source).to eq('[^12hms:\^]$')       
    end    
  end # context

  context 'Parsing special character declarations:' do
    it "should parse 'tab' syntax" do
      regexp = SrlRuby.parse('tab')
      expect(regexp.source).to eq('\t')
    end
    
    it "should parse 'vertical tab' syntax" do
      regexp = SrlRuby.parse('vertical tab')
      expect(regexp.source).to eq('\v')
    end

    it "should parse 'backslash' syntax" do
      regexp = SrlRuby.parse('backslash')
      expect(regexp.source).to eq('\\\\')
    end

    it "should parse 'new line' syntax" do
      regexp = SrlRuby.parse('new line')
      expect(regexp.source).to eq('\n')
    end
    
    it "should parse 'carriage return' syntax" do
      regexp = SrlRuby.parse('carriage return')
      expect(regexp.source).to eq('\r')
    end 

    it "should parse 'word' syntax" do
      regexp = SrlRuby.parse('word, literally "is"')
      expect(regexp.source).to eq('\bis')
    end 

    it "should parse 'no word' syntax" do
      regexp = SrlRuby.parse('no word, literally "is"')
      expect(regexp.source).to eq('\Bis')
    end    
  end # context

  context 'Parsing alternations:' do
    it "should parse 'any of' syntax" do
      source = 'any of (any character, one of "._%-+")'
      regexp = SrlRuby.parse(source)
      expect(regexp.source).to eq('(?:\w|[._%\-+])')
    end 

    it "should parse 'either of' syntax" do
      source = 'either of (any character, one of "._%-+")'
      regexp = SrlRuby.parse(source)
      expect(regexp.source).to eq('(?:\w|[._%\-+])')
    end    
    
    it 'should anchor as alternative' do
      regexp = SrlRuby.parse('any of (literally "?", must end)')
      expect(regexp.source).to eq('(?:\\?|$)')
    end    
  end # context

  context 'Parsing concatenation:' do
    it 'should reject dangling comma' do
      source = 'literally "a",'
      err = StandardError
      msg_pattern = /Premature end of input after ',' at position line 1, column 14/      
      expect { SrlRuby.parse(source) }.to raise_error(err, msg_pattern)
    end

    it 'should parse concatenation' do
      regexp = SrlRuby.parse('any of (literally "sample", (digit once or more))')
      expect(regexp.source).to eq('(?:sample|(?:\d+))')
    end

    it 'should parse a long sequence of patterns' do
      source = <<-END_SRL
      any of (any character, one of "._%-+") once or more,
      literally "@",
      any of (digit, letter, one of ".-") once or more,
      literally ".",
      letter at least 2 times
END_SRL

      regexp = SrlRuby.parse(source)
      # SRL: (?:\w|[\._%\-\+])+(?:@)(?:[0-9]|[a-z]|[\.\-])+(?:\.)[a-z]{2,}
      expectation = '(?:\w|[._%\-+])+@(?:\d|[a-z]|[.\-])+\.[a-z]{2,}'
      expect(regexp.source).to eq(expectation)
    end
  end # context

  context 'Parsing quantifiers:' do
    let(:prefix) { 'letter from p to t ' }

    it "should parse 'once' syntax" do
      regexp = SrlRuby.parse(prefix + 'once')
      expect(regexp.source).to eq('[p-t]{1}')
    end

    it "should parse 'twice' syntax" do
      regexp = SrlRuby.parse('digit twice')
      expect(regexp.source).to eq('\d{2}')
    end

    it "should parse 'optional' syntax" do
      regexp = SrlRuby.parse('anything optional')
      expect(regexp.source).to eq('.?')
    end

    it "should parse 'exactly ... times' syntax" do
      regexp = SrlRuby.parse('letter from a to f exactly 4 times')
      expect(regexp.source).to eq('[a-f]{4}')
    end

    it "should parse 'between ... and ... times' syntax" do
      regexp = SrlRuby.parse(prefix + 'between 2 and 4 times')
      expect(regexp.source).to eq('[p-t]{2,4}')
      
      # Dropping 'times' keyword is a shorter alternative syntax
      regexp = SrlRuby.parse(prefix + 'between 2 and 4') 
      expect(regexp.source).to eq('[p-t]{2,4}')
    end

    it "should parse 'once or more' syntax" do
      regexp = SrlRuby.parse(prefix + 'once or more')
      expect(regexp.source).to eq('[p-t]+')
    end

    it "should parse 'never or more' syntax" do
      regexp = SrlRuby.parse(prefix + 'never or more')
      expect(regexp.source).to eq('[p-t]*')
    end

    it "should parse 'at least  ... times' syntax" do
      regexp = SrlRuby.parse(prefix + 'at least 10 times')
      expect(regexp.source).to eq('[p-t]{10,}')
    end
  end # context

  context 'Parsing lookaround:' do
    it 'should parse positive lookahead' do
      regexp = SrlRuby.parse('letter if followed by (anything once or more, digit)')
      expect(regexp.source).to eq('[a-z](?=(?:.+\d))')
    end

    it 'should parse negative lookahead' do
      regexp = SrlRuby.parse('letter if not followed by (anything once or more, digit)')
      expect(regexp.source).to eq('[a-z](?!(?:.+\d))')
    end

    it 'should parse positive lookbehind' do
      regexp = SrlRuby.parse('literally "bar" if already had literally "foo"')
      expect(regexp.source).to eq('bar(?<=foo)')
    end

    it 'should parse negative lookbehind' do
      regexp = SrlRuby.parse('literally "bar" if not already had literally "foo"')
      expect(regexp.source).to eq('bar(?<!foo)')
    end
  end # context

  context 'Parsing capturing group:' do
    it 'should parse simple anonymous capturing group' do
      regexp = SrlRuby.parse('capture(literally "sample")')
      expect(regexp.source).to eq('(sample)')
    end

    it 'should parse complex anonymous capturing group' do
      source = 'capture(any of (literally "sample", (digit once or more)))'
      regexp = SrlRuby.parse(source)
      expect(regexp.source).to eq('((?:sample|(?:\d+)))')
    end

    it 'should parse simple anonymous until capturing group' do
      regexp = SrlRuby.parse('capture anything once or more until literally "!"')
      expect(regexp.source).to eq('(.+?)!')
    end

    it 'should parse unquoted named capturing group' do
      source = 'capture (anything once or more) as first, must end'
      regexp = SrlRuby.parse(source)
      expect(regexp.source).to eq('(?<first>.+)$')
    end
    
    it 'should parse complex named capturing group' do
      source = <<-END_SRL
capture(any of (literally "sample", (digit once or more)))
  as "foo"
END_SRL
      regexp = SrlRuby.parse(source)
      expect(regexp.source).to eq('(?<foo>(?:sample|(?:\d+)))')
    end

    it 'should parse a sequence with named capturing groups' do
      source = <<-END_SRL
      capture (anything once or more) as "first",
      literally " - ",
      capture literally "second part" as "second"
END_SRL
      regexp = SrlRuby.parse(source)
      expect(regexp.source).to eq('(?<first>.+) - (?<second>second part)')
    end

    it 'should parse complex named until capturing group' do
      source = 'capture (anything once or more) as "foo" until literally "m"'
      regexp = SrlRuby.parse(source)
      expect(regexp.source).to eq('(?<foo>.+?)m')
    end
  end # context

  context 'Parsing anchors:' do
    it 'should parse begin anchors' do
      regexp = SrlRuby.parse('starts with literally "match"')
      expect(regexp.source).to eq('^match')
    end

    it 'should parse begin anchors (alternative syntax)' do
      regexp = SrlRuby.parse('begin with literally "match"')
      expect(regexp.source).to eq('^match')
    end

    it 'should parse end anchors' do
      regexp = SrlRuby.parse('literally "match" must end')
      expect(regexp.source).to eq('match$')
    end

    it 'should parse combination of begin and end anchors' do
      regexp = SrlRuby.parse('starts with literally "match" must end')
      expect(regexp.source).to eq('^match$')
    end

    it 'should accept anchor with a sequence of patterns' do
      source = <<-END_SRL
      begin with any of (digit, letter, one of ".-") once or more,
      literally ".",
      letter at least 2 times must end
END_SRL

      regexp = SrlRuby.parse(source)
      # SRL: (?:\w|[\._%\-\+])+(?:@)(?:[0-9]|[a-z]|[\.\-])+(?:\.)[a-z]{2,}
      expect(regexp.source).to eq('^(?:\d|[a-z]|[.\-])+\.[a-z]{2,}$')
    end        
  end # context
end # describe
# End of file
