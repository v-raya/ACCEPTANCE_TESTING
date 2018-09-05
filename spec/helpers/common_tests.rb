# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
def default_screening_information_spec
  data = {
    name: 'Hello World',
    start_date: '08/01/2018 3:44 PM',
    end_date: '08/02/2018 3:44 PM',
    communication_method: 'Email'
  }
  ScreeningInformation.complete_form_and_save(data)
  within('#screening-information-card') do
    data.each do |_key, value|
      expect(page).to have_content(value)
    end
  end
end

def default_narrative_spec
  data = {
    report_narrative: 'Narrative for this screening'
  }
  Narrative.complete_form_and_save(data)
  within('#narrative-card') do
    data.each do |_key, value|
      expect(page).to have_content(value)
    end
  end
end

def default_incident_information_spec
  data = {
    incident_date: '08/01/2018',
    street_address: '547 Rare St',
    city: 'Sacramento',
    zip: '99999',
    state: 'California',
    location_type: 'In Public'
  }
  IncidentInformation.complete_form_and_save(data)
  within('#incident-information-card') do
    data.each do |_key, value|
      expect(page).to have_content(value)
    end
  end
end

def default_relationships_spec(**_args)
  skip 'Waiting till Relationship card is fixed'
end

def default_worker_safety_spec
  data = {
    safety_alerts: ['Hostile Aggressive Client', 'Dangerous Animal on Premises'],
    safety_information: 'Summary for worker safety'
  }
  WorkerSafety.complete_form_and_save(data)
  within('#worker-safety-card') do
    data.each do |_key, value|
      expect(page).to have_content(value)
    end
  end
end

def default_allegations_spec
  data = {
    allegations: ['General Neglect']
  }
  Allegation.complete_form_and_save(data)
  within('#allegations-card') do
    expect(page).to have_content('General Neglect')
  end
end

def default_cross_report_spec
  data = {
    county: 'Sacramento',
    district_attorney: 'District Attorney',
    law_enforcement: 'Law Enforcement'
  }
  CrossReport.complete_form_and_save(data)
  within('#cross-report-card') do
    data.each do |_key, value|
      expect(page).to have_content(value)
    end
  end
end

def default_decision_spec
  data =
    {
      screening_decision: 'Promote to referral',
      access_restrictions: 'Do not restrict access',
      additional_information: 'This is where additional information is provided',
      response_time: '3 days'
    }
  Decision.complete_form_and_save(data)
  within('#decision-card') do
    data.each do |_key, value|
      expect(page).to have_content(value)
    end
  end
end
