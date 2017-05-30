# frozen_string_literal: true

describe 'Relationships', type: :feature do
  # Selecting Create Person on homepage

  def add_relationships
    autocompleter_fill_in 'Search for any person', 'zz'
    click_button 'Create a new person'
    sleep 0.3

    person1_id = find('div[id^="participants-card-"]', text: 'Unknown')[:id]
    person1_card = find('#' + person1_id)
    within person1_card do
      find('input#first_name').click
      fill_in('First Name', with: 'Trevor')
      fill_in('Last Name', with: 'Corey')
      click_link 'Save'
    end

    autocompleter_fill_in 'Search for any person', 'aa'
    click_button 'Create a new person'
    sleep 0.3
    person2_id = find('div[id^="participants-card-"]', text: 'Unknown')[:id]
    person2_card = find('#' + person1_id)
    within person2_card do
      find('input#first_name').click
      fill_in('First Name', with: 'Ricky')
      fill_in('Last Name', with: 'Julian')
      click_link 'Save'
    end

  end

  before do
    visit '/'
    login_user
    click_link 'Start Screening'
    add_relationships
  end

  it 'Testing of Cross Report' do
    within '#cross-report-card' do
      within '.card-header' do
        expect(page).to have_content 'Cross Report'
      end
      within '.card-body' do
      end
      # Verify that saving a blank card results in no data being saved.
      within '.card-header' do
      end
    end
  end
end
