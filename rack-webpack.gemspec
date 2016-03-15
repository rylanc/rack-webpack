# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack_webpack/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-webpack'
  spec.version       = RackWebpack::VERSION
  spec.authors       = ['James Shkolnik', 'Nikhil Mathew']
  spec.email         = ['dev@gusto.com']
  spec.description   = ""
  spec.summary       = ""
  spec.homepage      = 'https://github.com/gusto/xxx'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']



  # spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.3'
  # spec.add_development_dependency 'vcr', '~> 3.0'
  # spec.add_development_dependency 'webmock', '< 1.12'
  spec.add_development_dependency 'bundler-audit', '~> 0.4'
  spec.add_development_dependency 'rack'

  spec.add_dependency 'curb', '>= 0.9.0'
end
