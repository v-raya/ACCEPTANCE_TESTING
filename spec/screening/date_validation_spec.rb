# frozen_string_literal: true

describe 'Validate date (date picker) on screening cards', type: :feature do
  # Selecting Create Person on homepage
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  it 'Validate date and time on screening information card' do
    [
      { sdate_time: '01012011 11:23 AM', s_display: '01/01/2011 11:23 AM', edate_time: '01022011 11:23 AM',
        e_display: '01/02/2011 11:23 AM' },
      { sdate_time: '010120112 13:23 AM', s_display: '01/01/2011 1:23 PM', edate_time: '010220112 13:23 AM',
        e_display: '01/02/2011 1:23 PM' },
      { sdate_time: '010111 23:23', s_display: '01/01/2011 11:23 PM', edate_time: '010211 23:23',
        e_display: '01/02/2011 11:23 PM' },
      { sdate_time: '1/1/11 1323', s_display: '01/01/2011 1:23 PM', edate_time: '1/2/11 1323',
        e_display: '01/02/2011 1:23 PM' },
      { sdate_time: '01/01/11 11:23 PM', s_display: '01/01/2011 11:23 PM', edate_time: '01/02/11 11:23 PM',
        e_display: '01/02/2011 11:23 PM' },
      { sdate_time: '01/01/111 0000', s_display: '01/01/0111 12:00 AM', edate_time: '01/02/111 0000',
        e_display: '01/02/0111 12:00 AM' },
      { sdate_time: '01/01/2011 11:23 AM', s_display: '01/01/2011 11:23 AM', edate_time: '01/02/2011 11:23 AM',
        e_display: '01/02/2011 11:23 AM' },
      { sdate_time: '01/01/20112 113 AM', s_display: '01/01/2011 11:03 AM', edate_time: '01/02/20112 113 AM',
        e_display: '01/02/2011 11:03 AM' },
      { sdate_time: '13/21/2011 13:23 PM', s_display: '', edate_time: '13/22/2011 13:23 PM', e_display: '' },
      { sdate_time: '01/32/2011 11:23 AM', s_display: '', edate_time: '01/33/2011 11:23 AM', e_display: '' },
      { sdate_time: '', s_display: '', edate_time: '', e_display: '' }
    ].each do |screening_dates|
      # check date on screening card
      within '#screening-information-card' do
        fill_in_datepicker 'Screening Start Date/Time', with: screening_dates[:sdate_time]
        expect(page).to have_field('Screening Start Date/Time', with: screening_dates[:s_display])
        fill_in_datepicker 'Screening End Date/Time', with: screening_dates[:edate_time]
        expect(page).to have_field('Screening End Date/Time', with: screening_dates[:e_display])
        click_button 'Save'
      end
      within '#screening-information-card' do
        expect(page).to have_content(screening_dates[:s_display])
        expect(page).to have_content(screening_dates[:e_display])
        click_link 'Edit'
      end
    end
  end

  it 'validate picking a date and time from date and time picker' do
    # test for clicking on the calendar and time picker
    within '#screening-information-card' do
      fill_in_datepicker 'Screening Start Date/Time', with: '08/17/2016 3:00 AM'
      mouse_select_datepicker('#started_at', 23)
      mouse_select_timepicker('#started_at', '1:00 AM')
      find_field('Title/Name of Screening').click
      expect(page).to have_field('Screening Start Date/Time', with: '08/23/2016 1:00 AM')
      fill_in_datepicker 'Screening End Date/Time', with: '08/17/2016 4:00 AM'
      mouse_select_datepicker('#ended_at', 23)
      mouse_select_timepicker('#ended_at', '2:00 AM')
      find_field('Title/Name of Screening').click
      expect(page).to have_field('Screening End Date/Time', with: '08/23/2016 2:00 AM')
    end
    within '#incident-information-card.edit' do
      fill_in_datepicker 'Incident Date', with: '08/17/2015'
      mouse_select_datepicker('#incident_date', 23)
      find_field('City').click
      expect(page).to have_field('Incident Date', with: '08/23/2015')
      click_button 'Save'
    end
    within '#incident-information-card.show' do
      expect(page).to have_content('08/23/2015')
    end
    within '#cross-report-card.edit' do
      find('label', text: 'District attorney').click
      fill_in_datepicker 'Cross Reported on Date', with: '08/17/2016'
      mouse_select_datepicker('#cross_report_reported_on', 23)
      find_field('District attorney agency name').click
      expect(page).to have_field('Cross Reported on Date', with: '08/23/2016')
      click_button 'Save'
    end
    within '#cross-report-card.show' do
      expect(page).to have_content('08/23/2016')
    end
  end

  it 'Test date field on participant, incident, cross report cards' do
    within '#search-card', text: 'Search' do
      autocompleter_fill_in 'Search for any person', 'zz'
      click_button 'Create a new person'
      sleep 0.5
    end
    person1_id = find('div[id^="participants-card-"]', text: 'Unknown')[:id]
    person1_card = find('#' + person1_id)
    within '#cross-report-card' do
      find('label', text: 'District attorney').click
    end
    [
      { date: '01012011', display: '01/01/2011' },
      { date: '010120112', display: '01/01/2011' },
      { date: '010111', display: '01/01/2011' },
      { date: '1/1/11', display: '01/01/2011' },
      { date: '01/01/11', display: '01/01/2011' },
      { date: '01/01/111', display: '01/01/0111' },
      { date: '01/01/2011', display: '01/01/2011' },
      { date: '01/01/20112', display: '01/01/2011' },
      { date: '13/21/2011', display: '' },
      { date: '01/32/2011', display: '' },
      { date: '', display: '' }
    ].each do |date_test|
      within person1_card do
        fill_in_datepicker 'Date of birth', with: date_test[:date]
        expect(page).to have_field('Date of birth', with: date_test[:display])
        click_button 'Save'
      end
      within person1_card do
        expect(page).to have_content(date_test[:display])
        click_link 'Edit'
      end

      # check date on incident card
      within '#incident-information-card' do
        fill_in_datepicker 'Incident Date', with: date_test[:date]
        expect(page).to have_field('Incident Date', with: date_test[:display])
        click_button 'Save'
      end
      within '#incident-information-card' do
        expect(page).to have_content(date_test[:display])
        click_link 'Edit'
      end

      # check date on Cross Report card
      within '#cross-report-card' do
        fill_in_datepicker 'Cross Reported on Date', with: date_test[:date]
        expect(page).to have_field('Cross Reported on Date', with: date_test[:display])
        click_button 'Save'
      end
      within '#cross-report-card' do
        expect(page).to have_content(date_test[:display])
        click_link 'Edit'
      end
    end
  end
end
