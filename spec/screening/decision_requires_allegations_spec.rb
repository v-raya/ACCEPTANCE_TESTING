describe 'Selecting promote to referral requires allegations', type: :feature do
  let(:screening_page) { ScreeningPage.new }
  let(:decision_error_message) { 'Please enter at least one allegation to promote to referral.' }
  let(:allegation_error_message) { 'Any report that is promoted for referral must include at least one allegation.' }

  victim = { roles: ['Victim'] }
  perpetrator = { roles: ['Perpetrator'] }

  before do
    screening_page.visit_screening
    expect(page).to have_content 'Screening #'

    [victim, perpetrator].each do |person|
      screening_page.add_new_person
      person_id = page.all('div[id^="participants-card-"]').first[:id].split('-').last
      screening_page.set_participant_attributes(person_id, roles: person[:roles])
      person[:id] = person_id
    end
  end

  it 'displays an error message below the decision select box until a user adds an allegation type' do
    screening_page.set_decision_attributes(screening_decision: 'Promote to referral')

    within '#decision-card' do
      expect(page).to have_content decision_error_message
    end

    within '#allegations-card' do
      expect(page).to have_content allegation_error_message
    end

    screening_page.set_allegations_attributes(allegations: [['Exploitation']])

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
