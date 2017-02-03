#require 'capybara/accessible'
require 'capybara/rspec'
require 'capybara/webkit'
require 'headless'

module AcceptanceTesting
  def self.setup

    @run_headless = ENV['RUN_HEADLESS'] === 'true'
    @active_driver = (ENV['CAPYBARA_DRIVER'] || :selenium).to_sym
    @app_url = ENV['APP_URL']

    raise 'You must pass the app url with APP_URL=<url>.' unless @app_url

    Capybara.configure do |config|
      config.app_host               = @app_url
      config.run_server             = false
      config.default_driver         = @active_driver
      config.default_max_wait_time  = 5
    end

    Capybara::Webkit.configure do |config|
      config.allow_unknown_urls
    end

    if @run_headless
      # Start Xvfb display server
      @headless_manager = Headless.new
      @headless_manager.start
    end
  end

  def self.teardown
    if @run_headless
      @headless.destroy
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
