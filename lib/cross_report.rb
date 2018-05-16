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
    '#type-DISTRICT_ATTORNEY' => 'District attorney',
    '#type-LAW_ENFORCEMENT' => 'Law enforcement'
  }.freeze

  # rubocop:disable Style/MutableConstant
  DEFAULT_VALUES = {
    county: 'Sacramento',
    district_attorney: 'District attorney',
    law_enforcement: 'Law enforcement'
  }

  CONTAINER = '#cross-report-card'

  def self.complete_form(**args)
    DEFAULT_VALUES[:county] = $current_user.county_name || 'Sacramento'
    super
  end

  def self.fill_form(**args)
    edit_form if not_editable?
    super
    within CONTAINER do
      fill_in('Cross Reported on Date', with: past_date)
      select(COMMUNICATION_METHOD.sample, from: 'Communication Method')
    end
  end

  def self.select_check_box_fields(**_args)
    CHECKBOX_FIELDS.each do |input, label|
      check_box = find(input)
      label = find('label', text: label, exact_text: true)
      label.select_option unless check_box.checked?
    end
  end
end
