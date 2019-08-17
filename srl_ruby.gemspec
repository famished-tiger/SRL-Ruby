# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'srl_ruby/version'

# Implementation module
module PkgExtending
  def self.pkg_files(aPackage)
    file_list = Dir[
      '.rubocop.yml',
      '.rspec',
      '.yardopts',
      'appveyor.yml',
      'cucumber.yml',
      'Gemfile',
      'Rakefile',
      'CHANGELOG.md',
      'LICENSE.txt',
      'README.md',
      'srl_ruby.gemspec',
      'bin/*.srl',
      'bin/*.rb',
      'features/*.*',
      'features/**/*.*',
      'features/**/**/*.features',
      'lib/*.*',
      'lib/**/*.rb',
      'spec/**/*.rb',
      'srl_test/**/*.*',
      'templates/*.erb'
    ]
    aPackage.files = file_list
    aPackage.test_files = Dir['spec/**/*_spec.rb']
    aPackage.require_path = 'lib'
  end

  def self.pkg_documentation(aPackage)
    aPackage.rdoc_options << '--charset=UTF-8 --exclude="examples|spec"'
    aPackage.extra_rdoc_files = ['README.md']
  end
end # module

Gem::Specification.new do |spec|
  spec.name          = 'srl_ruby'
  spec.version       = SrlRuby::VERSION
  spec.authors       = ['Dimitri Geshef']
  spec.email         = ['famished.tiger@yahoo.com']

  spec.description   = <<-DESCR
  A compiler and library that transforms highly readable Simple Regex Language
  patterns into regular expressions.
DESCR
  spec.summary = <<-SUMMARY
  A parser for the [Simple Regex Language](https://simple-regex.com/).
  It translates patterns expressed in SRL into plain Ruby Regexp objects
  or in regex literals. Use self-documenting, human readable, SRL expressions
  to craft your new awesome regular expressions.
SUMMARY
  spec.homepage      = 'https://github.com/famished-tiger/SRL-Ruby'
  spec.license       = 'MIT'

  spec.bindir = 'bin'
  spec.executables << 'srl2ruby'
  spec.require_paths = ['lib']
  PkgExtending.pkg_files(spec)
  PkgExtending.pkg_documentation(spec)
  spec.required_ruby_version = '>= 2.3.0'

  # Runtime dependencies
  spec.add_dependency 'rley', '~> 0.7.00'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.0.0'
  spec.add_development_dependency 'cucumber', '>= 2.2.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
