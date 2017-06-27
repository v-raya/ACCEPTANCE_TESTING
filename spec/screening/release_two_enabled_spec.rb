# frozen_string_literal: true

require 'spec_helper'

feature 'Release Two Enabled' do
  scenario 'hide list of screenings on home page' do
    visit '/'
    login_user
    expect(page).not_to have_css 'table'
  end

  scenario 'edit an existing screening' do
    visit '/'
    login_user
    click_link 'Start Screening'

    within '#snapshot-card' do
      expect(page).to have_content(
        <<-STRING
        The Child Welfare History Snapshot allows you to search CWS/CMS for people and their past
        history with CWS. To start, search by any combination of name, date of birth, or social
        security number. Click on a person from the results to add them to the Snapshot, and their
        basic information and history will automatically appear below. You can add as many people
        as you like, and when ready, copy the summary of their history. You will need to manually
        paste it into a document or a field in CWS/CMS.
        STRING
      )
    end
    expect(page).to have_css('.card', text: 'Search')
    expect(page).to have_css('.card', text: 'History')

    expect(page).to_not have_content('Edit Screening')
    expect(page).to_not have_css('.card', text: 'Screening Information')
    expect(page).to_not have_css('.card', text: 'Narrative')
    expect(page).to_not have_css('.card', text: 'Incident Information')
    expect(page).to_not have_css('.card', text: 'Allegations')
    expect(page).to_not have_css('.card', text: 'Relationships')
    expect(page).to_not have_css('.card', text: 'Worker Safety')
    expect(page).to_not have_css('.card', text: 'Cross Report')
    expect(page).to_not have_css('.card', text: 'Decision')
    expect(page).not_to have_button('Submit')
  end

  scenario 'adding a screening person, adds them in show mode without edit links' do
    visit '/'
    login_user
    click_link 'Start Screening'

    within '#search-card', text: 'Search' do
      autocompleter_fill_in 'Search for any person', 'Test'
      within('ul.react-autosuggest__suggestions-list') do
        first('li').click
      end
    end

    within 'div[id^="participants-card-"].card.show' do
      expect(page).to have_content 'Test'
      expect(page).to_not have_link('Edit participant')
      expect(page).to have_button('Delete participant')
    end
  end

  context 'adding a person to a screening who has screening history' do
    let(:person_name) { 'Kerrie' }
    before do
      visit '/'
      login_user
      click_link 'Start Screening'
      autocompleter_fill_in 'Search for any person', person_name
      within('ul.react-autosuggest__suggestions-list') do
        first('li').click
      end
    end

    scenario 'will not display screening histoy in HOI' do
      visit '/'
      click_link 'Start Screening'

      autocompleter_fill_in 'Search for any person', person_name
      within('ul.react-autosuggest__suggestions-list') do
        first('li').click
      end

      within '#history-card' do
        expect(page).to have_no_content 'Screening'
      end
    end
  end
end
