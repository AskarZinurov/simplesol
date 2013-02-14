# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simplesol/version'

Gem::Specification.new do |gem|
  gem.name          = "simplesol"
  gem.version       = Simplesol::VERSION
  gem.authors       = ["Askar Zinurov"]
  gem.email         = ["mail@asktim.ru"]
  gem.description   = %q{SimpleSol service client gem}
  gem.summary       = %q{Gem for working with sms.simplesol.ru}
  gem.homepage      = ""
  
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec'
  gem.add_runtime_dependency 'faraday'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
