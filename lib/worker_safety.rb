# frozen_string_literal: true

require_relative '../helpers/form_helper'

# worker safety
class WorkerSafety
  extend FormHelper

  SAFETY_ALERTS = ['Dangerous Animal on Premises', 'Dangerous Environment',
                   'Firearms in Home', 'Gang Affiliation or Gang Activity',
                   'Hostile Aggressive Client', 'Remote or Isolated Location',
                   'Severe Mental Health Status', 'Threat or Assault on Staff Member',
                   'Other'].freeze
  SELECT_FIELDS = {}.freeze

  MULTI_SELECT_FIELDS = {
    safety_alerts: 'Worker Safety Alerts'
  }.freeze

  CHECKBOX_FIELDS = {}.freeze

  INPUT_FIELDS = {
    safety_information: 'Additional Safety Information'
  }.freeze

  DEFAULT_VALUES = {
    safety_alerts: SAFETY_ALERTS.sample(2),
    safety_information: Faker::StarWars.wookiee_sentence
  }.freeze

  CONTAINER = '#worker-safety-card'
end
