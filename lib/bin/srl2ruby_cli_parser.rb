# frozen_string_literal: true

require 'optparse' # Use standard OptionParser class for command-line parsing

# A command-line option parser for the srl2ruby compiler.
# It is a specialisation of the OptionParser class.
class Srl2RubyCLIParser < OptionParser
  # @return [Hash{Symbol=>String, Array}]
  attr_reader(:parsed_options)

  # Constructor.
  def initialize(prog_name, ver)
    super()
    reset(prog_name, ver)

    heading
    separator 'Options:'
    add_p_option
    add_o_option
    add_t_option
    separator ''
    add_tail_options
  end

  def parse!(args)
    super
    parsed_options
  end

  private

  def reset(prog_name, ver)
    @program_name = prog_name
    @version = ver
    @banner = "Usage: #{prog_name} SRL_FILE [options]"
    @parsed_options = {}
  end

  def description
    descr = <<-DESCR
Description:
  Parses a SRL file and compiles it into a Ruby Regexp literal.
  Simple Regex Language (SRL) website: https://simple-regex.com

Examples:
  #{program_name} example.srl
  #{program_name} -p 'begin with literally "Hello world!"'
  #{program_name} example.srl -o example_re.rb -t srl_and_ruby.erb
DESCR

    descr
  end

  def heading
    banner
    separator ''
    separator description
    separator ''
  end

  def add_o_option
    explanation = 'Output to a file with specified name.'

    on '-o', '--output-file PATH', explanation do |pathname|
      @parsed_options[:output] = pathname
    end
  end

  def add_p_option
    explanation = 'One-liner SRL pattern.'

    on '-p', '--pattern SRL_PATT', explanation do |pattern_arg|
       @parsed_options[:pattern] = pattern_arg.gsub(/^'|'$/, '')
    end
  end

  def add_t_option
    explanation = <<-EXPLANATION
Use given ERB template for the Ruby code generation. srl2ruby looks for
the template file in current dir first then in its gem's /templates dir.
EXPLANATION

    on '-t', '--template-file TEMPLATE', explanation do |template|
      @parsed_options[:template] = template
    end
  end

  def add_tail_options
    on_tail('--version', 'Display the program version then quit.') do
      puts version
      exit(0)
    end

    on_tail('-?', '-h', '--help', 'Display this help then quit.') do
      puts help
      exit(0)
    end
  end
end # class

# End of file
