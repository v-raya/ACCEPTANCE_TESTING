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
    if Capybara.current_driver == :selenium_ie
      Capybara.execute_script('document.getElementsByTagName("button")[0].click()')
    else
      Capybara.click_button('Sign In')
    end
    multi_factor_auth
  end
end

def low_level_environment(user)
  Capybara.fill_in('Authorization JSON', with: user.to_json)
  if Capybara.current_driver == :selenium_ie
    Capybara.execute_script('document.getElementById("submitBtn").click()')
  else
    Capybara.click_button('Sign In')
  end
end

def multi_factor_auth
  element = Capybara.evaluate_script('document.getElementById("validateButton")')
  return if element.blank?
  Capybara.fill_in('Enter Code', with: ENV['MFA'])
  if Capybara.current_driver == :selenium_ie
    Capybara.execute_script('document.getElementById("validateButton").click()')
  else
    Capybara.click_button('Verify')
  end
end

def logout_user
  visit logout_path
end
