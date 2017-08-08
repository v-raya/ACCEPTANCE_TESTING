# frozen_string_literal: true

describe 'Field limits', type: :feature do
  # Selecting Create Person on homepage
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  it 'tests field limits for screening' do
    sixty_five_characters = (0..64).map { 's' }.join('')
    twenty_digits = (0..19).map { '1' }.join('')
    fourteen_digits = (0..13).map { '1' }.join('')
    one_hundred_and_twenty_nine_chars = (0..128).map { 'A' }.join('')
    eleven_digits = (0..10).map { '1' }.join('')

    fill_in 'Title/Name of Screening', with: sixty_five_characters
    expect(find_field('Title/Name of Screening').value.length).to eq(64)

    fill_in 'Assigned Social Worker', with: sixty_five_characters
    expect(find_field('Assigned Social Worker').value.length).to eq(64)

    fill_in_datepicker 'Screening Start Date/Time', with: twenty_digits
    expect(find_field('Screening Start Date/Time').value.length).to eq(19)

    fill_in_datepicker 'Screening End Date/Time', with: twenty_digits
    expect(find_field('Screening End Date/Time').value.length).to eq(19)

    within '#search-card', text: 'Search' do
      autocompleter_fill_in 'Search for any person', twenty_digits
      click_button 'Create a new person'
    end

    within "##{page.find("div[id^='participants-card']")[:id]}" do
      fill_in 'First Name', with: sixty_five_characters
      expect(find_field('First Name').value.length).to eq(64)

      fill_in 'Middle Name', with: sixty_five_characters
      expect(find_field('Middle Name').value.length).to eq(64)

      fill_in 'Last Name', with: sixty_five_characters
      expect(find_field('Last Name').value.length).to eq(64)

      fill_in_datepicker 'Date of birth', with: eleven_digits
      expect(find_field('Date of birth').value.length).to eq(10)

      click_button 'Add new phone number'
      fill_in 'Phone Number', with: fourteen_digits
      expect(find_field('Phone Number').value.length).to eq(13)

      click_button 'Add new address'
      fill_in 'Address', with: one_hundred_and_twenty_nine_chars
      expect(find_field('Address').value.length).to eq(128)

      fill_in 'City', with: sixty_five_characters
      expect(find_field('City').value.length).to eq(64)

      fill_in 'Zip', with: eleven_digits
      expect(find_field('Zip').value.length).to eq(10)
    end

    within '#incident-information-card.edit' do
      fill_in_datepicker 'Incident Date', with: eleven_digits
      expect(find_field('Incident Date').value.length).to eq(10)

      fill_in 'Address', with: one_hundred_and_twenty_nine_chars
      expect(find_field('Address').value.length).to eq(128)

      fill_in 'City', with: sixty_five_characters
      expect(find_field('City').value.length).to eq(64)

      fill_in 'Zip', with: eleven_digits
      expect(find_field('Zip').value.length).to eq(10)
    end

    within '#cross-report-card.edit' do
      find('label', text: 'District attorney').click
      fill_in 'District attorney agency name', with: one_hundred_and_twenty_nine_chars
      expect(find_field('District attorney agency name').value.length).to eq(128)

      find('label', text: 'Department of justice').click
      fill_in 'Department of justice agency name', with: one_hundred_and_twenty_nine_chars
      expect(find_field('Department of justice agency name').value.length).to eq(128)

      find('label', text: 'Law enforcement').click
      fill_in 'Law enforcement agency name', with: one_hundred_and_twenty_nine_chars
      expect(find_field('Law enforcement agency name').value.length).to eq(128)

      find('label', text: 'Licensing').click
      fill_in 'Licensing agency name', with: one_hundred_and_twenty_nine_chars
      expect(find_field('Licensing agency name').value.length).to eq(128)

      fill_in_datepicker 'Cross Reported on Date', with: eleven_digits
      expect(find_field('Cross Reported on Date').value.length).to eq(10)
    end
  end
end
