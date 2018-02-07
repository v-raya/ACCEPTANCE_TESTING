# frozen_string_literal: true

require 'react_select_helpers'

describe 'SSN masking behavior', type: :feature do
  before do
    ScreeningPage.new.visit
  end

  it 'correctly masks the SSN when inserting a person from search result'

  it 'Validates SSN' do
    within '#search-card' do
      autocompleter_fill_in 'Search for any person', 'Dummy name'
      click_button 'Create a new person'
      sleep 0.2
    end
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
    end

    # If I enter anything less than 9 chars it will save
    [
      { number: 1, display: '1 - -' },
      { number: 12, display: '12 -' },
      { number: 123, display: '123' },
      { number: 1234, display: '123-4' },
      { number: 12_345, display: '123-45-' },
      { number: 123_456, display: '123-45-6' },
      { number: 1_234_567, display: '123-45-67' },
      { number: 12_345_678, display: '123-45-678' },
      { number: 123_456_789, display: '123-45-6789' },
      { number: 1_234_567_890, display: '123-45-6789' }
    ].each do |ssn|
      within "##{person_card_id}" do
        ssn_field = find_field('Social security number')
        ssn_field[:value].length.times do
          ssn_field.send_keys(:backspace)
        end
        fill_in 'Social security number', with: ssn[:number]
        click_button 'Save'
      end
      within "##{person_card_id}" do
        expect(page).to have_content(ssn[:display])
        click_link 'Edit'
      end
    end

    # if I click cancel the entered values will be cleared
    within "##{person_card_id}" do
      fill_in 'Social security number', with: '999-99-9999'
      expect(page).to have_field('Social security number', with: '999-99-9999')
      click_button 'Cancel'
      expect(page).to have_content('123-45-6789')
      click_link 'Edit'
      expect(page).to have_field('Social security number', with: '123-45-6789')
    end

    # if I reload, the entered values will be cleared
    within "##{person_card_id}" do
      fill_in 'Social security number', with: '999-99-9999'
      expect(page).to have_field('Social security number', with: '999-99-9999')
      page.driver.browser.navigate.refresh
    end
    within "##{person_card_id}" do
      expect(page).to have_field('Social security number', with: '123-45-6789')
    end
  end
end
