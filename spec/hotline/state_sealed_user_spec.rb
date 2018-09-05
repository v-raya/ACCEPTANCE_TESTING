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
      first_name: 'Bob',
      middle_name: '',
      last_name: 'Lujan',
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
        default_screening_information_spec
      end

      it 'Narrative completes and saves' do
        default_narrative_spec
      end

      it 'Incident Information completes and saves' do
        default_incident_information_spec
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

        default_allegations_spec
      end

      it 'Relationships completes and saves' do
        default_relationships_spec
      end

      it 'Worker Safety completes and saves' do
        default_worker_safety_spec
      end

      it 'Cross Report completes and saves' do
        default_cross_report_spec
      end

      it 'Decision completes and saves' do
        default_decision_spec
      end

      it 'Submit screening and display referral id' do
        screening.click_submit
        expect(page).to have_css('h1', text: 'Referral')
      end
    end
  end
end
