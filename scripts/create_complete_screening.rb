# frozen_string_literal: true

require 'react_select_helpers'
require 'spec_helper'
require 'capybara'

describe 'Submitting a referral when screening is valid', type: :feature do
  it 'enables the submit button' do
    screening_page = ScreeningPage.new
    screening_page.visit_screening
    victim_id = screening_page.add_new_person Participant.victim
    perpetrator_id = screening_page.add_new_person Participant.perpetrator
    screening_page.add_new_person Participant.reporter

    screening_title = FFaker::Movie.title
    screening_page.set_screening_information_attributes(
      name: screening_title,
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
      zip: Address.zip,
      location_type: "Child's Home"
    )

    screening_page.set_narrative(
      narrative: FFaker::Lorem.paragraph(2)
    )

    screening_page.set_allegations_attributes(allegations: [
                                                {
                                                  victim_id: victim_id,
                                                  perpetrator_id: perpetrator_id,
                                                  allegation_types: ['General neglect']
                                                }
                                              ])

    screening_page.set_cross_report_attributes(
      agencies: [{
        type: 'District attorney',
        name: 'Jan 1 $ully'
      }, {
        type: 'Law enforcement',
        name: 'La La PD'
      }],
      date: '08/17/2016',
      communication_method: 'Suspected Child Abuse Report'
    )

    screening_page.set_decision_attributes(
      screening_decision: 'Promote to referral',
      response_time: '3 days'
    )

    puts "Go find your screening, named #{screening_title}, at #{page.current_url}"

    expect(find_button('Submit').disabled?).to be(false)
  end
end
