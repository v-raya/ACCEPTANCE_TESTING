require 'bundler'

task :default => [:spec]

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(-fp --color --require spec_helper)
end
