# frozen_string_literal: true

require 'json'
require_relative 'default_users_helper'

def login_user(user: DEFAULT_SUPERVISIOR, path: root_path)
  visit root_path
  fill_in_credentials(user)
  if path == new_screening_path
    visit intake_path
    click_button('Start Screening')
  else
    visit path
  end
end

def fill_in_credentials(user)
  user = user.to_json if user.is_a?(Hash)
  fill_in('username', with: ENV.fetch('ACCEPTANCE_TEST_USER', user))
  click_button('Sign In')
  $current_user = JSON.parse(user, object_class: OpenStruct)
end

def logout_user
  visit logout_path
end
