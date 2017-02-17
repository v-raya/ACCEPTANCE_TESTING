describe 'Homepage Autocompleter', type: :feature do
  it 'log on to Login page' do
    visit '/'
    username_input = page.find('input[name=username]')
    username_input.send_keys 'guest'
    password_input = page.find('input[name=password]')
    password_input.send_keys 'guest'
    click_button('Login')
    # search bar appears by checking for the label "People"
    expect(page).to have_content 'People'
  end

  it 'finds a result by first name' do
    visit '/'
    username_input = page.find('input[name=username]')
    username_input.send_keys 'guest'
    password_input = page.find('input[name=password]')
    password_input.send_keys 'guest'
    click_button('Login')
    autocompleter_fill_in 'People', 'Houston'
    within '.react-autosuggest__suggestions-list' do
          expect(page).to have_content 'Houston de Griff'
    end
  end

  it 'finds a result by last name' do
    visit '/'
    username_input = page.find('input[name=username]')
    username_input.send_keys 'guest'
    password_input = page.find('input[name=password]')
    password_input.send_keys 'guest'
    click_button('Login')
    autocompleter_fill_in 'People', 'Griff'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Houston de Griff'
    end
  end

  # validating that searching on "Pete" would return "Peter" records as well.
  it 'finds a result by DOB' do
    visit '/'
    username_input = page.find('input[name=username]')
    username_input.send_keys 'guest'
    password_input = page.find('input[name=password]')
    password_input.send_keys 'guest'
    click_button('Login')
    autocompleter_fill_in 'People', '1905'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Boris Badboy'
    end
  end

  # validating that searching on "Pete" would return "Peter" records as well.
  it 'Partial Name Search on Pete - Part I' do
    visit '/'
    username_input = page.find('input[name=username]')
    username_input.send_keys 'guest'
    password_input = page.find('input[name=password]')
    password_input.send_keys 'guest'
    click_button('Login')
    autocompleter_fill_in 'People', 'Pete'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Pete'
    end
  end

  it 'Partial Name Search on Pete - Part II' do
    visit '/'
    username_input = page.find('input[name=username]')
    username_input.send_keys 'guest'
    password_input = page.find('input[name=password]')
    password_input.send_keys 'guest'
    click_button('Login')
    autocompleter_fill_in 'People', 'Pete'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Peter'
    end
  end

  # validating that searching on partial year would return record with 199X year
  it 'Partial Search on DOB' do
    visit '/'
    username_input = page.find('input[name=username]')
    username_input.send_keys 'guest'
    password_input = page.find('input[name=password]')
    password_input.send_keys 'guest'
    click_button('Login')
    autocompleter_fill_in 'People', '199'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content '199'
    end
  end

  # validating that searching on single char Mon Day would return record with '3/3/'
  it 'checking partial date M/D/' do
    visit '/'
      username_input = page.find('input[name=username]')
      username_input.send_keys 'guest'
      password_input = page.find('input[name=password]')
      password_input.send_keys 'guest'
      click_button('Login')
      autocompleter_fill_in 'People', '3/3/'
      within '.react-autosuggest__suggestions-list' do
        expect(page).to have_content '3/3/'
      end
    end
  end
