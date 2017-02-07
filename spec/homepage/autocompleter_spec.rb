describe 'Looking for a Person using the searchbox on homepage', :type => :feature do
  it 'finds a result by first name' do
    visit '/'
    autocompleter_fill_in 'People', 'Houston'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Houston de Griff'
    end
  end

  it 'finds a result by last name' do
    visit '/'
    autocompleter_fill_in 'People', 'Griff'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Houston de Griff'
    end
  end

  it 'finds a result by DOB' do
    visit '/'
    autocompleter_fill_in 'People', '1905'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Boris Badboy'
    end
  end
end
