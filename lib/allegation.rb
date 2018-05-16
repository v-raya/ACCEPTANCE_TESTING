# frozen_string_literal: true

require_relative '../helpers/form_helper'

# allegation
class Allegation
  extend FormHelper

  ALLEGATION = ['General neglect', 'Severe neglect', 'Physical abuse',
                'Sexual abuse', 'Emotional abuse', 'Caretake absent/incapacity',
                'Exploitation', 'At risk, sibling abused'].freeze

  SELECT_FIELDS = {}.freeze

  MULTI_SELECT_FIELDS = {
    select_input: '#allegations-card .Select-control input'
  }.freeze

  INPUT_FIELDS = {}.freeze

  CHECKBOX_FIELDS = {}.freeze

  DEFAULT_VALUES = {
    select_input: ALLEGATION.sample(2)
  }.freeze

  CONTAINER = '#allegations-card'

  def self.generate_clients
    screening = Screening.new
    screening.create_victim
    screening.create_reporter
    screening.create_perpetrator
  end

  def self.fill_form(**_args)
    generate_clients
    find_all(MULTI_SELECT_FIELDS[:select_input]).each do |element|
      ALLEGATION.sample(2).each { |allegation| element.set(allegation).send_keys(:enter) }
    end
  end
end
