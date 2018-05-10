# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

def autocompleter_fill_in(label, string, blur: false)
  fill_in(label, with: string, fill_options: { blur: blur })
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

def fill_login_form
  return if ENV['ACCEPTANCE_TEST_USER'].blank?
  fill_in('username', with: ENV.fetch('ACCEPTANCE_TEST_USER'))
  if page.text.include?('Password') && !ENV['ACCEPTANCE_TEST_PASSWORD'].blank?
    fill_in('password', with: ENV.fetch('ACCEPTANCE_TEST_PASSWORD'))
  end
  click_button('Sign In')
end

def fill_json_login_form
  authorization_json = {
    user: 'RACFID',
    staffId: '0X5',
    roles: ['Supervisor'],
    county_code: '56',
    county_name: 'Ventura',
    privileges: ['Countywide Read', 'Sensitive Persons']
  }.to_json
  fill_in('username', with: ENV['ACCEPTANCE_TEST_USER'] || authorization_json)
  click_button('Sign In')
end

def fill_production_login_form
  return if ENV['ACCEPTANCE_TEST_USER'].blank?
  fill_in('Username', with: ENV.fetch('ACCEPTANCE_TEST_USER'))
  if page.text.include?('CWS/NS Password') && !ENV['ACCEPTANCE_TEST_PASSWORD'].blank?
    fill_in('Password', with: ENV.fetch('ACCEPTANCE_TEST_PASSWORD'))
  end
  click_button('Sign In')
  if page.text.include? 'Send Access Code'
    click_button('Send Access Code')
    fill_in('accessCode', with: '123456')
    click_button('Validate Access Code')
  end
  click_button('Continue to CWDS')
end

def login_user
  if page.text.include? 'Authorization JSON'
    fill_json_login_form
  elsif page.text.include? 'CWS/NS Username'
    fill_production_login_form
  elsif page.text.include? 'username'
    fill_login_form
  end
  click_link 'Child Welfare History Snapshot Tool'
rescue
  false
end

def generate_date(start_year = 2000, end_year = 2017)
  Faker::Time.between(Time.new(start_year), Time.new(end_year)).strftime('%m/%d/%Y')
end

def clear_user_login
  browser = Capybara.current_session.driver.browser
  visit '/perry'

  if browser.respond_to?(:clear_cookies)
    # Rack::MockSession
    browser.clear_cookies
  elsif browser.respond_to?(:manage) && browser.manage.respond_to?(:delete_all_cookies)
    # Selenium::WebDriver
    browser.manage.delete_all_cookies
  else
    raise "Don't know how to clear cookies. Weird driver?"
  end
end

def wait_for_result_to_appear(element: 'div.autocomplete-menu')
  Timeout.timeout(Capybara.default_max_wait_time) do
    if page.first(element).visible?
      within(element) { yield } if block_given?
    else
      loop
    end
  end
end

def full_name(first: nil, middle: nil, last: nil)
  [first, middle, last].reject(&:blank?).join(' ')
end

def interact_with_node(capybara_node:, event: 'click')
  capybara_node.send(event)
end
