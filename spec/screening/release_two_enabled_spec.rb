# frozen_string_literal: true

require 'spec_helper'

feature 'Release Two Enabled' do
  scenario 'hide list of screenings on home page' do
    visit '/'
    login_user
    expect(page).not_to have_css 'table'
  end

  scenario 'edit an existing screening' do
    ScreeningPage.new.visit

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

    # story #146835849
    within '#search-card', text: 'Search' do
      autocompleter_fill_in 'Search for clients', 'zz'
      sleep 0.3
      expect(page).not_to have_button('Create a new person')
    end
  end

  scenario 'adding a screening person, adds them in show mode without edit links' do
    ScreeningPage.new.visit

    within '#search-card', text: 'Search' do
      autocompleter_fill_in 'Search for clients', 'Tonkin'
      within('ul.react-autosuggest__suggestions-list') do
        first('li').click
      end
    end

    within 'div[id^="participants-card-"].card.show' do
      expect(page).to have_content 'Tonkin'
      expect(page).to_not have_link('Edit participant')
      expect(page).to have_button('Delete')
    end
  end

  context 'adding a person to a screening who has screening history' do
    let(:person_name) { 'Kerrie' }
    before do
      ScreeningPage.new.visit
      autocompleter_fill_in 'Search for clients', person_name
      within('ul.react-autosuggest__suggestions-list') do
        first('li').click
      end
    end

    scenario 'will not display screening history in HOI' do
      ScreeningPage.new.visit

      autocompleter_fill_in 'Search for clients', person_name
      within('ul.react-autosuggest__suggestions-list') do
        first('li').click
      end

      within '#history-card' do
        expect(page).to have_no_content 'Screening'
      end
    end
  end
end
