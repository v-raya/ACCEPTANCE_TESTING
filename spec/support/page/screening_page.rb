# frozen_string_literal: true

require 'react_select_helpers'
require 'autocompleter_helpers'
require 'spec_helper'

class ScreeningPage
  include ReactSelectHelpers

  attr_reader :id

  def initalize(id: nil)
    @id = id
  end

  def visit_screening
    if id
      visit "/screenings/#{id}/edit"
    else
      visit '/'
      click_link 'Start Screening'
    end
  end

  def set_screening_information_attributes(attrs)
    within '#screening-information-card' do
      fill_in('Title/Name of Screening', with: attrs[:name]) if attrs[:name]
      fill_in('Assigned Social Worker', with: attrs[:social_worker]) if attrs[:social_worker]
      fill_in('Screening Start Date/Time', with: attrs[:start_date]) if attrs[:start_date]
      fill_in('Screening End Date/Time', with: attrs[:end_date]) if attrs[:end_date]
      select(attrs[:communication_method], from: 'Communication Method') if attrs[:communication_method]
      click_button 'Save'
    end
  end

  def set_incident_information_attributes(attrs)
    within '#incident-information-card' do
      select(attrs[:incident_county], from: 'Incident County') if attrs[:incident_county]
      click_button 'Save'
    end
  end

  def set_decision_attributes(attrs)
    within '#decision-card' do
      select(attrs[:screening_decision], from: 'Screening Decision') if attrs[:screening_decision]
      click_button 'Save'
    end
  end

  def add_person_from_search(search_term, additional_text = nil)
    within '#search-card' do
      autocompleter_fill_in 'Search for any person', search_term
      within('ul.react-autosuggest__suggestions-list') do
        page.find('li', text: additional_text).click
      end
    end
  end

  def set_participant_attributes(id, attrs)
    within "#participants-card-#{id}" do
      fill_in_react_select('Role', with: attrs[:roles]) if attrs[:roles]
      click_button 'Save'
    end
  end

  def select(*args)
    Capybara.select(*args)
  end

  def method_missing(method, *args, &block)
    if Capybara.respond_to?(method)
      Capybara.send(method, *args, &block)
    else
      super
    end
  end
end
