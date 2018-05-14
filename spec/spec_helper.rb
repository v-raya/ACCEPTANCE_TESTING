# frozen_string_literal: true

require 'byebug'
require 'capybara/rspec'
require 'helper_methods'
require 'shame_helpers'
require 'react_select_helpers'
require 'datetime_helpers'
require 'participant_helpers'
require 'address_helpers'
require 'screening_helpers'
require 'selenium/webdriver'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

Capybara.configure do |config|
  config.app_host                = ENV.fetch('APP_URL') { raise 'You must pass the app url with APP_URL=<url>.' }
  config.run_server              = false
  config.default_driver          = ENV.fetch('CAPYBARA_DRIVER', 'headless_chrome').to_sym
end

Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless no-sandbox]
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :headless_chrome
