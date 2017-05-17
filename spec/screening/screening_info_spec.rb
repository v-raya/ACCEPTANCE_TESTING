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
    sdate: '08/13/2016',
    edate: '08/15/2016'
  }

  screen_info_chng1 = {
    worker: 'John Socialworker',
    comm: 'Fax',
    sdate: '08/12/2016'
  }

  screen_info_chng2 = {
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
        fill_in('Title/Name of Screening', with: screen_info_init[:title])
        fill_in('Assigned Social Worker', with: screen_info_init[:worker])
        fill_in('Screening Start Date/Time', with: screen_info_init[:sdate])
        fill_in('Screening End Date/Time', with: screen_info_init[:edate])
        select screen_info_init[:comm], from: 'Communication Method'
        click_button 'Save'
      end
      expect(page).to have_content('SCREENING INFORMATION')
      expect(page).to have_content(screen_info_init[:title])
      expect(page).to have_content(screen_info_init[:worker])
      expect(page).to have_content(screen_info_init[:sdate])
      expect(page).to have_content(screen_info_init[:edate])
      expect(page).to have_content(screen_info_init[:comm])

      # click on the pencil icon in header to invoke the edit page
      find(:css, 'i.fa.fa-pencil').click
      # Validate info and make edits to the input fields
      expect(page).to have_field('Title/Name of Screening',
                                 with: screen_info_init[:title])
      expect(page).to have_field('Assigned Social Worker',
                                 with: screen_info_init[:worker])
      # Need test for how date is displayed once date picker is complete
      expect(page).to have_select('Communication Method',
                                  selected: screen_info_init[:comm])
      fill_in('Assigned Social Worker', with: screen_info_chng1[:worker])
      fill_in('Screening Start Date/Time', with: screen_info_chng1[:sdate])
      select screen_info_chng1[:comm], from: 'Communication Method'
      click_button 'Save'

      # Verify new info saved
      expect(page).to have_content('SCREENING INFORMATION')
      expect(page).to have_content(screen_info_init[:title])
      expect(page).to have_content(screen_info_chng1[:worker])
      expect(page).to have_content(screen_info_chng1[:sdate])
      expect(page).to have_content(screen_info_init[:edate])
      expect(page).to have_content(screen_info_chng1[:comm])

      # click on the pencil icon in header to invoke the edit page
      find(:css, 'i.fa.fa-pencil').click
      # Validate info and make edits to the input fields
      expect(page).to have_field('Title/Name of Screening',
                                 with: screen_info_init[:title])
      expect(page).to have_field('Assigned Social Worker',
                                 with: screen_info_chng1[:worker])
      # Need test for how date is displayed once date picker is complete
      expect(page).to have_select('Communication Method',
                                  selected: screen_info_chng1[:comm])
      fill_in('Assigned Social Worker', with: screen_info_chng2[:worker])
      fill_in('Screening Start Date/Time', with: screen_info_chng2[:sdate])
      select screen_info_chng2[:comm], from: 'Communication Method'
    end
    click_button('Cancel', match: :first)

    # Verify new info is not saved and previous data is unchanged
    within '#screening-information-card' do
      expect(page).to have_content('SCREENING INFORMATION')
      expect(page).to have_content(screen_info_init[:title])
      expect(page).to have_content(screen_info_chng1[:worker])
      expect(page).to have_content(screen_info_chng1[:sdate])
      expect(page).to have_content(screen_info_init[:edate])
      expect(page).to have_content(screen_info_chng1[:comm])
    end
  end
end
