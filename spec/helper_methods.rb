# frozen_string_literal: true
def autocompleter_fill_in(label, string)
  input = find(:fillable_field, label)
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

def login_user
  return unless ENV['USERNAME'] && ENV['PASSWORD']
  username_input = page.find('input[name=username]')
  username_input.send_keys ENV['USERNAME']
  password_input = page.find('input[name=password]')
  password_input.send_keys ENV['PASSWORD']
  click_button('Sign In')
  click_link 'Intake' rescue false
end
