# frozen_string_literal: true

describe 'A State Social Worker', type: :feature do
  user = STATE_SEALED_SOCIAL_WORKER
  let(:screening) { Screening.new }
  let(:victim) do
    {
      first_name: 'Peter',
      middle_name: '',
      last_name: 'Gasticke',
      date_of_birth_input: (Date.today - (365 * 10)).strftime('%m/%d/%Y')
    }
  end
  let(:reporter) do
    {
      first_name: 'Mohammed',
      middle_name: '',
      last_name: 'John',
      date_of_birth_input: (Date.today - (365 * 25)).strftime('%m/%d/%Y')
    }
  end
  let(:perpetrator) do
    {
      first_name: 'Create',
      middle_name: 'New',
      last_name: 'User',
      date_of_birth_input: (Date.today - (365 * 55)).strftime('%m/%d/%Y')
    }
  end

  before(:all) do
    login_user(user: user, path: new_screening_path)
  end

  describe 'with Sealed privilege' do
    describe 'submits a referral' do
      it 'Screening Information completes and saves' do
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

      it 'Narrative completes and saves' do
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

      it 'Incident Information completes and saves' do
        data = {
          incident_date: '08/01/2018 3:44 PM',
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

      it 'Allegations completes and saves' do
        screening.attach_victim(victim) do |person|
          person.complete_form_and_save(victim)
        end
        screening.attach_reporter(reporter) do |person|
          person.complete_form_and_save(reporter)
        end
        screening.create_perpetrator(perpetrator) do |person|
          person.complete_form_and_save(perpetrator)
        end

        allegations = { allegations: ['General Neglect'] }
        Allegation.complete_form_and_save(allegations)
        within('#allegations-card') do
          expect(page).to have_content('General Neglect')
        end
      end

      it 'Relationships completes and saves' do
        skip 'Waiting till Relationship card is fixed'
      end

      it 'Worker Safety completes and saves' do
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

      it 'Cross Report completes and saves' do
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

      it 'Decision completes and saves' do
        data = {
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

      it 'Submit screening and display referral id' do
        screening.click_submit
        expect(page).to have_css('h1', text: 'Referral')
      end
    end
  end
end
