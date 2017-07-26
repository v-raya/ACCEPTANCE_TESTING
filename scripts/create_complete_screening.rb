# frozen_string_literal: true

require 'react_select_helpers'
require 'spec_helper'
require 'capybara'

person1 = {
  first_name: 'VictimOne',
  middle_name: 'H',
  last_name: 'victimLast',
  roles: 'Victim',
  ssn: '111111111',
  dob: '01/01/1990',
  gender: 'Male'
}
person2 = {
  first_name: 'PerpOne',
  middle_name: 'M',
  last_name: 'PerpLast',
  roles: 'Perpetrator',
  ssn: '222222222',
  sob: '02/01/1991',
  gender: 'Female'
}
person3 = {
  first_name: 'ReporterOne',
  middle_name: 'Z',
  last_name: 'ReportLast',
  roles: 'Mandated Reporter',
  ssn: '333333333',
  dob: '03/01/1992',
  gender: 'Male',
  addresses: [
    {
      street_address: '333 Some Road',
      city: 'San Jose',
      state: 'California',
      zip: '95618'
    }
  ]
}

describe 'Scripts' do
  scenario 'Create a stubbed zippy referral for manual testing' do
    screening_page = ScreeningPage.new
    screening_page.visit_screening

    [person1, person2, person3].each do |person|
      screening_page.add_new_person
      person_card_id = find('div[id^="participants-card-"]', text: 'Unknown Person')[:id]
      person_id = person_card_id.match(/\d+/)[0]
      screening_page.set_participant_attributes(person_id, person)
    end

    screening_page.set_screening_information_attributes(
      name: 'Test Screening',
      social_worker: 'Jim Bob',
      start_date: '05/16/2017',
      communication_method: 'Fax'
    )

    screening_page.set_incident_information_attributes(
      incident_county: 'Yolo',
      incident_date: '08/23/1996',
      address: '123 Davis Street',
      city: 'Sacramento',
      state: 'California',
      zip: '95831',
      location_type: "Child's Home"
    )

    screening_page.set_narrative(
      narrative: 'Fr1ends, Rom@ns, countrymen, 1end me your ears;'
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


