# frozen_string_literal: true

require_relative '../helpers/form_helper'

# cross report
class CrossReport
  extend FormHelper

  COMMUNICATION_METHOD = ['Child Abuse Form', 'Electronic Report',
                          'Suspected Child Abuse Report',
                          'Telephone Report'].freeze

  SELECT_FIELDS = {
    county: 'County'
  }.freeze

  MULTI_SELECT_FIELDS = {}.freeze

  INPUT_FIELDS = {}.freeze

  CHECKBOX_FIELDS = {
    '#type-LAW_ENFORCEMENT' => 'Law Enforcement',
    '#type-DISTRICT_ATTORNEY' => 'District Attorney'
  }.freeze

  DEFAULT_VALUES = {
    county: 'Sacramento',
    district_attorney: 'District Attorney',
    law_enforcement: 'Law Enforcement'
  }.freeze

  CONTAINER = '#cross-report-card'

  def self.fill_form(**args)
    super
    within CONTAINER do
      select(COMMUNICATION_METHOD.sample, from: 'Communication Method')
      if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
        element = find_button('Select Time')
        evaluate_script("$('#cross-report-card button[title=\"Select Time\"]').click()")
        element.native.send_keys(:enter)
      else
        2.times do
          fill_in('Cross Reported on Date', with: past_date_time,
                                            fill_options: { clear: :backspace })
        end
      end
    end
  end

  def self.select_check_box_fields(**_args)
    CHECKBOX_FIELDS.each do |input, label|
      check_box = find(input)
      if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
        str = "$('#{CONTAINER} label:contains(#{label})').click()"
        page.execute_script(str) unless check_box.checked?
      else
        label = find('label', text: label, exact_text: true)
        label.click(wait: true) unless check_box.checked?
      end
    end
  end
end
