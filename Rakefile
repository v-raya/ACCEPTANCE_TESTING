# frozen_string_literal: true
require 'bundler'
require 'rspec/core/rake_task'
require 'rspec_junit_formatter'

task default: :spec

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(-fp --color --require spec_helper)
  if ENV['GENERATE_TEST_REPORTS'] == 'yes'
    t.rspec_opts << '--format RspecJunitFormatter'
    t.rspec_opts << "--out reports/TEST-#{ENV['CAPYBARA_DRIVER']}-rspec.xml"
  end
end
