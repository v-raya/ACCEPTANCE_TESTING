# frozen_string_literal: true

# require 'active_support/core_ext/object/blank'

def search_client(label: 'Search for any person', query:, blur: false)
  clear_field(label)
  fill_in(label, with: query, fill_options: { blur: blur })
end

def clear_field(selector)
  fill_in(selector, with: ' ').send_keys(:backspace)
end

def generate_date(start_year = 2000, end_year = 2017)
  Faker::Time.between(Time.new(start_year), Time.new(end_year)).strftime('%m/%d/%Y')
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

def interact_with_node(capybara_node:, event: 'click')
  capybara_node.send(event)
end
