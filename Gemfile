source 'https://rubygems.org'

# Specify your gem's dependencies in crucible_ci.gemspec
gemspec

# gem 'plan_executor', git: 'https://github.com/fhir-crucible/plan_executor.git', :branch => 'master'
gem 'plan_executor', path: '../plan_executor'
gem 'fhir_models', git: 'https://github.com/fhir-crucible/fhir_models.git', branch: 'master'
gem 'fhir_client', git: 'https://github.com/fhir-crucible/fhir_client.git', branch: 'master'

group :test do
  gem 'pry'
  gem 'pry-nav'
end
