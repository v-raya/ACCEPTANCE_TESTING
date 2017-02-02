require 'capybara/rspec'

module AcceptanceTesting
  def self.setup
    Capybara.configure do |config|
      config.app_host               = ENV['TEST_URL'] || 'http://192.168.99.100:3000'
      config.run_server             = false
      config.default_driver         = :selenium
      config.default_max_wait_time  = 5
    end
  end
end

RSpec.configure do |config|
  config.before(:all) do
    AcceptanceTesting.setup
  end
  config.after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
