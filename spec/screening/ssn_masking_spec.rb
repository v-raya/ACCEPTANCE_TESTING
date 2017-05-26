# frozen_string_literal: true
require 'react_select_helpers'

describe 'save a zippy referral', type: :feature do

  before do
    visit '/'
    login_user
    click_link 'Start Screening'
    within '#search-card' do
      autocompleter_fill_in 'Search for any person', 'Dummy name'
      click_button 'Create a new person'
      sleep 0.2
    end
  end

  it 'Validates SSN' do

    person_card_id = find('div[id^="participants-card-"]')[:id]

    within "##{person_card_id}" do

      # capybara bug
      find_field('Social security number').click

      # I should not see masking until I click on SSN
      expect(page).to have_field('Social security number', with: '')

      # I can only enter numbers into the SSN field
      #  - When I enter non-numeric chars, noting happens
      fill_in('Social security number', with: '7-G-7=q7~!@#$%^&*()7<7.7|7\77')
      expect(page).to have_field('Social security number', with: '777-77-7777')

      # I can only enter <=9 characters into the field
      fill_in('Social security number', with: '123456789123456789123456789')
      expect(page).to have_field('Social security number', with: '123-45-6789')


      # fill_in('Social security number', with: person[:ssn])
      # click_button 'Save'
    end

    # If I enter anything less than 9 chars it will save
    [
      {number: 1, display: '1'},
      {number: 12, display: '12'},
      {number: 123, display: '123'},
      {number: 1234, display: '123-4'},
      {number: 12345, display: '123-45'},
      {number: 123456, display: '123-45-6'},
      {number: 1234567, display: '123-45-67'},
      {number: 12345678, display: '123-45-678'},
      {number: 123456789, display: '123-45-6789'},
      {number: 1234567890, display: '123-45-6789'}
    ].each do |ssn|
      within "##{person_card_id}" do
        fill_in 'Social security number', with: ''
        fill_in 'Social security number', with: ssn[:number]
        expect(page).to have_field('Social security number', with: ssn[:number])
        click_button 'Save'
      end
      within "##{person_card_id}" do
        expect(page).to have_content(ssn[:display])
        click_link 'Edit'
      end
    end
  end
end
