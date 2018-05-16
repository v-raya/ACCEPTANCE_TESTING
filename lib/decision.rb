# frozen_string_literal: true

require_relative '../helpers/form_helper'

# decision
class Decision
  extend FormHelper

  SCREENING_DECISION = ['Differential response',
                        'Information to child welfare services',
                        'Promote to referral', 'Screen out'].freeze

  ACCESS_RESTRICTIONS = ['Do not restrict access',
                         'Mark as Sensitive',
                         'Mark as Sealed'].freeze

  RESPONSE_TIME = ['Immediate', '3 days', '5 days', '10 days'].freeze

  CATEGORY = ['Evaluate out', 'Information request', 'Consultation',
              'Abandoned call', 'Other'].freeze

  SELECT_FIELDS = {
    screening_decision: 'Screening Decision',
    access_restrictions: 'Access Restrictions'
  }.freeze

  MULTI_SELECT_FIELDS = {}.freeze

  CHECKBOX_FIELDS = {}.freeze

  INPUT_FIELDS = {
    additional_information: 'Additional Information'
  }.freeze

  DEFAULT_VALUES = {
    screening_decision: SCREENING_DECISION.sample,
    access_restrictions: ACCESS_RESTRICTIONS.sample,
    restrictions_rationale: Faker::StarWars.call_sign,
    service_name: Faker::StarWars.droid,
    staff_name: Faker::StarWars.character,
    category: CATEGORY.sample,
    additional_information: Faker::StarWars.planet,
    response_time: RESPONSE_TIME.sample
  }.freeze

  CONTAINER = '#decision-card'

  def self.fill_form(**args)
    super
    fill_secondary_fields(**args)
  end

  def self.fill_secondary_fields(hash)
    screening_decision_response(hash)
    access_restrictions_response(hash)
  end

  def self.screening_decision_response(hash)
    case hash[:screening_decision]
    when 'Differential response'
      fill_in(:decision_detail, with: hash[:service_name])
    when 'Information to child welfare services'
      fill_in(:decision_detail, with: hash[:staff_name])
    when 'Promote to referral'
      select(hash[:response_time], from: :decision_detail)
    when 'Screen out'
      select(hash[:category], from: :decision_detail)
    end
  end

  def self.access_restrictions_response(hash)
    return if hash[:access_restrictions] == 'Do not restrict access'
    fill_in(:restrictions_rationale, with: hash[:restrictions_rationale])
  end
end
