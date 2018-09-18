# frozen_string_literal: true

require_relative '../../helpers/form_helper'

def search_client(query:)
  if Capybara.current_driver == :selenium_edge
    blur_search_and_slow_text_input(query: query)
  else
    scroll_page
    search_field.set(query, clear: :backspace)
  end
end

def blur_search_and_slow_text_input(query:)
  scroll_page
  find('#search-card').click
  search_field.native.send_keys(*([:backspace] * search_field.value.to_s.length))
  query.to_s.split(//).each { |l| search_field.set(l, clear: :none) }
end

def select_client(text:)
  if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
    search_field.send_keys(%i[arrow_down enter])
  else
    element = Capybara.first('.search-item', text: text)
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
  Capybara.find(:fillable_field, 'Search for any person')
end

def scroll_page(x: 0, y: 0)
  Wait.for_document
  Capybara.execute_script("scrollTo(#{x},#{y})")
end
