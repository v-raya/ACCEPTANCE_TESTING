# frozen_string_literal: true
require 'react_select_helpers'
person1 = {
  fname: 'VictimOne',
  mname: 'H',
  lname: 'victimLast',
  role: 'Victim',
  ssn: '111111111',
  gender: 'Male'
}
person2 = {
  fname: 'PerpOne',
  mname: 'M',
  lname: 'PerpLast',
  role: 'Perpetrator',
  ssn: '222222222',
  gender: 'Female'
}
person3 = {
  fname: 'ReporterOne',
  mname: 'Z',
  lname: 'ReportLast',
  role: 'Mandated Reporter',
  ssn: '333333333',
  gender: 'Other',
  address: {
    street_address: '333 Some Road',
    zip: '95618'
  }
}

describe 'save a zippy referral', type: :feature do
  describe 'on the happy path' do
    before do
      visit '/'
      login_user
      click_link 'Start Screening'
      [person1, person2, person3].each do |person|
        within '#search-card' do
          autocompleter_fill_in 'Search for any person', person[:fname]
          click_button 'Create a new person'
          sleep 0.5
        end
        person_card_id = find('div[id^="participants-card-"]', text: 'Unknown Person')[:id]
        within "##{person_card_id}" do
          find('input#first_name').click
          fill_in('First Name', with: person[:fname])
          fill_in('Middle Name', with: person[:mname])
          fill_in('Last Name', with: person[:lname])
          fill_in('Social security number', with: person[:ssn])
          fill_in_react_select 'Role', with: person[:role]
          fill_in_react_select 'Gender', with: person[:gender]
          if person[:role] == 'Mandated Reporter'
            within '.card-body' do
              click_button 'Add new address'
              fill_in 'Address', with: person[:address][:street_address]
              fill_in('City', with: 'San Jose')
              # find_field('City').send_keys(' ', :backspace) # workaround to send City as blank string instead of nil
              fill_in 'Zip', with: person[:address][:zip]
            end
          end
          click_button 'Save'
        end
      end
    end

    it 'validates the bare minimum fields' do
      within '#cross-report-card' do
        find('label', text: 'District attorney').click
        fill_in 'District_attorney-agency-name', with: 'Jan 1 $ully'
        fill_in_datepicker 'Cross Reported on Date', with: '08/17/2016'
        select 'Suspected Child Abuse Report', from: 'Communication Method'
        click_button 'Save'
      end

      within '#incident-information-card' do
        select 'Yolo', from: 'Incident County'
        fill_in_datepicker 'Incident Date', with: '08/23/1996'
        fill_in('Address', with: '123 Davis Street')
        fill_in('City', with: 'Sacramento')
        # find_field('City').send_keys(' ', :backspace) # workaround to send City as blank string instead of nil
        select 'Child\'s Home', from: 'Location Type'
        fill_in('Zip', with: '95831')
        click_button 'Save'
      end

      within '#screening-information-card' do
        fill_in('Title/Name of Screening', with: 'Test Screening')
        fill_in('Assigned Social Worker', with: 'Jim Bob')
        fill_in_datepicker('Screening Start Date/Time', with: '05/16/2017')
        select 'Fax', from: 'Communication Method'
        click_button 'Save'
      end

      within '#decision-card' do
        select 'Differential response', from: 'Decision'
        fill_in('Service name', with: 'Family Strengthening')
        click_button 'Save'
      end

      within '#allegations-card' do
        within('tbody') do
          table_rows = page.all('tr')
          expect(table_rows.count).to eq(1)
          within(table_rows[0]) do
            row0_id = find('input[id^="allegations_"]')[:id]
            fill_in_react_select(row0_id, with: ['Exploitation'])
          end
        end
        click_button 'Save'
      end

      within '#narrative-card' do
        fill_in 'Report Narrative',
                with: 'Fr1ends, Rom@ns, countrymen, 1end me your ears;'
        click_button 'Save'
      end

      click_button 'Submit'
      sleep(2)
      alert = page.driver.browser.switch_to.alert
      expect(alert).to be_a(Selenium::WebDriver::Alert)
      expect(alert.text).to include('Successfully created referral')
      returned_id = alert.text.split(' ').last
      expect(returned_id).to match(/[a-zA-Z0-9]{10}/)
      expect(returned_id.length).to equal(10)
    end
  end
end
