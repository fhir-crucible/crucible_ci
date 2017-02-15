# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crucible_ci/version'

Gem::Specification.new do |spec|
  spec.name = 'crucible_ci'
  spec.license = 'Apache-2.0'
  spec.version       = CrucibleCi::VERSION
  spec.authors       = ["Michael O'Keefe"]
  spec.email         = ['mokeefe@mitre.org']

  spec.summary       = 'A way to run Plan Executor tests in the command line'
  spec.homepage      = 'https://github.com/fhir-crucible/crucible_ci'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('rake')
  spec.add_dependency('methadone', '~> 1.9.2')
  spec.add_development_dependency('test-unit')
  spec.add_dependency('plan_executor', '~> 1.8')
end
