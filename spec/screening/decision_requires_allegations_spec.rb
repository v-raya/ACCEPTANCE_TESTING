# frozen_string_literal: true

describe 'Selecting promote to referral requires allegations', type: :feature do
  let(:screening_page) { ScreeningPage.new }
  let(:decision_error_message) { 'Please enter at least one allegation to promote to referral.' }
  let(:allegation_error_message) { 'Any report that is promoted for referral must include at least one allegation.' }

  victim = Participant.victim
  perpetrator = Participant.perpetrator

  before do
    screening_page.visit
    expect(page).to have_content 'Screening #'

    victim[:id] = screening_page.add_new_person victim
    perpetrator[:id] = screening_page.add_new_person perpetrator
  end

  it 'displays an error message below the decision select box until a user adds an allegation type' do
    screening_page.set_decision_attributes(screening_decision: 'Promote to referral')

    within '#decision-card' do
      expect(page).to have_content decision_error_message
    end

    within '#allegations-card' do
      expect(page).to have_content allegation_error_message
    end

    screening_page.set_allegations_attributes(allegations: [
                                                {
                                                  victim_id: victim[:id],
                                                  perpetrator_id: perpetrator[:id],
                                                  allegation_types: ['Exploitation']
                                                }
                                              ])

    within '#decision-card' do
      expect(page).not_to have_content decision_error_message
    end

    within '#allegations-card' do
      expect(page).not_to have_content allegation_error_message
    end
  end

  it 'removes the error messages if the user changes the decision' do
    screening_page.set_decision_attributes(screening_decision: 'Promote to referral')

    within '#decision-card' do
      expect(page).to have_content decision_error_message
    end

    screening_page.set_decision_attributes(screening_decision: '')

    within '#decision-card' do
      expect(page).not_to have_content decision_error_message
    end

    within '#allegations-card' do
      expect(page).not_to have_content allegation_error_message
    end
  end
end
