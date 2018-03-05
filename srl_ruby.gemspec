
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'srl_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'srl_ruby'
  spec.version       = SrlRuby::VERSION
  spec.authors       = ['Dimitri Geshef']
  spec.email         = ['famished.tiger@yahoo.com']

  spec.summary       = %q(Ruby implementation of the Simple Regex Language)
  spec.description   = %q(Ruby implementation of the Simple Regex Language)
  spec.homepage      = 'https://github.com/famished-tiger/SRL-Ruby'
  spec.license       = 'MIT'

  # spec.files = `git ls-files -z`.split('\x0').reject do |f|
    # f.match(%r{^(test|spec|features)/})
  # end
  spec.bindir = 'bin'
  spec.executables << 'srl_ruby'
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'rley', '~> 0.6.00'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
