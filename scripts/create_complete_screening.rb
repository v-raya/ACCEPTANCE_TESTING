# frozen_string_literal: true

require 'react_select_helpers'
require 'spec_helper'
require 'capybara'

def language_sample
  srand
  [
    'American Sign Language',
    'Arabic',
    'Armenian',
    'Cambodian',
    'Cantonese',
    'English',
    'Farsi',
    'French',
    'German',
    'Hawaiian',
    'Hebrew',
    'Hmong',
    'Ilocano',
    'Indochinese',
    'Italian',
    'Japanese',
    'Korean',
    'Lao',
    'Mandarin',
    'Mien',
    'Other Chinese',
    'Other Non-English',
    'Polish',
    'Portuguese',
    'Romanian',
    'Russian',
    'Samoan',
    'Sign Language (Not ASL)',
    'Spanish',
    'Tagalog',
    'Thai',
    'Turkish',
    'Vietnamese'
  ].sample rand(3)
end

def gender_sample
  ['Male', 'Female', 'Unknown'].sample
end

def zip_sample
  FFaker::AddressUS.zip_code[0..4]
end

def address_type_sample
  [
    'Common',
    'Day Care',
    'Home',
    'Homeless',
    'Other',
    'Penal Institution',
    'Permanent Mailing Address',
    'Residence 2',
    'Work'
  ].sample
end

victim = {
  first_name: FFaker::Name.first_name,
  middle_name: FFaker::Product.letters(1),
  last_name: FFaker::Name.last_name,
  roles: 'Victim',
  ssn: FFaker::Identification.ssn,
  dob: FFaker::Time.between(Time.new(2000), Time.new(2017)).strftime('%m/%d/%Y'),
  languages: language_sample,
  gender: gender_sample
}
perpetrator = {
  first_name: FFaker::Name.first_name,
  middle_name: FFaker::Product.letters(1),
  last_name: FFaker::Name.last_name,
  roles: 'Perpetrator',
  ssn: FFaker::Identification.ssn,
  dob: FFaker::Time.between(Time.new(1990), Time.new(1999)).strftime('%m/%d/%Y'),
  languages: language_sample,
  gender: gender_sample
}
reporter = {
  first_name: FFaker::Name.first_name,
  middle_name: FFaker::Product.letters(1),
  last_name: FFaker::Name.last_name,
  roles: 'Mandated Reporter',
  ssn: FFaker::Identification.ssn,
  dob: FFaker::Time.between(Time.new(1980), Time.new(1989)).strftime('%m/%d/%Y'),
  languages: language_sample,
  gender: gender_sample,
  addresses: [
    {
      street_address: FFaker::AddressUS.street_address,
      city: FFaker::AddressUS.city,
      state: FFaker::AddressUS.state,
      zip: zip_sample,
      type: address_type_sample
    }
  ]
}

describe 'Scripts' do
  scenario 'Create a stubbed zippy referral for manual testing' do
    screening_page = ScreeningPage.new
    screening_page.visit_screening

    [victim, perpetrator, reporter].each do |person|
      person_id = screening_page.add_new_person
      screening_page.set_participant_attributes(person_id, person)
      person[:id] = person_id
    end

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
      zip: zip_sample,
      location_type: "Child's Home"
    )

    screening_page.set_narrative(
      narrative: FFaker::Lorem.paragraph(2)
    )

    screening_page.set_allegations_attributes(allegations: [
                                                {
                                                  victim_id: victim[:id],
                                                  perpetrator_id: perpetrator[:id],
                                                  allegation_types: ['General neglect']
                                                }
                                              ])

    screening_page.set_cross_report_attributes(
      agencies: [{
        type: 'District attorney',
        name: 'Jan 1 $ully'
      },{
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
  end
end

def method_missing(method, *args, &block)
  if Capybara.respond_to?(method)
    Capybara.send(method, *args, &block)
  else
    super
  end
end
