# frozen_string_literal: true

RSpec::Matchers.define :have_screening do |expected|
  match do |actual|
    start_date = expected[:start_date]
    end_date = expected[:end_date]
    status = expected[:status]
    county = expected[:county]
    reporter = expected[:reporter]
    worker = expected[:worker]
    people_names = expected[:people_names]

    expect(actual).to have_content [start_date, end_date].compact.join(' - ')
    expect(actual).to have_content "Screening (#{status})"
    expect(actual).to have_content county if county
    expect(actual).to have_content people_names.join(', ')
    expect(actual).to have_content "Reporter: #{reporter}"
    expect(actual).to have_content "Worker: #{worker}"
  end

  failure_message do |actual|
    "expected screening information to be contained in #{actual.text}"
  end
end
