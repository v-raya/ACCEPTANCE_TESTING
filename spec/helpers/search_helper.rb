# frozen_string_literal: true

require_relative '../../helpers/form_helper'

def search_client(label: 'Search for any person', query:)
  search_field = Capybara.find(:fillable_field, label)
  if Capybara.current_driver == :selenium_edge
    find('#search-card').click
    backspaces = [:backspace] * search_field.value.to_s.length
    search_field.native.send_keys(*(backspaces))

    query.to_s.split(//).each { |l| search_field.set(l, clear: :none) }
  else
    search_field.set(query, clear: :backspace)
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
