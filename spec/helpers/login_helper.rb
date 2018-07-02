# frozen_string_literal: true

require 'json'
require_relative 'default_users_helper'

def login_user(user: DEFAULT_SUPERVISIOR, password: nil, path: root_path)
  Capybara.visit '/'
  password = ENV.fetch('ACCEPTANCE_TEST_PASSWORD', password)
  fill_in_login(user, password)
  redirect_to_intented_path(path)
end

def fill_in_login(user, password)
  entered_user = fill_in_user_name(user, password)
  fill_in_password(password) if password.present?

  if password.present?
    Capybara.find_field('signInSubmitButton').click
  else
    Capybara.click_button('Sign In')
    WaitForAjax.wait_for_ajax
    $current_user = JSON.parse(entered_user, object_class: OpenStruct)
  end
end

def fill_in_user_name(user, password)
  user_name = if password.present? && user.is_a?(String)
                user
              elsif user.is_a?(String)
                Demo::DEFAULT_USERS[user || 'default_supervisior'].to_json
              else
                user.to_json
              end
  Capybara.fill_in('username', with: ENV.fetch('ACCEPTANCE_TEST_USER', user_name))
  user_name
end

def fill_in_password(password)
  Capybara.fill_in('password', with: password)
end

def redirect_to_intented_path(path)
  if path.include?('/intake/screenings/new')
    Capybara.visit '/intake'
    Capybara.click_button('Start Screening')
  elsif path.include?('/screenings/new')
    Capybara.visit '/'
    Capybara.click_button('Start Screening')
  else
    Capybara.visit path
  end
end

def logout_user
  visit logout_path
end
