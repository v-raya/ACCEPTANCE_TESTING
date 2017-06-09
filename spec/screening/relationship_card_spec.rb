# frozen_string_literal: true

person1 = {
  fname: 'Marty',
  lname: 'R.'
}
person2 = {
  fname: 'Ricky',
  lname: 'W.'
}

describe 'Relationship card QA test', type: :feature do
  # Selecting Start Screening from homepage
  # Note - This script is dependent on established seed data in the environment

  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  it 'Test initial rendering of card' do
    within '#relationships-card' do
      # Verify initial rendering of card
      expect(page).to have_content('Relationships')
      expect(page).to have_content('Add people to see their relationships here.')
    end
    # Adding an existing child to a screening
    within '#search-card', text: 'Search' do
      autocompleter_fill_in 'Search for any person', person1[:fname]
      find('li', text: "#{person1[:fname]} #{person1[:lname]}").click
    end

    within '#relationships-card' do
      # Verify rendering of card
      expect(page).to have_content("#{person1[:fname]} #{person1[:lname]} is the...")
      expect(page).to have_content('Son  of Missy R.')
      expect(page).to have_content('Son of Ricky W.')
      expect(page).to have_content('Brother of Roland W.')
      expect(page).to have_content('Brother  of Sharon W.')
    end

    # Adding an existing adult that is related to an existing child on a screening
    within '#search-card', text: 'Search' do
      autocompleter_fill_in 'Search for any person', person2[:fname]
      find('li', text: "#{person2[:fname]} #{person2[:lname]}").click
    end
    person2_id = find('div[id^="participants-card-"]', text: person2[:fname])[:id]
    person2_card = find('#' + person2_id)

    within '#relationships-card' do
      # Verify rendering of card
      expect(page).to have_content("#{person1[:fname]} #{person1[:lname]} is the...")
      expect(page).to have_content('Son  of Missy R.')
      expect(page).to have_content('Son of Ricky W.')
      expect(page).to have_content('Brother of Roland W.')
      expect(page).to have_content('Brother  of Sharon W.')
      expect(page).to have_content("#{person2[:fname]} #{person2[:lname]} is the...")
      expect(page).to have_content('Father  of Marty R.')
      expect(page).to have_content('Spouse of Missy R.')
      expect(page).to have_content('Father of Roland W.')
      expect(page).to have_content('Father  of Sharon W.')
    end

    # Deleting a person that was added to a screening.
    within person2_card do
      first(:css, 'i.fa.fa-times').click
    end
    within '#relationships-card' do
      # Verify rendering of card
      expect(page).to have_content("#{person1[:fname]} #{person1[:lname]} is the...")
      expect(page).to have_content('Son  of Missy R.')
      expect(page).to have_content('Son of Ricky W.')
      expect(page).to have_content('Brother of Roland W.')
      expect(page).to have_content('Brother  of Sharon W.')
      expect(page).not_to have_content("#{person2[:fname]} #{person2[:lname]} is the...")
      expect(page).not_to have_content('Father  of Marty R.')
      expect(page).not_to have_content('Spouse of Missy R.')
      expect(page).not_to have_content('Father of Roland W.')
      expect(page).not_to have_content('Father  of Sharon W.')
    end
  end
end
