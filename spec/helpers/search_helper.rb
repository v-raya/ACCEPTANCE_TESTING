# frozen_string_literal: true

require_relative '../../helpers/form_helper'

def search_client(label: 'Search for any person', query:)
  search_field = Capybara.find(:fillable_field, label)
  if Capybara.current_driver == :selenium_edge
    blur_search_and_slow_text_input(search_field: search_field, query: query)
  else
    search_field.set(query, clear: :backspace)
  end
end

def blur_search_and_slow_text_input(search_field:, query:)
  find('#search-card').click
  backspaces = [:backspace] * search_field.value.to_s.length
  search_field.native.send_keys(*backspaces)

  query.to_s.split(//).each { |l| search_field.set(l, clear: :none) }
end

def search_client_and_select(label:, query:, text:)
  search_client(label: label, query: query)
  if Capybara.current_driver == :selenium_ie
    script = "$('strong.highlighted:contains(#{text})').first().click()"
    page.execute_script(script)
  else
    find('strong.highlighted', text: text).click
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
