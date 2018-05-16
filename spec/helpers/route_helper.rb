# frozen_string_literal: true

def root_path
  '/'
end

def snapshot_path
  [env_prefix, '/snapshot'].compact.join
end

def screening_path(id: nil)
  raise StandardError, "id can't be blank" if id.blank?
  [env_prefix, '/screening', '/', id].compact.join
end

def edit_screening_path(id: nil)
  raise StandardError, "id can't be blank" if id.blank?
  [env_prefix, '/screenings', '/', id, '/', 'edit'].compact.join
end

def new_screening_path
  'New Screening'
  # visit root_path
  # yield if block_given?
  # click_button('Start Screening')
end

def env_prefix
  return nil if ENV['APP_URL'].blank? || ENV['APP_URL'].include?('local')
  '/intake'
end
