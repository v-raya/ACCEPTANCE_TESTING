# frozen_string_literal: true
describe 'Homepage Autocompleter', type: :feature do
  # Perform log in prior to all tests
  before do
    visit '/'
    username_input = page.find('input[name=username]')
    username_input.send_keys 'guest'
    password_input = page.find('input[name=password]')
    password_input.send_keys 'guest'
    click_button('Login')
  end

  # Checks to ensure login is successful
  it 'log on to Login page' do
    visit '/'
    expect(page).to have_content 'People'
  end

  # validate specific person is in suggestion list when searched by last name
  it 'find a result by a specific first name' do
    visit '/'
    autocompleter_fill_in 'People', 'Houston'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Houston de Griff'
    end
  end

  # validate specific person is in suggestion list when searched by last name
  it 'find a result by a specific last name' do
    visit '/'
    autocompleter_fill_in 'People', 'Griff'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Houston de Griff'
    end
  end

  # validate specific person is in suggestion list when searched by DOB
  it 'finds a result by DOB' do
    visit '/'
    autocompleter_fill_in 'People', '1905'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Boris Badboy'
    end
  end

  # validate that searching on "Pete" would return "Pete" records
  it 'Validating all records contain partial search criteria - Pt 1' do
    visit '/'
    autocompleter_fill_in 'People', 'Pete'
    within('ul.react-autosuggest__suggestions-list') do
      page.all('li').each do |element|
        expect(element.text).to have_content('Pete')
      end
    end
  end

  # validate that searching on "Pete" would return "Peter" records as well.
  it 'Validating all records contain partial search criteria - Pt 2' do
    visit '/'
    autocompleter_fill_in 'People', 'Pete'
    within('ul.react-autosuggest__suggestions-list') do
      page.all('li').each do |element|
        expect(element.text).to have_content('Peter')
      end
    end
  end

  # Validating all records for 9-digit SSN is being returned
  it 'Validating all SSN records returned' do
    visit '/'
    autocompleter_fill_in 'People', '123456789'
    within('ul.react-autosuggest__suggestions-list') do
      page.all('li').each do |element|
        expect(element.text).to have_content('6789')
      end
    end
  end

  # validate every record on the suggestion list contains the search
  # criteria whole year'
  it 'Validating only DOB search data is returned' do
    visit '/'
    autocompleter_fill_in 'People', '1999'
    within('ul.react-autosuggest__suggestions-list') do
      page.all('li').each do |element|
        expect(element.text).to have_content('1999')
      end
    end
  end

  # validate every record on the suggestion list contains the search
  # criteria partial year'
  it 'Validating only DOB search data is returned' do
    visit '/'
    autocompleter_fill_in 'People', '199'
    within('ul.react-autosuggest__suggestions-list') do
      page.all('li').each do |element|
        expect(element.text).to have_content('199')
      end
    end
  end

  # validate every record on the suggestion list contains the partial search
  # criteria using no leading zeroes DOB'
  it 'Validating only DOB search data is returned - Pt 1' do
    visit '/'
    autocompleter_fill_in 'People', '3/3/'
    within('ul.react-autosuggest__suggestions-list') do
      page.all('li').each do |element|
        expect(element.text).to have_content('3/3/')
      end
    end
  end

  # validate every record on the suggestion list contains the partial search
  # criteria using leading zeroes DOB'
  it 'Validating only DOB search data is returned - Pt 2' do
    visit '/'
    autocompleter_fill_in 'People', '03/03/'
    within('ul.react-autosuggest__suggestions-list') do
      page.all('li').each do |element|
        expect(element.text).to have_content('3/3/')
      end
    end
  end

  # validate every record on the suggestion list contains the search criteria
  # using leading zeroes entire DOB'
  it 'Validating only DOB search data is returned - Pt 3' do
    visit '/'
    autocompleter_fill_in 'People', '03/03/1990'
    within('ul.react-autosuggest__suggestions-list') do
      page.all('li').each do |element|
        expect(element.text).to have_content('3/3/1990')
      end
    end
  end
end
