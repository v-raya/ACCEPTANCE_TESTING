# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
def check_select_options
  options = [
    'Dangerous Animal on Premises',
    'Dangerous Environment',
    'Firearms in Home',
    'Gang Affiliation or Gang Activity',
    'Hostile, Aggressive Client',
    'Remote or Isolated Location',
    'Severe Mental Health Status',
    'Threat or Assault on Staff Member',
    'Other'
  ]
  has_react_select_field('Worker safety alerts', options: options)
end
# rubocop:enable Metrics/MethodLength

describe 'Worker Safety Card', type: :feature do
  before do
    ScreeningPage.new.visit
  end

  it 'saves a blank card' do
    within '#worker-safety-card' do
      check_select_options
      within '.card-header' do
        expect(page).to have_content('Worker Safety')
      end
      expect(page).to have_content('Worker safety alerts')
      has_react_select_field('Worker safety alerts', with: [])
      expect(page).to have_content('Additional safety information')
      expect(page).to have_field('Additional safety information', with: '')
      expect(page).to have_button('Save')
      expect(page).to have_button('Cancel')
      # Saving a blank card and validating
      click_button 'Save'
      within '.card-header' do
        expect(page).to have_content('Worker Safety')
      end
      within '.card-body' do
        expect(page.text).to eq('Worker safety alerts Additional safety information')
      end
      within '.card-header' do
        expect(page).to have_content('Worker Safety')
        click_link 'Edit'
      end
      within '.card-body' do
        expect(page).to have_content('Worker safety alerts')
        has_react_select_field('Worker safety alerts', with: [])
        expect(page).to have_content('Additional safety information')
        expect(page).to have_field('Additional safety information', with: '')
      end
    end
  end

  it 'Selecting and fill in data scenario' do
    within '#worker-safety-card' do
      check_select_options
      expect(page).to have_content('Worker safety alerts')
      fill_in_react_select 'Worker safety alerts', with: ['Firearms in Home']
      fill_in_react_select 'Worker safety alerts', with: ['Other']
      fill_in('Additional safety information',
              with: 'There is h@ndgun on the prem1se$. And the dude is mean')
      click_button 'Save'
      expect(page).to have_content('Firearms in Home')
      expect(page).to have_content('Other')
      expect(page).to have_content('Additional safety information')
      expect(page).to have_content(
        'There is h@ndgun on the prem1se$. And the dude is mean'
      )
      # Test cancelling scenario
      within '.card-header' do
        click_link 'Edit'
      end
      alert_input = find_field('Worker safety alerts')
      2.times do
        alert_input.send_keys(:backspace)
      end
      has_react_select_field('Worker safety alerts', with: [])
      fill_in_react_select 'Worker safety alerts',
                           with: ['Remote or Isolated Location']
      fill_in('Additional safety information', with: 'Et Tu Brute?')
      # Verify new data was not saved on 'Cancel'
      click_button 'Cancel'
      expect(page).to have_content('Firearms in Home')
      expect(page).to have_content('Other')
      expect(page).to have_content(
        'There is h@ndgun on the prem1se$. And the dude is mean'
      )
    end
  end
end
