# frozen_string_literal: true

require_relative '../../helpers/form_helper'

def search_client(label: 'Search for any person', query:, blur: false)
  FormHelper.clear_field(label)
  fill_in(label, with: query, fill_options: { blur: blur })
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
