# frozen_string_literal: true

require_relative '../helpers/person_helper'
require_relative '../helpers/person_form_helper'

# person
class Person
  include PersonFormHelper
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
    @suffix         = args[:suffix]
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
end
