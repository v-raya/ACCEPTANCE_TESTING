# frozen_string_literal: true
require 'react_select_helpers'

describe 'R2 Screening', type: :feature do
  # Selecting Create Person on homepage
  before do
    visit '/'
    click_link 'Start Screening'
  end

  # Fill in data in the Input fields
  it 'Test Screening card' do
    within '#screening-information-card' do
      fill_in('Title/Name of Screening', with: 'Child Abandonment')
      fill_in('Assigned Social Worker', with: 'Jane SocialWorker')
      fill_in('Screening Start Date/Time', with: '08/22/2006 10:00 AM')
      fill_in('Screening End Date/Time', with: '08/22/2006 11:00 AM')
      select 'Mail', from: 'Communication Method'
      click_button 'Save'

      expect(page).to have_content('SCREENING INFORMATION')
      expect(page).to have_content('Child Abandonment')
      expect(page).to have_content('Jane SocialWorker')
      expect(page).to have_content('08/22/2006')
      expect(page).to have_content('10:00 AM')
      expect(page).to have_content('11:00 AM')
      expect(page).to have_content('Mail')

      # click on the pencil icon in header to invoke the edit page
      find(:css, 'i.fa.fa-pencil').click

      # Validate info and make edits to the input fields
      expect(page).to have_field('Title/Name of Screening',
                                 with: 'Child Abandonment')
      expect(page).to have_field('Assigned Social Worker',
                                 with: 'Jane SocialWorker')
      expect(page).to have_field('Screening Start Date/Time',
                                 with: '08/22/2006 10:00 AM')
      expect(page).to have_field('Screening End Date/Time',
                                 with: '08/22/2006 11:00 AM')
      expect(page).to have_select('Communication Method', selected: 'Mail')

      fill_in('Assigned Social Worker', with: 'John SocialWorker')
      fill_in('Screening Start Date/Time', with: '08/22/2006 09:00 AM')
      select 'Fax', from: 'Communication Method'
      click_button 'Save'

      # Verify new info saved
      expect(page).to have_content('SCREENING INFORMATION')
      expect(page).to have_content('Child Abandonment')
      expect(page).to have_content('John SocialWorker')
      expect(page).to have_content('08/22/2006')
      expect(page).to have_content('9:00 AM')
      expect(page).to have_content('11:00 AM')
      expect(page).to have_content('Fax')

      # click on the pencil icon in header to invoke the edit page
      find(:css, 'i.fa.fa-pencil').click

      # Validate info and make edits to the input fields
      expect(page).to have_field('Title/Name of Screening',
                                 with: 'Child Abandonment')
      expect(page).to have_field('Assigned Social Worker',
                                 with: 'John SocialWorker')
      expect(page).to have_field('Screening Start Date/Time',
                                 with: '08/22/2006 09:00 AM')
      expect(page).to have_field('Screening End Date/Time',
                                 with: '08/22/2006 11:00 AM')
      expect(page).to have_select('Communication Method', selected: 'Fax')
      fill_in('Assigned Social Worker', with: 'Helen SocialWorker')
      fill_in('Screening Start Date/Time', with: '08/22/2006 09:30 AM')
      select 'Online', from: 'Communication Method'
    end

    click_button('Cancel', match: :first)

    # Verify new info is not saved and previous data is unchanged
    within '#screening-information-card' do
      expect(page).to have_content('SCREENING INFORMATION')
      expect(page).to have_content('Child Abandonment')
      expect(page).to have_content('John SocialWorker')
      expect(page).to have_content('08/22/2006')
      expect(page).to have_content('9:00 AM')
      expect(page).to have_content('11:00 AM')
      expect(page).to have_content('Fax')
    end
  end
end
