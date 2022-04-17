# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task' # Rspec as testing tool
# require 'cucumber/rake/task' # Cucumber as testing tool

# desc 'Run RSpec'
RSpec::Core::RakeTask.new(:spec)

# Cucumber::Rake::Task.new do |_|
  # # Comment
# end

# Combine RSpec and Cucumber tests
desc 'Run tests, with RSpec and Cucumber'
task test: :spec
# task test: %i[spec cucumber]


# Default rake task
task default: :test
