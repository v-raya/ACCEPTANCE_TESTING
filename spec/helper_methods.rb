# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

def autocompleter_fill_in(label, string)
  input = Capybara.find(:fillable_field, label)
  string.split('').each do |char|
    input.send_keys(char)
    sleep(0.08)
  end
end

def build_regex(words)
  arr = words.map do |word|
    "(?=.*#{Regexp.quote(word)})"
  end
  Regexp.new(arr.join(''))
end

def elements_containing(element, *words)
  elements = page.all(element.to_s, text: build_regex(words))
  elements
end

def clear_field(selector)
  fill_in(selector, with: ' ').send_keys(:backspace)
end

def fill_login_form(username = nil, password = nil)
  username ||= ENV['USERNAME']
  password ||= ENV['PASSWORD']
  return if username.blank? || password.blank?
  Capybara.fill_in('username', with: username)
  Capybara.fill_in('password', with: password)
  Capybara.click_button('Sign In')
end

def login_user(*args)
  fill_login_form(*args)
  begin
    click_link 'Intake'
  rescue
    false
  end
end

def generate_date(start_year = 2000, end_year = 2017)
  FFaker::Time.between(Time.new(start_year), Time.new(end_year)).strftime('%m/%d/%Y')
end

def humanize(string, capitalize_all: false)
  capitalize_all ?
    string.split('_').map(&:capitalize).join(' ') :
    string.split('_').join(' ').capitalize
end
