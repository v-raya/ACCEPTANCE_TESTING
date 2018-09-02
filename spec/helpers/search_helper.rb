# frozen_string_literal: true

require_relative '../../helpers/form_helper'

def search_client(query:)
  search_field.set(query, clear: :backspace)
end

def select_client(text:)
  if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
    search_field.send_keys(%i[arrow_down enter])
  else
    element = Capybara.find('.search-item', text: text)
    element.hover
    element.click
  end
end

def click_create_new_person
  if %i[selenium_ie selenium_firefox selenium_edge].include?(Capybara.current_driver)
    Capybara.execute_script("$('button:contains(\"Create a new person\")').click()")
  else
    element = Capybara.find_button('Create a new person')
    element.hover
    element.click
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

def search_field
  document_ready? if Capybara.current_driver == :selenium_edge
  Capybara.find(:fillable_field, 'Search for any person')
end

def document_ready?
  Wait.for_document
  Capybara.execute_script("scrollTo(0, 250)")
end
