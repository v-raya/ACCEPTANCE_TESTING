# frozen_string_literal: true
require 'react_select_helpers'
require 'helper_methods'

describe 'Screening QA Test', type: :feature do
  # Selecting Start Screening from homepage
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  scr_info = {
    title1: 'Child @bandonment1',
    worker1: 'Jane $ocialWorker1',
    worker2: 'John Socialworker',
    comm1: 'Mail',
    comm2: 'Fax',
    sdate: '08/13/2016',
    sdate2: '08/12/2016',
    edate: '08/15/2016'
  }
  scr_info2 = {
    worker: 'Helen Socialworker',
    sdate: '08/22/2016',
    comm: 'Online'
  }

  # Fill in data in the Input fields
  it 'Test Screening card' do
    within '#screening-information-card' do
      within '.card-header' do
        expect(page).to have_content('SCREENING INFORMATION')
      end
      within '.card-body' do
        # Verify initial rendering of screening card
        expect(page).to have_content('Title/Name of Screening')
        expect(page).to have_content('Assigned Social Worker')
        expect(page).to have_content('Screening Start Date/Time')
        expect(page).to have_content('Screening End Date/Time')
        expect(page).to have_content('Communication Method')
        expect(page).to have_field('Title/Name of Screening',
                                   with: '')
        expect(page).to have_field('Assigned Social Worker',
                                   with: '')
        expect(page).to have_field('Screening Start Date/Time',
                                   with: '')
        expect(page).to have_field('Screening End Date/Time',
                                   with: '')
        has_react_select_field('Communication Method', with: [])
        expect(page).to have_button('Save')
        expect(page).to have_button('Cancel')
        fill_in('Title/Name of Screening', with: scr_info[:title1])
        fill_in('Assigned Social Worker', with: scr_info[:worker1])
        fill_in('Screening Start Date/Time', with: scr_info[:sdate])
        fill_in('Screening End Date/Time', with: scr_info[:edate])
        select scr_info[:comm1], from: 'Communication Method'
        click_button 'Save'
      end
      expect(page).to have_content('SCREENING INFORMATION')
      expect(page).to have_content(scr_info[:title1])
      expect(page).to have_content(scr_info[:worker1])
      expect(page).to have_content(scr_info[:sdate])
      expect(page).to have_content(scr_info[:sdate])
      expect(page).to have_content(scr_info[:comm1])

      # click on the pencil icon in header to invoke the edit page
      find(:css, 'i.fa.fa-pencil').click
      # Validate info and make edits to the input fields
      expect(page).to have_field('Title/Name of Screening',
                                 with: scr_info[:title1])
      expect(page).to have_field('Assigned Social Worker',
                                 with: scr_info[:worker1])
      # Need test for how date is displayed once date picker is complete
      expect(page).to have_select('Communication Method',
                                  selected: scr_info[:comm1])
      fill_in('Assigned Social Worker', with: scr_info[:worker2])
      fill_in('Screening Start Date/Time', with: scr_info[:sdate2])
      select scr_info[:comm2], from: 'Communication Method'
      click_button 'Save'

      # Verify new info saved
      expect(page).to have_content('SCREENING INFORMATION')
      expect(page).to have_content(scr_info[:title1])
      expect(page).to have_content(scr_info[:worker2])
      expect(page).to have_content(scr_info[:sdate2])
      expect(page).to have_content(scr_info[:edate])
      expect(page).to have_content(scr_info[:comm2])

      # click on the pencil icon in header to invoke the edit page
      find(:css, 'i.fa.fa-pencil').click
      # Validate info and make edits to the input fields
      expect(page).to have_field('Title/Name of Screening',
                                 with: scr_info[:title1])
      expect(page).to have_field('Assigned Social Worker',
                                 with: scr_info[:worker2])
      # Need test for how date is displayed once date picker is complete
      expect(page).to have_select('Communication Method',
                                  selected: scr_info[:comm2])
      fill_in('Assigned Social Worker', with: scr_info2[:worker])
      fill_in('Screening Start Date/Time', with: scr_info2[:sdate])
      select scr_info2[:comm], from: 'Communication Method'
    end
    click_button('Cancel', match: :first)

    # Verify new info is not saved and previous data is unchanged
    within '#screening-information-card' do
      expect(page).to have_content('SCREENING INFORMATION')
      expect(page).to have_content(scr_info[:title1])
      expect(page).to have_content(scr_info[:worker2])
      expect(page).to have_content(scr_info[:sdate2])
      expect(page).to have_content(scr_info[:edate])
      expect(page).to have_content(scr_info[:comm2])
    end
  end
end
