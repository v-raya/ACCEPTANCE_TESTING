describe 'Looking for a Person using the searchbox on homepage', :type => :feature do
  it 'finds a result by first name' do
    visit '/'
    fill_in 'People', with: 'Bob'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Bob Lowe'
    end
  end

  it 'finds a result by last name' do
    visit '/'
    fill_in 'People', with: 'Lowe'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Bob Lowe'
    end
  end

  it 'finds a result by DOB' do
    visit '/'
    fill_in 'People', with: '11/23/1988'
    within '.react-autosuggest__suggestions-list' do
      expect(page).to have_content 'Bob Lowe'
    end
  end
end
