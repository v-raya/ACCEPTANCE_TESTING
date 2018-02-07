# frozen_string_literal: true

require 'autocompleter_helpers'
require 'capybara/rspec'
require 'ffaker'
require 'headless'
require 'helper_methods'
require 'shame_helpers'
require 'pry'
require 'react_select_helpers'
require 'datetime_helpers'
require 'participant_helpers'
require 'address_helpers'
require 'screening_helpers'
require 'selenium/webdriver'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

module AcceptanceTesting
  def self.use_xvfb?
    ENV['USE_XVFB'] == 'true'
  end

  def self.resolve_driver
    driver_option = ENV['CAPYBARA_DRIVER']
    no_driver = driver_option.nil? || driver_option.empty?
    return :xvfb_firefox if no_driver && use_xvfb?
    no_driver ? :selenium : driver_option.to_sym
  end

  def self.setup_env_settings
    @active_driver = resolve_driver
    @app_url = ENV['APP_URL']
  end

  def self.setup_capybara
    Capybara.configure do |config|
      config.app_host               = @app_url
      config.run_server             = false
      config.default_driver         = @active_driver
      config.default_max_wait_time  = 10
    end

    Capybara.register_driver :xvfb_firefox do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
      Capybara::Selenium::Driver.new(app, browser: :firefox, desired_capabilities: capabilities)
    end

    Capybara.register_driver :selenium_firefox do |app|
      Capybara::Selenium::Driver.new(app, browser: :firefox)
    end

    Capybara.register_driver :selenium_firefox_headless do |app|
      browser_options = Selenium::WebDriver::Firefox::Options.new
      browser_options.args << '--headless'

      Capybara::Selenium::Driver.new(app, browser: :firefox, options: browser_options)
    end

    Capybara.enable_aria_label = true
  end

  def self.setup
    setup_env_settings
    raise 'You must pass the app url with APP_URL=<url>.' unless @app_url
    setup_xvfb if use_xvfb?
    setup_capybara
  end

  def self.setup_xvfb
    @headless = Headless.new
    @headless.start
  end

  def self.teardown
    @headless.destroy if @headless
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
