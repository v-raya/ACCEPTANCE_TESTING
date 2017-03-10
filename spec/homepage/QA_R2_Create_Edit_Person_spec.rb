# frozen_string_literal: true
require 'react_select_helpers'

describe 'R2 Create Person', type: :feature do
  # Selecting Create Person on homepage
  before do
    visit '/'
    click_link 'Create Person'
  end

  # Fill in data in the Input fields
  it 'click on Create Person link' do
    fill_in('First Name', with: 'John')
    fill_in('Middle Name', with: 'Jacob')
    fill_in('Last Name', with: 'Jingleheimer-Schmidt')
    select 'Esq', from: 'Suffix'
    select 'Male', from: 'Gender'
    click_button 'Add new phone number'
    fill_in 'Phone Number', with: '916-555-4321'
    select 'Cell', from: 'Phone Number Type'
    fill_in 'Date of birth', with: '2006-08-11'
    fill_in 'Social security number', with: '123-23-1234'
    click_button 'Add new address'
    fill_in 'Address', with: '3743 Broadway'
    fill_in 'City', with: 'Carmel'
    select 'Arizona', from: 'State'
    fill_in 'Zip', with: '90210'
    select 'Placement', from: 'Address Type'
    fill_in_react_select 'Language(s)', with: 'English'
    fill_in_react_select 'Language(s)', with: 'Cantonese'
    find('label', text: 'Asian').click
    select 'Chinese'
    find('label', text: 'Black or African American').click
    select 'Ethiopian'
    find('label', text: 'Yes').click
    select 'Central American'
    find('label', text: 'Native Hawaiian or Other Pacific Islander').click
    select 'Guamanian'
    # binding.pry
    click_button 'Save'
    expect(page).to have_content('John')
    expect(page).to have_content('Jacob')
    expect(page).to have_content('Jingleheimer-Schmidt')
    expect(page).to have_content('Esq')
    expect(page).to have_content('Male')
    expect(page).to have_content('2006-08-11')
    expect(page).to have_content('Cantonese')
    expect(page).to have_content('English')
    expect(page).to have_content('123-23-1234')
    expect(page).to have_content('3743 Broadway')
    expect(page).to have_content('Carmel')
    expect(page).to have_content('Arizona')
    expect(page).to have_content('Placement')
    expect(page).to have_content('Yes - Central American')
    expect(page).to have_content('Asian - Chinese')
    # binding.pry
    # click on the pencil icon in header to invoke the edit page
    within '.card-header' do
      find(:css, 'i.fa.fa-pencil').click
    end

    # Verify in 'Edit' card and validate the input page contains original data
    within '.card-header' do
      expect(page).to have_content 'EDIT BASIC DEMOGRAPHICS CARD'
    end

    within '.card-body' do
      expect(page).to have_field('First Name', with: 'John')
      expect(page).to have_field('Middle Name', with: 'Jacob')
      expect(page).to have_field('Last Name', with: 'Jingleheimer-Schmidt')
      expect(page).to have_select('Suffix', selected: 'Esq')
      expect(page).to have_select('Gender', selected: 'Male')
      has_react_select_field('languages', with: %w(English Cantonese))
      expect(page).to have_field('Date of birth', with: '2006-08-11')
      expect(page).to have_field('Social security number', with: '123-23-1234')
      expect(page).to have_field('Address', with: '3743 Broadway')
      expect(page).to have_field('City', with: 'Carmel')
      expect(page).to have_select('State', selected: 'Arizona')
      expect(page).to have_select('Address Type', selected: 'Placement')
      expect(page).to have_select('ethnicity-detail', selected: 'Central American')
      expect(page).to have_checked_field('Yes')
      expect(page).to have_unchecked_field('No', disabled: true)
      expect(page).to have_select('Asian-race-detail', selected: 'Chinese')
      expect(page).to have_checked_field('Asian')
      expect(page).to have_unchecked_field('White')
      expect(page).to have_select('Native_Hawaiian_or_Other_Pacific_Islander-race-detail', selected: 'Guamanian')
      expect(page).to have_checked_field('Native Hawaiian or Other Pacific Islander')
      expect(page).to have_unchecked_field('race-Unknown')
      expect(page).to have_unchecked_field('race-Abandoned')
      expect(page).to have_unchecked_field('race-Declined_to_answer')
      expect(page).to have_unchecked_field('ethnicity-Unknown', disabled: true)
      expect(page).to have_unchecked_field('ethnicity-Abandoned', disabled: true)
      expect(page).to have_unchecked_field('ethnicity-Declined_to_answer', disabled: true)
    end
    expect(page).to have_link 'Cancel'
    expect(page).to have_button 'Save'

    # Change data on Edit card and save
    within '.card-body' do
      fill_in 'Address', with: '3743 Rodeo Drive'
      fill_in 'City', with: 'Beverly Hills'
      select 'California', from: 'State'
      fill_in 'Zip', with: '90210'
      click_button 'Save'
    end

    # Validate new data is saved and old data unchanged
    expect(page).to have_content('John')
    expect(page).to have_content('Jacob')
    expect(page).to have_content('Jingleheimer-Schmidt')
    expect(page).to have_content('Esq')
    expect(page).to have_content('Male')
    expect(page).to have_content('2006-08-11')
    expect(page).to have_content('Cantonese')
    expect(page).to have_content('English')
    expect(page).to have_content('123-23-1234')
    expect(page).to have_content('3743 Rodeo Drive')
    expect(page).to have_content('Beverly Hills')
    expect(page).to have_content('California')
    expect(page).to have_content('Placement')
    expect(page).to have_content('Yes - Central American')
    expect(page).to have_content('Asian - Chinese')

    # click on the pencil icon in header to invoke the edit page
    within '.card-header' do
      find(:css, 'i.fa.fa-pencil').click
    end

    # Verify in 'Edit' card and validate the input page contains original data
    within '.card-header' do
      expect(page).to have_content 'EDIT BASIC DEMOGRAPHICS CARD'
    end

    within '.card-body' do
      fill_in 'Address', with: '3743 Rodeo Way'
      fill_in 'City', with: 'Dallas'
      select 'Texas', from: 'State'
      fill_in 'Zip', with: '90277'
      click_link 'Cancel'
    end

    # Validate new data entered is unsaved when 'Canceled' button clicked and old data unchanged
    expect(page).to have_content('John')
    expect(page).to have_content('Jacob')
    expect(page).to have_content('Jingleheimer-Schmidt')
    expect(page).to have_content('Esq')
    expect(page).to have_content('Male')
    expect(page).to have_content('2006-08-11')
    expect(page).to have_content('Cantonese')
    expect(page).to have_content('English')
    expect(page).to have_content('123-23-1234')
    expect(page).to have_content('3743 Rodeo Drive')
    expect(page).to have_content('Beverly Hills')
    expect(page).to have_content('California')
    expect(page).to have_content('Placement')
    expect(page).to have_content('Yes - Central American')
    expect(page).to have_content('Asian - Chinese')
  end
end
