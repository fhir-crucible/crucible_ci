require 'crucible_ci/version'
require 'plan_executor'
require 'benchmark'

module CrucibleCi
  class Executor
    def self.execute(url, allowed_failures, test = nil, resource = nil, logger = nil)
      results = nil
      FHIR.logger = defined?(Rails) ? Rails.logger : logger
      b = Benchmark.measure do
        client = FHIR::Client.new(url)
        client.conformance_statement
        results = execute_test(client, test, resource)
      end
      puts "Execute #{test} completed in #{b.real} seconds."
      passing?(results, allowed_failures)
    end

    def self.execute_all(url, allowed_failures, logger = nil)
      results = nil
      FHIR.logger = defined?(Rails) ? Rails.logger : logger
      b = Benchmark.measure do
        client = FHIR::Client.new(url)
        client.conformance_statement
        results = execute_all(client)
      end
      puts "Execute All completed in #{b.real} seconds."
      passing?(results, allowed_failures)
    end

    def self.num_failures(results)
      statuses = results.collect { |_, v| v.collect { |r| r['status'] } }.flatten
      return statuses.count('fail') + statuses.count('error')
    end

    def self.passing?(results, allowed_failures)
      failures = num_failures(results)
      if failures > allowed_failures
        return 64
      else
        return 0
      end
    end

    def self.set_client_secrets(client, options)
      puts "Using OAuth2 Options: #{options}"
      print 'Enter client id: '
      client_id = STDIN.gets.chomp
      print 'Enter client secret: '
      client_secret = STDIN.gets.chomp
      if client_id != '' && client_secret != ''
        options[:client_id] = client_id
        options[:client_secret] = client_secret
        client.set_oauth2_auth(options[:client_id], options[:client_secret], options[:authorize_url], options[:token_url])
      else
        puts 'Ignoring OAuth2 credentials: empty id or secret. Using unsecured client...'
      end
    end

    def self.execute_test(client, key, resourceType = nil)
      executor = Crucible::Tests::Executor.new(client)
      test = executor.find_test(key)
      if test.nil?
        puts "Unable to find test: #{key}"
        return -1
      end
      results = nil
      if !resourceType.nil? && test.respond_to?(:resource_class=) && FHIR::RESOURCES.include?(resourceType)
        results = test.execute("FHIR::#{resourceType}".constantize)
      end
      results = executor.execute(test) if results.nil?
      output_results results
    end

    def self.execute_all(client)
      executor = Crucible::Tests::Executor.new(client)
      all_results = {}
      executor.tests.each do |test|
        next if test.multiserver
        results = executor.execute(test)
        all_results.merge! results
        output_results results
      end
      all_results
    end

    def self.execute_multiserver_test(client, client2, key)
      executor = Crucible::Tests::Executor.new(client, client2)
      output_results executor.execute(executor.find_test(key))
    end

    def self.collect_metadata(client, test)
      output_results Crucible::Tests::Executor.new(client).metadata(test), true
    end

    def self.write_result(status, test_name, message)
      tab_size = 10
      "#{' ' * (tab_size - status.length)}#{colorize(status)} #{test_name}: #{message}"
    end

    def self.colorize(status)
      case status.upcase
      when 'PASS'
        ANSI.green { status.upcase }
      when 'SKIP'
        ANSI.blue { status.upcase }
      when 'FAIL'
        ANSI.red { status.upcase }
      else
        ANSI.white_on_red { status.upcase }
      end
    end

    def self.output_results(results, metadata_only = false)
      require 'ansi'
      results.keys.each do |suite_key|
        puts suite_key
        results[suite_key].each do |test|
          puts write_result(test['status'], test[:test_method], test['message'])
          if test['status'].casecmp('ERROR').zero?
            puts ' ' * 12 + '-' * 40
            puts ' ' * 12 + test['data'].gsub("\n", "\n" + ' ' * 12).to_s
            puts ' ' * 12 + '-' * 40
          end
          next unless metadata_only == true
          # warnings
          puts (test['warnings'].map { |w| "#{(' ' * 10)}WARNING: #{w}" }).join("\n") if test['warnings']
          # metadata
          puts (test['links'].map { |w| "#{(' ' * 10)}Link: #{w}" }).join("\n") if test['links']
          puts (test['requires'].map { |w| "#{(' ' * 10)}Requires: #{w[:resource]}: #{w[:methods]}" }).join("\n") if test['requires']
          puts (test['validates'].map { |w| "#{(' ' * 10)}Validates: #{w[:resource]}: #{w[:methods]}" }).join("\n") if test['validates']
          # data
          puts (' ' * 10) + test['data'] if test['data']
        end
      end
      results
    end
  end
end
