# frozen_string_literal: true

require_relative '../helpers/form_helper'

# narrative
class Narrative
  extend FormHelper

  INPUT_FIELDS = {
    report_narrative: 'Report Narrative'
  }.freeze

  SELECT_FIELDS = {}.freeze

  MULTI_SELECT_FIELDS = {}.freeze

  CHECKBOX_FIELDS = {}.freeze

  DEFAULT_VALUES = {
    report_narrative: Faker::StarWars.quote
  }.freeze

  CONTAINER = '#narrative-card'

  def self.fill_input_fields(**args)
    self::INPUT_FIELDS.each do |key, value|
      next if args[key].blank?
      args[key].split(//).each do |l|
        Capybara.fill_in(value, with: l, fill_options: { clear: :none })
      end
    end
  end
end
