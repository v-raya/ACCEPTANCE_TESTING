# frozen_string_literal: true

module KeyboardHelper
  MACOSX_PLATFORM_NAME = 'darwin'

  def press_key(key)
    current_input = page.driver.browser.switch_to.active_element
    current_input.send_key(key)
  end

  def paste_into(selector)
    super_key = RUBY_PLATFORM.include?(MACOSX_PLATFORM_NAME) ? :command : :control
    find(selector).native.send_keys [super_key, 'v']
  end
end

RSpec.configure do |config|
  config.include KeyboardHelper, type: :feature
end
