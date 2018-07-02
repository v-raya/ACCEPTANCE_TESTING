# frozen_string_literal: true

require 'byebug'
require 'capybara/rspec'
require 'faker'
require 'selenium/webdriver'
require 'chromedriver/helper'
require 'active_support/core_ext/object/blank'

%w[person victim reporter perpetrator screening_information
   narrative incident_information allegation worker_safety
   cross_report decision snapshot screening].each do |f|
  require [Dir.pwd, 'lib', f].join('/')
end
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/helpers/**/*.rb'].each { |f| require f }

REGISTER_DRIVERS = {
  'selenium_firefox' => 'firefox',
  'selenium_edge' => 'edge',
  'selenium_ie' => 'ie'
}

Chromedriver.set_version('2.38')

Capybara.configure do |config|
  config.app_host                = ENV.fetch('APP_URL') { raise 'You must pass the app url with APP_URL=<url>.' }
  config.run_server              = false
  config.default_driver          = ENV.fetch('CAPYBARA_DRIVER', 'headless_chrome').to_sym
end

REGISTER_DRIVERS.each do |driver, browser|
  Capybara.register_driver driver.to_sym do |app|
    Capybara::Selenium::Driver.new(app, browser: browser.to_sym)
  end
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless no-sandbox]
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver :selenium_safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

Capybara.javascript_driver = :headless_chrome

unless Capybara.current_driver == :headless_chrome
  Capybara.page.driver.browser.manage.window.maximize
end

# capybara session
module Capybara
  # session
  class Session
    alias_method :old_visit, :visit

    def visit(path, **_args)
      sleep 0.2 if %i[selenium_safari].include?(Capybara.current_driver)
      old_visit(path)
    end
  end
end

RSpec.configure do |config|
  include Capybara::DSL

  config.before(:all, type: :feature) do
    visit logout_path
  end

  config.before(:each) do
    if Capybara.current_driver == :headless_chrome && self.class.metadata[:reset_user]
      visit logout_path
      send(self.class.metadata[:reset_user], user: self.class.metadata[:user],
                                             path: self.class.metadata[:path])
    end
  end

  config.after(:each) do
    page.instance_variable_set(:@touched, false)
    if Capybara.current_driver == :headless_chrome &&
       self.class.metadata[:reset_user]
      visit logout_path
    end
  end

  config.after(:all) do
    page.instance_variable_set(:@touched, true)
  end
end
