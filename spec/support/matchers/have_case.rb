# frozen_string_literal: true

RSpec::Matchers.define :have_case do |expected|
  match do |actual|
    start_date = expected[:start_date]
    end_date = expected[:end_date]
    case_id = expected[:case_id]
    status = expected[:status]
    service_component = expected[:service_component]
    county = expected[:county]
    worker = expected[:worker]
    focus_child = expected[:focus_child]
    parents = expected[:parents]

    expect(actual).to have_content [start_date, end_date].compact.join(' - ')
    expect(actual).to have_content "Case #{case_id} (#{[status, service_component].join(' - ')})"
    expect(actual).to have_content county if county
    expect(actual).to have_content "Focus Child: #{focus_child}"
    expect(actual).to have_content "Parent(s):"
    parents.each do |parent|
      expect(actual).to have_content parent
    end
    expect(actual).to have_content "Worker: #{worker}"
  end

  failure_message do |actual|
    "expected case information to be contained in #{actual.text}"
  end
end
