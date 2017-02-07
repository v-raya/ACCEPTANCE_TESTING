require 'capybara/rspec'
require 'capybara/webkit'
require 'headless'
require 'helper_methods'

module AcceptanceTesting
  def self.setup

    driver_option = ENV['CAPYBARA_DRIVER']
    is_driver_defined = driver_option.nil? || driver_option.empty?
    @active_driver = (is_driver_defined ? :selenium : driver_option).to_sym
    @use_xvfb = ENV['USE_XVFB'] === 'true'
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

    if @use_xvfb
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
