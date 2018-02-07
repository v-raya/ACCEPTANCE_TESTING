# frozen_string_literal: true

describe 'Snapshot. Person search with no results', type: :feature do
  before do
    ScreeningPage.new.visit
  end

  it 'log on to Login page' do
    expect(page).to have_content 'Search'
  end

  it 'validate no search results' do
    autocompleter_fill_in 'screening_participants', '123qwerzzbnnmsjjdk'
    within('#search-card')  do
      expect(page).to have_content 'No results were found for "123qwerzzbnnmsjjdk"'
      expect(page).to have_no_content 'CREATE A NEW PERSON'
    end
  end
end
