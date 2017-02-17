# CrucibleCI

CrucibleCI is a gem to run Crucible's [Plan Executor](https://github.com/fhir-crucible/plan_executor) tests against a FHIR server. It's intended for use in Continuous Integration and other testing systems to validate servers during development.

## Installation

Add this line to your application's Gemfile

```ruby
gem 'crucible_ci'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crucible_ci

## Usage

```shell
./bin/crucible_ci [options] server_url

```
Where `server_url` is the URL of a FHIR server accessible to the current computer.

### Options

* `-h`, `--help` - Displays this help message
* `-r`, `--resource` `VALUE` - The name of a FHIR Resource to be tested (such as `Patient` or `Encounter`)
* `-t`, `--test` `VALUE` - The name of a Plan Executor test to be tested (such as `HistoryTest`)
* `-a`, `--allowed-failures` `VALUE` - The number of failures allowed in the test suite (default: `0`)
* `-v`, `--version` - Show help/version info
* `--log-level` `LEVEL` Set the logging level (`debug`|`info`|`warn`|`error`|`fatal`) (default: `info`)

## Development

After checking out the repo, run `bin/crucible_ci_setup` to install dependencies. You can also run `bin/crucible_ci_console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fhir-crucible/crucible_ci.

Copyright (C) 2017 The MITRE Corporation.
