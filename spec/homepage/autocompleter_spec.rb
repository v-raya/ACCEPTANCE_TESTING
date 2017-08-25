# frozen_string_literal: true

describe 'Homepage Autocompleter', type: :feature do
  # Perform log in prior to all tests
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  # Checks to ensure login is successful
  it 'log on to Login page' do
    expect(page).to have_content 'Search'
  end

  # validate specific person is in suggestion list when searched by last name
  it 'find a result by a specific first name' do
    autocompleter_fill_in 'screening_participants', 'Houston'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Houston d.'
    end
  end

  # validate specific person is in suggestion list when searched by last name
  it 'find a result by a specific last name' do
    autocompleter_fill_in 'screening_participants', 'Griffin'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Griffin Albert Flatley'
    end
  end

  # validate specific person is in suggestion list when searched by DOB
  it 'finds a result by DOB' do
    autocompleter_fill_in 'screening_participants', '1905'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Boris B.'
    end
  end

  # validate that searching on "Pete" would return "Pete" records
  it 'Validating all records contain partial search criteria - Pt 1' do
    autocompleter_fill_in 'screening_participants', 'Pete'
    page.all(:xpath, "//li[@class='react-autosuggest__suggestion' and
      not(position() = last())]").each do |element|
      expect(element.text).to have_content('Pete')
    end
  end

  # validate that searching on "Pete" would return "Peter" records as well.
  it 'Validating all records contain partial search criteria - Pt 2' do
    autocompleter_fill_in 'screening_participants', 'Pete'
    within '#search-card' do
        expect(page).to have_content('Peter')
    end
  end

  # Validating all records for 9-digit SSN is being returned
  it 'Validating all SSN records returned' do
    autocompleter_fill_in 'screening_participants', '123456789'
    page.all(:xpath, "//li[@class='react-autosuggest__suggestion' and
      not(position() = last())]").each do |element|
        expect(element.text).to have_content('6789')
    end
  end

  # validate every record on the suggestion list contains the search
  # criteria whole year'
  it 'Validating only DOB search data is returned' do
    autocompleter_fill_in 'screening_participants', '1999'
    page.all(:xpath, "//li[@class='react-autosuggest__suggestion' and
      not(position() = last())]").each do |element|
        expect(element.text).to have_content('1999')
    end
  end

  # validate every record on the suggestion list contains the search
  # criteria partial year'
  it 'Validating only DOB search data is returned' do
    # visit '/'
    autocompleter_fill_in 'screening_participants', '199'
    page.all(:xpath, "//li[@class='react-autosuggest__suggestion' and
      not(position() = last())]").each do |element|
        expect(element.text).to have_content('199')
    end
  end

  # validate every record on the suggestion list contains the partial search
  # criteria using no leading zeroes DOB'
  it 'Validating only DOB search data is returned - Pt 1' do
    pending ('pending bug fix related to searching on birthday')
    autocompleter_fill_in 'screening_participants', '3/3/'
    page.all(:xpath, "//li[@class='react-autosuggest__suggestion' and
      not(position() = last())]").each do |element|
        expect(element.text).to have_content('3/3/')
    end
  end

  # validate every record on the suggestion list contains the partial search
  # criteria using leading zeroes DOB'
  it 'Validating only DOB search data is returned - Pt 2' do
    pending ('pending bug fix related to searching on birthday')
    autocompleter_fill_in 'screening_participants', '03/03/'
    page.all(:xpath, "//li[@class='react-autosuggest__suggestion' and
      not(position() = last())]").each do |element|
        expect(element.text).to have_content('3/3/')
    end
  end

  # validate every record on the suggestion list contains the search criteria
  # using leading zeroes entire DOB'
  it 'Validating only DOB search data is returned - Pt 3' do
    pending ('pending bug fix related to searching on birthday')
    autocompleter_fill_in 'screening_participants', '03/03/1990'
    page.all(:xpath, "//li[@class='react-autosuggest__suggestion' and
      not(position() = last())]").each do |element|
        expect(element.text).to have_content('3/3/1990')
    end
  end
end
