# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onesnooper_server/version'

Gem::Specification.new do |spec|
  spec.name          = 'onesnooper-server'
  spec.version       = OnesnooperServer::VERSION
  spec.authors       = ['Boris Parak']
  spec.email         = ['parak@cesnet.cz']
  spec.summary       = 'Simple server snooping on and recording OpenNebula\'s VM & Host monitoring traffic'
  spec.description   = 'Simple server snooping on and recording OpenNebula\'s VM & Host monitoring traffic'
  spec.homepage      = 'https://github.com/arax/onesnooper-server'
  spec.license       = 'Apache License, Version 2.0'

  spec.files                 = `git ls-files -z`.split("\x0")
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ['lib']
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0.0'
  spec.add_development_dependency 'simplecov', '~> 0.9.0'
  spec.add_development_dependency 'rubygems-tasks', '~> 0.2.4'

  spec.add_runtime_dependency 'eventmachine', '~> 1.0.4'
  spec.add_runtime_dependency 'syslogger', '~> 1.6.0'
  spec.add_runtime_dependency 'sequel', '~> 4.18.0'
  spec.add_runtime_dependency 'settingslogic', '~> 2.0.9'
end
