# frozen_string_literal: true

require 'address_helpers'

module Participant
  def self.all_ethnicity_details
    ['Mexican', 'Costa Rican', 'Mayan']
  end

  def self.all_genders
    %w[Male Female Unknown]
  end

  def self.all_languages
    [
      'American Sign Language', 'Arabic', 'Armenian', 'Cambodian', 'Cantonese', 'English', 'Farsi',
      'French', 'German', 'Hawaiian', 'Hebrew', 'Hmong', 'Ilocano', 'Indochinese', 'Italian',
      'Japanese', 'Korean', 'Lao', 'Mandarin', 'Mien', 'Other Chinese', 'Other Non-English',
      'Polish', 'Portuguese', 'Romanian', 'Russian', 'Samoan', 'Sign Language (Not ASL)',
      'Spanish', 'Tagalog', 'Thai', 'Turkish', 'Vietnamese'
    ]
  end

  def self.all_races
    ['White', 'Black or African American', 'Asian', 'Unknown']
  end

  def self.all_roles
    [
      'Victim', 'Perpetrator', 'Mandated Reporter', 'Non-mandated Reporter', 'Anonymous Reporter'
    ]
  end

  def self.all_race_details
    %w[European Caribbean Korean Ethiopian]
  end

  def self.first_name
    FFaker::Name.first_name
  end

  def self.middle_name
    FFaker::Product.letters(1)
  end

  def self.last_name
    FFaker::Name.last_name
  end

  def self.name_suffix
    FFaker::Name.suffix
  end

  def self.gender
    Participant.all_genders.sample
  end

  def self.ssn
    FFaker::SSN.ssn
  end

  def self.date_of_birth
    FFaker::Time.between(Time.new(2000), Time.new(2017)).strftime('%m/%d/%Y')
  end

  def self.race
    Participant.all_races.sample
  end

  def self.race_detail
    Participant.all_race_details.sample
  end

  def self.races
    Array.new(rand(0..2)) { { race: race, race_detail: race_detail } }
  end

  def self.hispanic_latino_origin
    ['Yes', 'No', nil, nil].sample
  end

  def self.ethnicity_detail
    Participant.all_ethnicity_details.sample
  end

  def self.ethnicity
    hispanic_latino = hispanic_latino_origin
    {
      hispanic_latino_origin: hispanic_latino,
      ethnicity_detail: hispanic_latino ? ethnicity_detail : nil
    }
  end

  def self.languages
    Participant.all_languages.sample(rand(3))
  end

  def self.addresses
    Array.new(rand(0..2)) { Address.full_address }
  end

  def self.collateral(attrs = {})
    {
      roles: [],
      first_name: attrs[:first_name] || Participant.first_name,
      middle_name: attrs[:middle_name] || Participant.middle_name,
      last_name: attrs[:last_name] || Participant.last_name,
      name_suffix: attrs[:name_suffix] || Participant.name_suffix,
      gender: attrs[:gender] || Participant.gender,
      ssn: attrs[:ssn] || Participant.ssn,
      date_of_birth: attrs[:date_of_birth] || Participant.date_of_birth,
      races: attrs[:races] || Participant.races,
      ethnicity: attrs[:ethnicity] || Participant.ethnicity,
      languages: attrs[:languages] || Participant.languages,
      addresses: attrs[:addresses] || []
    }
  end

  def self.victim(attrs = {})
    participant = collateral(attrs)
    participant[:roles] = ['Victim']
    participant
  end

  def self.perpetrator(attrs = {})
    participant = collateral(attrs)
    participant[:roles] = ['Perpetrator']
    participant
  end

  def self.reporter(attrs = {})
    participant = collateral(attrs)
    participant[:roles] = ['Mandated Reporter']
    participant[:addresses] = [Address.full_address]
    participant
  end
end
