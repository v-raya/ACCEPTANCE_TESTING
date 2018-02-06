# frozen_string_literal: true

require 'bundler'
require 'rspec/core/rake_task'
require 'rspec_junit_formatter'
require 'yaml'
require 'pry'

task default: :spec

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(-fp --color --require spec_helper)

  if ENV['FEATURE_SET'] != ''
    example_options.each do |example_name|
      t.rspec_opts << "-e '#{example_name}'"
    end
  end

  if ENV['GENERATE_TEST_REPORTS'] == 'yes'
    t.rspec_opts << '--format RspecJunitFormatter'
    t.rspec_opts << "--out reports/TEST-#{ENV['CAPYBARA_DRIVER']}-rspec.xml"
  end
end

def example_options
  feature_set = YAML.load_file('feature_set.yml')
  feature_set[ENV.fetch('FEATURE_SET', '')] || []
end
