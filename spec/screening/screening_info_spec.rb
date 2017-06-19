# frozen_string_literal: true

describe 'Screening QA Test', type: :feature do
  # Selecting Start Screening from homepage
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  screen_info_init = {
    title: 'Child @bandonment1',
    worker: 'Jane $ocialworker',
    comm: 'Mail',
    sdate: '08/13/2016 11:00 AM',
    edate: '08/15/2016 7:00 PM'
  }

  screen_info_chng1 = {
    worker: 'John Socialworker',
    comm: 'Fax',
    sdate: '08/12/2016 1:00 PM'
  }

  screen_info_chng2 = {
    worker: 'Helen Socialworker',
    sdate: '08/22/2016 3:00 PM',
    comm: 'Online'
  }

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
                                   with: '')
        expect(page).to have_field('Screening Start Date/Time',
                                   with: '')
        expect(page).to have_field('Screening End Date/Time',
                                   with: '')
        expect(page).to have_select('Communication Method', selected: '')
        expect(page).to have_button('Save')
        expect(page).to have_button('Cancel')
        fill_in('Title/Name of Screening', with: screen_info_init[:title])
        fill_in('Assigned Social Worker', with: screen_info_init[:worker])
        fill_in_datepicker('Screening Start Date/Time', with: screen_info_init[:sdate])
        fill_in_datepicker('Screening End Date/Time', with: screen_info_init[:edate])
        select screen_info_init[:comm], from: 'Communication Method'
        click_button 'Save'
      end
      expect(page).to have_content('Screening Information')
      expect(page).to have_content(screen_info_init[:title])
      expect(page).to have_content(screen_info_init[:worker])
      expect(page).to have_content(screen_info_init[:sdate])
      expect(page).to have_content(screen_info_init[:edate])
      expect(page).to have_content(screen_info_init[:comm])

      click_link 'Edit'
      # Validate info and make edits to the input fields
      expect(page).to have_field('Title/Name of Screening',
                                 with: screen_info_init[:title])
      expect(page).to have_field('Assigned Social Worker',
                                 with: screen_info_init[:worker])
      # Need test for how date is displayed once date picker is complete
      expect(page).to have_select('Communication Method',
                                  selected: screen_info_init[:comm])
      fill_in('Assigned Social Worker', with: screen_info_chng1[:worker])
      mouse_select_datepicker('#started_at', 12) # Date.parse(screen_info_chng1[:sdate]).day = 12
      mouse_select_timepicker('#started_at', '3:30 PM')
      select screen_info_chng1[:comm], from: 'Communication Method'
      click_button 'Save'

      # Verify new info saved
      expect(page).to have_content('Screening Information')
      expect(page).to have_content(screen_info_init[:title])
      expect(page).to have_content(screen_info_chng1[:worker])
      expect(page).to have_content("#{screen_info_chng1[:sdate]} 3:30 PM")
      expect(page).to have_content(screen_info_init[:edate])
      expect(page).to have_content(screen_info_chng1[:comm])

      click_link 'Edit'
      # Validate info and make edits to the input fields
      expect(page).to have_field('Title/Name of Screening',
                                 with: screen_info_init[:title])
      expect(page).to have_field('Assigned Social Worker',
                                 with: screen_info_chng1[:worker])
      # Need test for how date is displayed once date picker is complete
      expect(page).to have_select('Communication Method',
                                  selected: screen_info_chng1[:comm])
      fill_in('Assigned Social Worker', with: screen_info_chng2[:worker])
      fill_in_datepicker('Screening Start Date/Time', with: screen_info_chng2[:sdate])
      select screen_info_chng2[:comm], from: 'Communication Method'
    end
    click_button('Cancel', match: :first)

    # Verify new info is not saved and previous data is unchanged
    within '#screening-information-card' do
      expect(page).to have_content('Screening Information')
      expect(page).to have_content(screen_info_init[:title])
      expect(page).to have_content(screen_info_chng1[:worker])
      expect(page).to have_content(screen_info_chng1[:sdate])
      expect(page).to have_content(screen_info_init[:edate])
      expect(page).to have_content(screen_info_chng1[:comm])
    end
  end
end
