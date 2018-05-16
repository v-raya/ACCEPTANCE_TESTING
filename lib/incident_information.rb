# frozen_string_literal: true

require_relative '../helpers/form_helper'

# incident information
class IncidentInformation
  extend FormHelper

  LOCATION_TYPE = ["Child's Home", "Relative's Home", 'Foster Home',
                   'Other Home', 'Residential', 'Day Care', 'School',
                   'Hospital', 'Camp', 'Juvenile Detention', 'BDDS',
                   'In Public', 'Other', 'Unknown'].freeze

  INPUT_FIELDS = {
    incident_date: 'Incident Date',
    street_address: 'Address',
    city: 'City',
    zip: 'Zip'
  }.freeze

  SELECT_FIELDS = {
    state: 'State',
    location_type: 'Location Type'
  }.freeze

  MULTI_SELECT_FIELDS = {}.freeze

  CHECKBOX_FIELDS = {}.freeze

  DEFAULT_VALUES = {
    incident_date: past_date,
    street_address: Faker::Address.street_address,
    city: 'Sacramento',
    zip: Faker::Base.numerify('9####'),
    state: 'California',
    location_type: LOCATION_TYPE.sample
  }.freeze

  CONTAINER = '#incident-information-card'
end
