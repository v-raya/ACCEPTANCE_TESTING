# frozen_string_literal: true

require 'json'
require_relative 'default_users_helper'

def login_user(user: DEFAULT_SUPERVISIOR, path: root_path)
  Capybara.visit path
  fill_in_login(user)
end

def fill_in_login(user)
  if ENV['APP_URL'].include?('local') || ENV['APP_URL'].include?('preint')
    low_level_environment(user)
  else
    Capybara.fill_in('Email', with: ENV['ACCEPTANCE_TEST_USER'])
    Capybara.fill_in('Password', with: ENV['ACCEPTANCE_TEST_PASSWORD'])
    if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
      Capybara.execute_script('document.getElementsByTagName("button")[0].click()')
    else
      Capybara.click_button('Sign In')
    end
    multi_factor_auth
  end
end

def low_level_environment(user)
  Capybara.fill_in('Authorization JSON', with: user.to_json)
  if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
    Capybara.execute_script('document.getElementById("submitBtn").click()')
  else
    Capybara.click_button('Sign In')
  end
end

def multi_factor_auth
  return unless mfa_page?
  Capybara.fill_in('Enter Code', with: ENV['MFA'])
  if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
    Capybara.execute_script('document.getElementById("validateButton").click()')
  else
    Capybara.click_button('Verify')
  end
end

def mfa_page?
  sleep ENV.fetch('MAX_WAIT', Capybara.default_max_wait_time).to_i
  Wait.for_document
  Capybara.current_url.include?('login')
end

def logout_user
  visit logout_path
end
