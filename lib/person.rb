# frozen_string_literal: true

require_relative '../helpers/person_helper'
require_relative '../helpers/form_helper'

# person
class Person
  extend FormHelper
  include PersonHelpers

  attr_reader :first_name, :middle_name, :last_name, :suffix,
              :date_of_birth, :ssn, :gender, :role, :card_id,
              :id, :languages, :race

  def initialize(**args)
    assign_name(args)
    assigns_role(args)
    @date_of_birth  = args.fetch(:date_of_birth) { Faker::Date.birthday(18, 66).strftime('%m/%d/%Y') }
    @ssn            = args.fetch(:ssn, Faker::Base.numerify('7##-1#-####'))
  end

  def assign_name(args)
    @first_name     = args.fetch(:first_name, Faker::Name.first_name)
    @middle_name    = args[:middle_name]
    @last_name      = args.fetch(:last_name, Faker::Name.last_name)
    @suffix         = args.fetch(:suffix, SUFFIX.sample)
  end

  def assigns_role(args)
    @role           = Array(args[:role]) | ['Family Member', 'Collateral']
  end

  def full_name
    [first_name, middle_name, last_name].reject(&:blank?).join(' ')
  end

  def search_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def click_remove
    find('.card-header', text: person.full_name).find_button('Remove')
  end

  def assign_card_id
    @card_id ||= page.find('.card-header', text: full_name).ancestor('.card')[:id]
    const_set('CONTAINER', "##{assign_card_id}")
  end

  def complete_form(**args)
    @new_card_id ||= find_all('.card-header', text: 'Unknown Person').first.ancestor('.card')[:id]
    @id ||= @new_card_id.match(/[^-]\d+/)
    self.class.const_set('CONTAINER', "##{@new_card_id}")
    self.class.const_set('DEFAULT_VALUES', updated_default_values)
    self.class.complete_form_and_save(args)
  end

  def updated_default_values(**args)
    {
      first_name: first_name,
      middle_name: middle_name,
      last_name: last_name,
      ssn: ssn,
      date_of_birth_input: date_of_birth,
      suffix: suffix,
      approximate_age_units: args.fetch(:approximate_age_units, APPROXIMATE_AGE.sample),
      gender: args.fetch(:gender, SEX_AT_BIRTH.sample),
      race: args.fetch(:races, RACES.keys.sample),
      ethnicity: args.fetch(:ethnicity, HISPANIC_LATINO_ORIGIN.keys.sample),
      role: role,
      languages: args.fetch(:languages, LANGUAGES.sample(2))
    }
  end
end
