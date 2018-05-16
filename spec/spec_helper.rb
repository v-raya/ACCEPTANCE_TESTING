# frozen_string_literal: true

require 'byebug'
require 'capybara/rspec'
require 'faker'
require 'selenium/webdriver'
require 'active_support/core_ext/object/blank'

%w[person victim reporter perpetrator screening_information
   narrative incident_information allegation worker_safety
   cross_report decision snapshot screening].each do |f|
  require [Dir.pwd, 'lib', f].join('/')
end
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/helpers/**/*.rb'].each { |f| require f }

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

RSpec.configure do |config|
  include Capybara::DSL

  config.before(:all, type: :feature) do
    logout_user
  end

  config.before(:each) do
    if Capybara.current_driver == :headless_chrome && self.class.metadata[:reset_user]
      logout_user
      send(self.class.metadata[:reset_user], path: self.class.metadata[:path])
    end
  end

  config.after(:each) do
    page.instance_variable_set(:@touched, false)
    if Capybara.current_driver == :headless_chrome &&
       self.class.metadata[:reset_user]
      logout_user
    end
  end

  config.after(:all) do
    page.instance_variable_set(:@touched, true)
  end
end
