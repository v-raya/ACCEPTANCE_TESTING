# frozen_string_literal: true

module Participant
  def self.full_name(participant)
    name  = "#{participant[:first_name] || '(Unknown first name)'} "
    name += "#{participant[:middle_name]} " if participant[:middle_name]
    name += participant[:last_name] || '(Unknown last name)'
    name
  end

  def self.keys
    %i(roles first_name middle_name last_name name_suffix gender ssn date_of_birth
       races ethnicity languages addresses)
  end

  def self.all_ethnicity_details
    ['Mexican', 'Costa Rican', 'Mayan']
  end

  def self.all_genders
    %w(Male Female Unknown)
  end

  def self.all_languages
    ['American Sign Language', 'Arabic', 'Armenian', 'Cambodian', 'Cantonese', 'English', 'Farsi',
     'French', 'German', 'Hawaiian', 'Hebrew', 'Hmong', 'Ilocano', 'Indochinese', 'Italian',
     'Japanese', 'Korean', 'Lao', 'Mandarin', 'Mien', 'Other Chinese', 'Other Non-English',
     'Polish', 'Portuguese', 'Romanian', 'Russian', 'Samoan', 'Sign Language (Not ASL)',
     'Spanish', 'Tagalog', 'Thai', 'Turkish', 'Vietnamese']
  end

  def self.all_races
    ['White', 'Black or African American', 'Asian', 'Unknown']
  end

  def self.all_roles
    ['Victim', 'Perpetrator', 'Mandated Reporter', 'Non-mandated Reporter', 'Anonymous Reporter']
  end

  def self.all_race_details
    %w(European Caribbean Korean Ethiopian)
  end

  def self.roles(value = nil)
    value || all_roles.sample(rand(1..2))
  end

  def self.first_name(value = nil)
    value || FFaker::Name.first_name
  end

  def self.middle_name(value = nil)
    value || FFaker::Product.letters(1)
  end

  def self.last_name(value = nil)
    value || FFaker::Name.last_name
  end

  def self.name_suffix(value = nil)
    value || FFaker::Name.suffix
  end

  def self.gender(value = nil)
    value || Participant.all_genders.sample
  end

  def self.ssn(value = nil)
    value || "#{rand(9)}#{FFaker.numerify('##-##-####')}"
  end

  def self.date_of_birth(value = nil)
    value || generate_date(1970, 2017)
  end

  def self.race(value = nil)
    value || all_races.sample
  end

  def self.race_detail(value = nil)
    value || all_race_details.sample
  end

  def self.races(value = nil)
    value || Array.new(rand(0..2)) { { race: race, race_detail: race_detail } }
  end

  def self.hispanic_latino_origin(value = nil)
    value || ['Yes', 'No', nil, nil].sample
  end

  def self.ethnicity_detail(value = nil)
    value || all_ethnicity_details.sample
  end

  def self.ethnicity(value = nil)
    value || hispanic_latino = hispanic_latino_origin
    { hispanic_latino_origin: hispanic_latino,
      ethnicity_detail: hispanic_latino ? ethnicity_detail : nil }
  end

  def self.languages(value = nil)
    value || all_languages.sample(rand(3))
  end

  def self.addresses(value = nil)
    value || Array.new(rand(0..2)) { Address.full_address }
  end

  def self.random(attrs = {})
    participant = {}
    Participant.keys.each do |key|
      participant[key] = Participant.send(key, attrs[key])
    end
    participant
  end

  def self.collateral(attrs = {})
    attrs[:roles] = []
    random(attrs)
  end

  def self.victim(attrs = {})
    attrs[:roles] = ['Victim']
    attrs[:date_of_birth] = generate_date(Date.today.year - rand(16), Date.today.year)
    random(attrs)
  end

  def self.perpetrator(attrs = {})
    attrs[:roles] = ['Perpetrator']
    random(attrs)
  end

  def self.reporter(attrs = {})
    attrs[:roles] = ['Mandated Reporter']
    attrs[:addresses] ||= [Address.full_address]
    random(attrs)
  end
end
