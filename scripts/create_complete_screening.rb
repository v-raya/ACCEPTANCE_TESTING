# frozen_string_literal: true

require 'react_select_helpers'
require 'spec_helper'
require 'capybara'

victim = {
  first_name: FFaker::Name.first_name,
  middle_name: FFaker::Product.letters(1),
  last_name: FFaker::Name.last_name,
  roles: 'Victim',
  ssn: FFaker::Identification.ssn,
  dob: FFaker::Time.between(Time.new(2000), Time.new(2017)).strftime('%m/%d/%Y'),
  gender: FFaker::Identification.gender
}
perpetrator = {
  first_name: FFaker::Name.first_name,
  middle_name: FFaker::Product.letters(1),
  last_name: FFaker::Name.last_name,
  roles: 'Perpetrator',
  ssn: FFaker::Identification.ssn,
  dob: FFaker::Time.between(Time.new(1990), Time.new(1999)).strftime('%m/%d/%Y'),
  gender: FFaker::Identification.gender
}
reporter = {
  first_name: FFaker::Name.first_name,
  middle_name: FFaker::Product.letters(1),
  last_name: FFaker::Name.last_name,
  roles: 'Mandated Reporter',
  ssn: FFaker::Identification.ssn,
  dob: FFaker::Time.between(Time.new(1980), Time.new(1989)).strftime('%m/%d/%Y'),
  gender: FFaker::Identification.gender,
  addresses: [
    {
      street_address: FFaker::AddressUS.street_address,
      city: FFaker::AddressUS.city,
      state: FFaker::AddressUS.state,
      zip: FFaker::AddressUS.zip_code
    }
  ]
}

describe 'Scripts' do
  scenario 'Create a stubbed zippy referral for manual testing' do
    screening_page = ScreeningPage.new
    screening_page.visit_screening

    [victim, perpetrator, reporter].each do |person|
      screening_page.add_new_person
      person_card_id = find('div[id^="participants-card-"]', text: 'Unknown Person')[:id]
      person_id = person_card_id.match(/\d+/)[0]
      screening_page.set_participant_attributes(person_id, person)
    end

    screening_page.set_screening_information_attributes(
      name: FFaker::Movie.title,
      social_worker: 'Jim Bob',
      start_date: '05/16/2017',
      communication_method: 'Fax'
    )

    screening_page.set_incident_information_attributes(
      incident_county: 'Yolo',
      incident_date: '08/23/1996',
      address: FFaker::AddressUS.street_address,
      city: FFaker::AddressUS.city,
      state: FFaker::AddressUS.state,
      zip: FFaker::AddressUS.zip_code,
      location_type: "Child's Home"
    )

    screening_page.set_narrative(
      narrative: FFaker::HipsterIpsum.paragraph(8)
    )

    screening_page.set_allegations_attributes(
      allegations: [
        ['Exploitation', 'General neglect']
      ]
    )

    screening_page.set_cross_report_attributes(
      agencies: [{
        type: 'District attorney',
        name: 'Jan 1 $ully'
      }],
      date: '08/17/2016',
      communication_method: 'Suspected Child Abuse Report'
    )

    screening_page.set_decision_attributes(
      screening_decision: 'Promote to referral',
      response_time: '3 days'
    )

    puts "Go find your screening at #{page.current_url}"
  end
end

def method_missing(method, *args, &block)
  if Capybara.respond_to?(method)
    Capybara.send(method, *args, &block)
  else
    super
  end
end


