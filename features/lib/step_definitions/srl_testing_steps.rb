When("I define the following SRL expression:") do |srl_source|
  @regex = SrlRuby::parse(srl_source)
end

When("I use the text {string}") do |test_string|
  @subject = test_string
end

Then("I expect the generated regular expression to be {string}") do |regex_source|
  expect(@regex.source).to eq(regex_source)
end

Then("I expect matching for:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  values = table.raw.flatten.map { |raw_val| raw_val.gsub(/^"|"$/, '') }
  values.each do |val|
    expect(val).to match(@regex)
  end
end

Then("I expect no match for:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  values = table.raw.flatten.map { |raw_val| raw_val.gsub(/^"|"$/, '') }
  values.each do |val|
    expect(val).not_to match(@regex)
  end
end


Then(/I expect the (first|second|third|fourth|fifth) captures? to be:/) do |rank_literal, table|
  ordinal2indices = { 'first' => 0, 
    'second' => 1, 
    'third' => 2,
    'fourth' => 3, 
    'fifth' => 4
  }
  rank = ordinal2indices[rank_literal]
  # table is a Cucumber::MultilineArgument::DataTable
  expectations = table.rows_hash
  
  scan_results = @subject.scan(@regex)
  actuals = scan_results[rank]
  if actuals.nil?
    puts "Big issue"
    puts @regex.source
  end

  if @regex.names.empty?
    capture_names = (0..actuals.size-1).to_a.map(&:to_s)
  else
    capture_names = @regex.names
  end

  capture_names.each_with_index do |var_name, index|
    if expectations.include?(var_name)
      expect(expectations[var_name]).to eq(actuals[index])
    end
  end
end
