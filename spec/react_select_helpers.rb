# frozen_string_literal: true

module ReactSelectHelpers
  def fill_in_react_select(selector, with:)
    input = find_field(selector)
    input.send_keys with
    input.native.send_keys :return
  end

  def has_react_select_field(selector, with: nil, options: [])
    input = find_field(selector)
    select_container = find("label[for=#{input[:id]}]+.Select")
    check_selected_options(select_container, with) if with
    check_available_options(select_container, options) if options.any?
  end

  def remove_react_select_option(selector, option)
    input = find_field(selector)
    close_icon = input.find(:xpath, <<-XPATH)
      ./../../div[@class='Select-value']
      /span[contains(.,'#{option}')]/../span[@class='Select-value-icon']
    XPATH
    close_icon.click
  end

  def check_selected_options(select_container, with)
    selected_values = select_container.all('.Select-value-label').map(&:text)
    expect(selected_values).to eq(with)
  end

  def check_available_options(select_container, options)
    select_container.click
    options.each do |option|
      expect(select_container.text).to have_content(option)
    end
  end
end

RSpec.configure do |config|
  config.include ReactSelectHelpers, type: :feature
end
