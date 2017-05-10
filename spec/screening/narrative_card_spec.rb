# frozen_string_literal: true
require 'helper_methods'

describe 'Narrative card', type: :feature do
  # Selecting Create Person on homepage
  it 'Testing narrative card' do
    visit '/'
    login_user
    click_link 'Start Screening'
    within '#narrative-card' do
      within '.card-header' do
        expect(page).to have_content('NARRATIVE')
      end
      # Saving a blank card and validating
      click_button 'Save'
      within '.card-body' do
        expect(page).to have_content('Report Narrative')
      end
      within '.card-header' do
        expect(page).to have_content('NARRATIVE')
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        fill_in 'Report Narrative',
                with: 'Fr1ends, Rom@ns, countrymen, 1end me your ears;'
        click_button 'Save'
        expect(page).to have_content(
          'Fr1ends, Rom@ns, countrymen, 1end me your ears;'
        )
      end
      within '.card-header' do
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        expect(page).to have_field(
          'Report Narrative',
          with: 'Fr1ends, Rom@ns, countrymen, 1end me your ears;'
        )
        fill_in 'Report Narrative', with: 'Et Tu Brute?'
        # Verify new data was not saved on 'Cancel'
        click_button 'Cancel'
        expect(page).to have_content(
          'Fr1ends, Rom@ns, countrymen, 1end me your ears;'
        )
      end
    end
  end
end
