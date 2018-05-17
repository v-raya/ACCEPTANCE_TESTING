# frozen_string_literal: true

def root_path
  '/'
end

def intake_path
  env_prefix
end

def snapshot_path
  [env_prefix, '/snapshot'].compact.join
end

def screening_path(id: nil)
  raise StandardError, "id can't be blank" if id.blank?
  [env_prefix, '/screenings', '/', id].compact.join
end

def edit_screening_path(id: nil)
  raise StandardError, "id can't be blank" if id.blank?
  [env_prefix, '/screenings', '/', id, '/', 'edit'].compact.join
end

def new_screening_path
  'New Screening'
end

def logout_path
  [env_prefix, '/logout'].compact.join
end

def env_prefix
  return nil if ENV['APP_URL'].blank? || ENV['APP_URL'].include?('local')
  '/intake'
end
