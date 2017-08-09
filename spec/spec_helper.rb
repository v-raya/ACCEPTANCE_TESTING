# frozen_string_literal: true

require 'autocompleter_helpers'
require 'capybara/rspec'
require 'capybara/webkit'
require 'ffaker'
require 'headless'
require 'helper_methods'
require 'shame_helpers'
require 'pry'
require 'react_select_helpers'
require 'datetime_helpers'
require 'participant_helpers'
require 'address_helpers'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

module AcceptanceTesting
  def self.resolve_driver
    driver_option = ENV['CAPYBARA_DRIVER']
    is_driver_defined = driver_option.nil? || driver_option.empty?
    is_driver_defined ? :selenium : driver_option.to_sym
  end

  def self.setup_env_settings
    @active_driver = resolve_driver
    @use_xvfb = ENV['USE_XVFB'] == 'true'
    @app_url = ENV['APP_URL']
  end

  def self.setup_xvfb
    @headless_manager = Headless.new
    @headless_manager.start
  end

  def self.setup_capybara
    Capybara.configure do |config|
      config.app_host               = @app_url
      config.run_server             = false
      config.default_driver         = @active_driver
      config.default_max_wait_time  = 10
    end

    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
    Capybara.enable_aria_label = true

    Capybara::Webkit.configure(&:allow_unknown_urls)
  end

  def self.setup
    setup_env_settings
    raise 'You must pass the app url with APP_URL=<url>.' unless @app_url
    setup_xvfb if @use_xvfb
    setup_capybara
  end

  def self.teardown
    @headless.destroy if @run_headless
  end
end

RSpec.configure do |config|
  config.before(:all) do
    AcceptanceTesting.setup
  end
  config.after do
    page.driver.reset!
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
