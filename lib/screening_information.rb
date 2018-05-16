# frozen_string_literal: true

require_relative '../helpers/form_helper'

# screening information
class ScreeningInformation
  extend FormHelper

  COMMUNICATION_METHOD = ['Email', 'Fax', 'In Person', 'Mail', 'Phone'].freeze

  INPUT_FIELDS = {
    name: 'Title/Name of Screening',
    start_date: 'Screening Start Date/Time',
    end_date: 'Screening End Date/Time'
  }.freeze

  SELECT_FIELDS = {
    communication_method: 'Communication Method'
  }.freeze

  MULTI_SELECT_FIELDS = {}.freeze

  CHECKBOX_FIELDS = {}.freeze

  DEFAULT_VALUES = {
    name: Faker::StarWars.character,
    start_date: past_date_time(a: 6, b: 5),
    end_date: past_date_time(a: 4, b: 2),
    communication_method: COMMUNICATION_METHOD.sample
  }.freeze

  CONTAINER = '#screening-information-card'
end
