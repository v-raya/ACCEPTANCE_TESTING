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

task :publish_docker_image do
  login_succeeded = system('docker login')
  repo_name = 'cwds/acceptance_testing'
  repo_tag = `git rev-parse --short HEAD`.strip
  begin
    if login_succeeded
      system("docker build -t #{repo_name}:#{repo_tag} .")
      system("docker push #{repo_name}:#{repo_tag}")
    end
  ensure
    system('docker logout') if login_succeeded
  end
end
