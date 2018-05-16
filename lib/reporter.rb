# frozen_string_literal: true

require_relative 'person.rb'

# reporter
class Reporter < Person
  def initialize(**args)
    super
    @date_of_birth = args.fetch(:date_of_birth) { Faker::Date.birthday(18, 66).strftime('%m/%d/%Y') }
    @role = Array(args[:roles]) | ['Non-mandated Reporter', 'Mandated Reporter', 'Anonymous Reporter'].sample(1)
  end
end
