# frozen_string_literal: true

person1 = {
  fname: 'VICONE',
  lname: 'ONE',
  role: 'Victim'
}
person2 = {
  fname: 'VICTWO',
  lname: 'TWO',
  role: 'Perpetrator'
}

describe 'Validate Screening require field labels', type: :feature do
  # Selecting Create Person on homepage
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  it 'validate Screening Info required labels' do
    within '#screening-information-card' do
      expect(page.find('label', text: 'Screening Start Date/Time')[:class]).to include('required')
      expect(page.find('label', text: 'Assigned Social Worker')[:class]).to include('required')
      expect(page.find('label', text: 'Communication Method')[:class]).to include('required')
      click_button 'Save'
      expect(page.find('label', text: 'Screening Start Date/Time')[:class]).to include('required')
      expect(page.find('label', text: 'Assigned Social Worker')[:class]).to include('required')
      expect(page.find('label', text: 'Communication Method')[:class]).to include('required')
    end
  end

  it 'validate narrative card required labels' do
    within '#narrative-card' do
      expect(page.find('label', text: 'Report Narrative')[:class]).to include('required')
      click_button 'Save'
    end
  end

  it 'validate Cross Report required labels' do
    within '#cross-report-card' do
      # Verify required field label are present for each and then all checkboxes
      first('label', text: 'District attorney').click
      expect(page.find('label', text: 'Cross Reported on Date')[:class]).to include('required')
      expect(page.find('label', text: 'Communication Method')[:class]).to include('required')
      expect(page.find('label', text: 'District attorney agency name')[:class]).to include('required')
      first('label', text: 'District attorney').click
      first('label', text: 'Department of justice').click
      expect(page.find('label', text: 'Cross Reported on Date')[:class]).to include('required')
      expect(page.find('label', text: 'Communication Method')[:class]).to include('required')
      expect(page.find('label', text: 'Department of justice agency name')[:class]).to include('required')
      first('label', text: 'Department of justice').click
      first('label', text: 'Law enforcement').click
      expect(page.find('label', text: 'Cross Reported on Date')[:class]).to include('required')
      expect(page.find('label', text: 'Communication Method')[:class]).to include('required')
      expect(page.find('label', text: 'Law enforcement agency name')[:class]).to include('required')
      first('label', text: 'Law enforcement').click
      first('label', text: 'Licensing').click
      expect(page.find('label', text: 'Cross Reported on Date')[:class]).to include('required')
      expect(page.find('label', text: 'Communication Method')[:class]).to include('required')
      expect(page.find('label', text: 'Licensing agency name')[:class]).to include('required')
      first('label', text: 'District attorney').click
      first('label', text: 'Department of justice').click
      first('label', text: 'Law enforcement').click
      expect(page.find('label', text: 'District attorney agency name')[:class]).to include('required')
      expect(page.find('label', text: 'Department of justice agency name')[:class]).to include('required')
      expect(page.find('label', text: 'Licensing agency name')[:class]).to include('required')
      expect(page.find('label', text: 'Law enforcement agency name')[:class]).to include('required')
      expect(page.find('label', text: 'Cross Reported on Date')[:class]).to include('required')
      expect(page.find('label', text: 'Communication Method')[:class]).to include('required')
      click_button 'Save'
      expect(page.find('label', text: 'Cross Reported on Date')[:class]).to include('required')
      expect(page.find('label', text: 'Communication Method')[:class]).to include('required')
    end
  end

  it 'validate interdependencies of cross report with allegations' do
    # create and fill-in victim and perpetrator
    within '#search-card' do
      autocompleter_fill_in 'Search for any person', 'Tete'
      click_button 'Create a new person'
      sleep 0.3
    end
    person1_id = find('div[id^="participants-card-"]', text: 'Unknown')[:id]
    person1_card = find('#' + person1_id)
    within person1_card do
      find('input#first_name').click
      fill_in('First Name', with: person1[:fname])
      fill_in('Last Name', with: person1[:lname])
      fill_in_react_select 'Role', with: person1[:role]
      click_button 'Save'
    end

    within '#search-card' do
      autocompleter_fill_in 'Search for any person', 'Tete'
      click_button 'Create a new person'
      sleep 0.3
    end
    person2_id = find('div[id^="participants-card-"]', text: 'Unknown')[:id]
    person2_card = find('#' + person2_id)
    within person2_card do
      find('input#first_name').click
      fill_in('First Name', with: person2[:fname])
      fill_in('Last Name', with: person2[:lname])
      fill_in_react_select 'Role', with: person2[:role]
      click_button 'Save'
    end

    [
      'Severe neglect',
      'Exploitation',
      'At risk, sibling abused',
      'Emotional abuse',
      'Sexual abuse',
      'Physical abuse'
    ].each do |allegation|
      within '#allegations-card' do
        within('tbody') do
          table_rows = page.all('tr')

          # fill-in allegations card values
          within(table_rows[0]) do
            row0_id = find('input[id^="allegations_"]')[:id]
            find_field(row0_id).send_keys(:backspace)
            fill_in_react_select(row0_id, with: (allegation).to_s)
          end
        end
      end
      within '#cross-report-card' do
        # Verify required field label are present for appropriate checkboxes
        expect(page.find('label', text: 'Law enforcement')[:class]).to include('required')
        expect(page.find('label', text: 'District attorney')[:class]).to include('required')
      end
    end

    [
      'General neglect',
      'Caretaker absent/incapacity'
    ].each do |allegation|
      within '#allegations-card' do
        within('tbody') do
          table_rows = page.all('tr')

          # fill-in allegations card values
          within(table_rows[0]) do
            row0_id = find('input[id^="allegations_"]')[:id]
            find_field(row0_id).send_keys(:backspace)
            fill_in_react_select(row0_id, with: (allegation).to_s)
          end
        end
      end
      within '#cross-report-card' do
        # Verify required field label are present for appropriate checkboxes
        expect(page.find('label', text: 'Law enforcement')[:class]).not_to include('required')
        expect(page.find('label', text: 'District attorney')[:class]).not_to include('required')
      end
    end
  end

  it 'validate decision card required labels' do
    within '#decision-card' do
      expect(page.find('label', text: 'Screening Decision')[:class]).to include('required')
      select 'Promote to referral', from: 'Decision'
      expect(page.find('label', text: 'Response time')[:class]).to include('required')
      click_button 'Save'
      expect(page.find('label', text: 'Screening Decision')[:class]).to include('required')
      expect(page.find('label', text: 'Response time')[:class]).to include('required')
    end
  end
end
