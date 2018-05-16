# frozen_string_literal: true

require_relative 'person.rb'

# vicitim
class Victim < Person
  def initialize(**args)
    super
    @date_of_birth = args.fetch(:date_of_birth) { Faker::Date.birthday(0, 17).strftime('%m/%d/%Y') }
    @role = Array(args[:roles]) | %w[Victim]
  end
end
