# frozen_string_literal: true

describe 'Screening QA Test', type: :feature do
  # Selecting Start Screening from homepage
  before do
    ScreeningPage.new.visit
  end

  screen_info_init = {
    title: 'Child abandonment',
    comm: 'Mail',
    sdate: '08/13/2016 11:00 AM',
    edate: '08/15/2016 7:00 PM'
  }

  screen_info_chng1 = {
    comm: 'Fax',
    sdate: '08/12/2016 1:00 PM'
  }

  screen_info_chng2 = {
    sdate: '08/22/2016 3:00 PM',
    comm: 'In Person'
  }

  it 'restricts allowed characters in title and assigned worker fields' do
    character_buffet = 'C am-ron1234567890!@#$%^&*(),./;"[]'
    within '#screening-information-card.edit' do
      fill_in 'Title/Name of Screening', with: character_buffet
      expect(page).to have_field('Title/Name of Screening', with: 'C am-ron')
    end
  end

  # Fill in data in the Input fields
  it 'Test Screening card' do
    within '#screening-information-card' do
      within '.card-header' do
        expect(page).to have_content('Screening Information')
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
                                   disabled: true)
        expect(page).to have_field('Screening Start Date/Time',
                                   with: Time.now.strftime('%m/%d/%Y %-l:%M %p'))
        expect(page).to have_field('Screening End Date/Time',
                                   with: '')
        expect(page).to have_select('Communication Method', selected: '')
        expect(page).to have_button('Save')
        expect(page).to have_button('Cancel')
        fill_in('Title/Name of Screening', with: screen_info_init[:title])
        # In selenium_firefox, if you put this after the fill_in_datepicker, it will unset the datepicker
        # ¯\_(ツ)_/¯
        select screen_info_init[:comm], from: 'Communication Method'
        fill_in_datepicker('Screening Start Date/Time', with: screen_info_init[:sdate])
        fill_in_datepicker('Screening End Date/Time', with: screen_info_init[:edate])
        click_button 'Save'
      end
      expect(page).to have_content('Screening Information')
      expect(page).to have_content(screen_info_init[:title])
      expect(page).to have_content('Assigned Social Worker')
      expect(page).to have_content(screen_info_init[:sdate])
      expect(page).to have_content(screen_info_init[:edate])
      expect(page).to have_content(screen_info_init[:comm])

      click_link 'Edit'
      # Validate info and make edits to the input fields
      expect(page).to have_field('Title/Name of Screening',
                                 with: screen_info_init[:title])
      expect(page).to have_field('Assigned Social Worker',
                                 disabled: true)
      # Need test for how date is displayed once date picker is complete
      expect(page).to have_select('Communication Method',
                                  selected: screen_info_init[:comm])
      start_date = Time.strptime(screen_info_chng1[:sdate], '%m/%d/%Y %l:%M %p')
      mouse_select_datepicker('#started_at', start_date.day)
      mouse_select_timepicker('#started_at', start_date.strftime('%l:%M %p'))
      select screen_info_chng1[:comm], from: 'Communication Method'
      click_button 'Save'

      # Verify new info saved
      expect(page).to have_content('Screening Information')
      expect(page).to have_content(screen_info_init[:title])
      expect(page).to have_content('Assigned Social Worker')
      expect(page).to have_content(screen_info_chng1[:sdate])
      expect(page).to have_content(screen_info_init[:edate])
      expect(page).to have_content(screen_info_chng1[:comm])

      click_link 'Edit'
      # Validate info and make edits to the input fields
      expect(page).to have_field('Title/Name of Screening',
                                 with: screen_info_init[:title])
      expect(page).to have_field('Assigned Social Worker',
                                 disabled: true)
      # Need test for how date is displayed once date picker is complete
      expect(page).to have_select('Communication Method',
                                  selected: screen_info_chng1[:comm])
      fill_in_datepicker('Screening Start Date/Time', with: screen_info_chng2[:sdate])
      select screen_info_chng2[:comm], from: 'Communication Method'
    end
    click_button('Cancel', match: :first)

    # Verify new info is not saved and previous data is unchanged
    within '#screening-information-card' do
      expect(page).to have_content('Screening Information')
      expect(page).to have_content(screen_info_init[:title])
      expect(page).to have_content('Assigned Social Worker')
      expect(page).to have_content(screen_info_chng1[:sdate])
      expect(page).to have_content(screen_info_init[:edate])
      expect(page).to have_content(screen_info_chng1[:comm])
    end
  end
end
