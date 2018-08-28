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
    Capybara.click_button('Sign In')
    multi_factor_auth
  end
end

def low_level_environment(user)
  Capybara.fill_in('Authorization JSON', with: user.to_json)
  Capybara.click_button('Sign In')
end

def multi_factor_auth
  Capybara.fill_in('Enter Code', with: ENV['MFA'])
  Capybara.click_button('Verify')
end

def logout_user
  visit logout_path
end
