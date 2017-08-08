# frozen_string_literal: true

describe 'Sibling At Risk Validation Tests', type: :feature do
  victim1 = {
    roles: ['Victim'],
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name
  }
  perpetrator1 = {
    roles: ['Perpetrator'],
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name
  }
  victim2 = {
    roles: ['Victim'],
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name
  }
  perpetrator2 = {
    roles: ['Perpetrator'],
    first_name: FFaker::Name.first_name,
    last_name: FFaker::Name.last_name
  }

  let(:screening_page) { ScreeningPage.new }
  let(:error_message) do
    'Any allegations of Sibling at Risk must be accompanied by another allegation.'
  end

  before do
    screening_page.visit_screening
    [victim1, perpetrator1, victim2, perpetrator2].each do |person|
      person_id = screening_page.add_new_person
      screening_page.set_participant_attributes(
        person_id,
        roles: person[:roles],
        first_name: person[:first_name],
        last_name: person[:last_name],
        middle_name: person[:middle_name]
      )
      person[:id] = person_id
    end
  end

  context 'Notifying the user when conditions require an allegation' do
    context 'when adding one or more allegations of "At risk, sibling abused"' do
      context 'has not added any complementary allegation to a different victim\'s maltreatment' do
        it 'displays an error message' do
          screening_page.set_allegations_attributes(allegations: [
                                                      {
                                                        victim_id: victim1[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['At risk, sibling abused']
                                                      }
                                                    ])

          within '#allegations-card' do
            expect(page).to have_content(error_message)
            click_link 'Edit'
            expect(page).to have_content(error_message)
          end
        end
      end

      context 'has only added other allegations to a different perpetrator\'s maltreatment of a victim' do
        it 'displays an error message' do
          screening_page.set_allegations_attributes(allegations: [
                                                      {
                                                        victim_id: victim1[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['At risk, sibling abused']
                                                      },
                                                      {
                                                        victim_id: victim2[:id],
                                                        perpetrator_id: perpetrator2[:id],
                                                        allegation_types: ['Physical abuse']
                                                      }
                                                    ])

          within '#allegations-card' do
            expect(page).to have_content(error_message)
            click_link 'Edit'
            expect(page).to have_content(error_message)
          end
        end
      end
    end
  end

  context 'Fixing missing fields' do
    context 'when adding one or more allegations of "At risk, sibling abused"' do
      context 'has not added any complementary allegation to a different victim\'s maltreatment' do
        it 'to satisfy the error when complementary allegation is added' do
          screening_page.set_allegations_attributes(allegations: [
                                                      {
                                                        victim_id: victim1[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['At risk, sibling abused']
                                                      }
                                                    ])

          within '#allegations-card' do
            expect(page).to have_content(error_message)
            click_link 'Edit'
            expect(page).to have_content(error_message)
          end

          screening_page.set_allegations_attributes(allegations: [
                                                      {
                                                        victim_id: victim1[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['At risk, sibling abused']
                                                      },
                                                      {
                                                        victim_id: victim2[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['Physical abuse']
                                                      }
                                                    ])

          within '#allegations-card' do
            expect(page).not_to have_content(error_message)
            click_link 'Edit'
            expect(page).not_to have_content(error_message)
          end
        end
      end

      context 'has only added other allegations to a different perpetrator\s maltreatment of a victim' do
        it 'to satisfy the error when complementary allegation is added' do
          screening_page.set_allegations_attributes(allegations: [
                                                      {
                                                        victim_id: victim1[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['At risk, sibling abused']
                                                      },
                                                      {
                                                        victim_id: victim2[:id],
                                                        perpetrator_id: perpetrator2[:id],
                                                        allegation_types: ['Physical abuse']
                                                      }
                                                    ])

          within '#allegations-card' do
            expect(page).to have_content(error_message)
            click_link 'Edit'
            expect(page).to have_content(error_message)
          end

          screening_page.set_allegations_attributes(allegations: [
                                                      {
                                                        victim_id: victim2[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['General neglect']
                                                      }
                                                    ])

          within '#allegations-card' do
            expect(page).not_to have_content(error_message)
            click_link 'Edit'
            expect(page).not_to have_content(error_message)
          end
        end
      end
    end
  end

  context 'Removing the conditional business rule' do
    context 'when adding one or more allegations of "At risk, sibling abused"' do
      context 'has not added any complementary allegation to a different victim\'s maltreatment' do
        it 'satisfies the error when "At risk, sibling abused" is removed' do
          screening_page.set_allegations_attributes(allegations: [
                                                      {
                                                        victim_id: victim1[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['At risk, sibling abused']
                                                      }
                                                    ])

          within '#allegations-card' do
            expect(page).to have_content(error_message)
            click_link 'Edit'
            expect(page).to have_content(error_message)
          end

          screening_page.set_allegations_attributes(allegations: [
                                                      {
                                                        victim_id: victim1[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['Physical abuse']
                                                      }
                                                    ])

          within '#allegations-card' do
            expect(page).not_to have_content(error_message)
            click_link 'Edit'
            expect(page).not_to have_content(error_message)
          end
        end
      end

      context 'has only added other allegations to a different perpetrator\'s maltreatment of a victim' do
        it 'satisfies the error when "At risk, sibling abused" is removed' do
          screening_page.set_allegations_attributes(allegations: [
                                                      {
                                                        victim_id: victim1[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['At risk, sibling abused']
                                                      },
                                                      {
                                                        victim_id: victim2[:id],
                                                        perpetrator_id: perpetrator2[:id],
                                                        allegation_types: ['Physical abuse']
                                                      }
                                                    ])

          within '#allegations-card' do
            expect(page).to have_content(error_message)
            click_link 'Edit'
            expect(page).to have_content(error_message)
          end

          screening_page.set_allegations_attributes(allegations: [
                                                      {
                                                        victim_id: victim1[:id],
                                                        perpetrator_id: perpetrator1[:id],
                                                        allegation_types: ['General neglect']
                                                      }
                                                    ])

          within '#allegations-card' do
            expect(page).not_to have_content(error_message)
            click_link 'Edit'
            expect(page).not_to have_content(error_message)
          end
        end
      end
    end
  end
end
