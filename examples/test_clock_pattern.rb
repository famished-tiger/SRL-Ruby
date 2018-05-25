# Next Regexp was copy-pasted from srl2ruby output
pattern = /(?i-mx:^(?<hour>(?:(?:0?\d)|(?:1[01]))):(?<min>(?:0?|[1-5])\d)\s?[AP]M$)/
text = '1:43am'

matching = pattern.match(text)
if matching
  print 'Capture names: '; p(matching.names) # => Capture names: ["hour", "min"]
  puts "Value of 'hour': #{matching[:hour]}" # => Value of 'hour': 1
  puts "Value of 'min': #{matching[:min]}" # => Value of 'min': 43
else
  puts "Text '#{text}' doesn't match."
end