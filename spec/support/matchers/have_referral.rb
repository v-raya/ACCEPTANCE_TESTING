# frozen_string_literal: true

RSpec::Matchers.define :have_referral do |expected|
  match do |actual|
    start_date = expected[:start_date]
    end_date = expected[:end_date]
    referral_id = expected[:referral_id]
    status = expected[:status]
    response_time = expected[:response_time]
    county = expected[:county]
    reporter = expected[:reporter]
    worker = expected[:worker]
    allegations = expected[:allegations]

    expect(actual).to have_content [start_date, end_date].compact.join(' - ')
    expect(actual).to have_content "Referral #{referral_id} (#{[status, response_time].join(' - ')})"
    expect(actual).to have_content county if county
    expect(actual).to have_content "Reporter: #{reporter}"
    expect(actual).to have_content "Worker: #{worker}"
    expect(actual).to have_content 'Victim Perpetrator Allegation(s) & Disposition'
    allegations.each do |allegation|
      expect(actual).to have_content "#{allegation[:victim]} #{allegation[:perpetrator]} #{allegation[:type]} (#{allegation[:disposition]})".squeeze(' ')
    end
  end

  failure_message do |actual|
    "expected referral information to be contained in #{actual.text}"
  end
end
