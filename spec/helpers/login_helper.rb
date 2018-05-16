# frozen_string_literal: true

require 'json'
require_relative 'default_users_helper'

def login_user(user: DEFAULT_SUPERVISIOR, path: root_path)
  visit root_path
  fill_in_credentials(user)
  if path == new_screening_path
    click_button('Start Screening')
  else
    visit path
  end
end

def fill_in_credentials(user)
  return if $current_user.present?
  user = user.to_json if user.is_a?(Hash)
  fill_in('username', with: ENV.fetch('ACCEPTANCE_TEST_USER', user))
  click_button('Sign In')
  $current_user ||= JSON.parse(user, object_class: OpenStruct)
end

def login_county_social_worker_only(path: root_path)
  login_user(user: COUNTY_SOCIAL_WORKER_ONLY, path: path)
end

def login_county_sensitive_social_worker(path: root_path)
  login_user(user: COUNTY_SENSITIVE_SOCIAL_WORKER, path: path)
end

def login_county_sealed_social_worker(path: root_path)
  login_user(user: COUNTY_SEALED_SOCIAL_WORKER, path: path)
end

def login_state_sensitive_social_worker(path: root_path)
  login_user(user: STATE_SENSITIVE_SOCIAL_WORKER, path: path)
end

def login_state_sealed_social_worker(path: root_path)
  login_user(user: STATE_SEALED_SOCIAL_WORKER, path: path)
end

def logout_user
  visit '/logout'
end
