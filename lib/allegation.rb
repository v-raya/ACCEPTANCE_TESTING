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

  def self.fill_form(**args)
    inputs = find_all(MULTI_SELECT_FIELDS[:select_input])
    raise StandardError, 'create or attach a victim first' if inputs.blank?

    within(CONTAINER) do
      inputs.each do |element|
        allegations = args.fetch(:allegations, ALLEGATION.sample(2))
        allegations.each { |allegation| element.set(allegation).send_keys(:enter) }
      end
    end
  end
end
