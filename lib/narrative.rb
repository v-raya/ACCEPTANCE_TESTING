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
end
