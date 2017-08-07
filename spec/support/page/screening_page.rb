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
    visit '/'
    login_user

    if id
      visit "/screenings/#{id}/edit"
    else
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

  def set_narrative(attrs)
    within '#narrative-card' do
      fill_in('Report Narrative', with: attrs[:narrative]) if attrs[:narrative]
      click_button 'Save'
    end
  end

  def set_incident_information_attributes(attrs)
    within '#incident-information-card' do
      select(attrs[:incident_county], from: 'Incident County') if attrs[:incident_county]
      fill_in_datepicker('Incident Date', with: attrs[:incident_date]) if attrs[:incident_date]
      fill_in('Address', with: attrs[:address]) if attrs[:address]
      fill_in('City', with: attrs[:city]) if attrs[:city]
      select(attrs[:state], from: 'State') if attrs[:state]
      fill_in('Zip', with: attrs[:zip]) if attrs[:zip]
      select(attrs[:location_type], from: 'Location Type') if attrs[:location_type]
      click_button 'Save'
    end
  end

  def set_allegations_attributes(attrs)
    within '#allegations-card' do
      attrs[:allegations].each do |allegation|
        allegations_field_id = "allegations_#{allegation[:victim_id]}_#{allegation[:perpetrator_id]}"

        allegations_to_remove = selected_options(allegations_field_id).reject do |type|
          allegation[:allegation_types].include?(type)
        end
        allegations_to_remove.each do |type|
          remove_react_select_option(allegations_field_id, type)
        end
        blur # allegations_field_id

        allegation[:allegation_types].each do |type|
          fill_in_react_select(allegations_field_id, with: type)
        end

        blur # allegations_field_id
      end
      click_button 'Save'
    end
  end

  def set_cross_report_attributes(attrs)
    within '#cross-report-card' do
      attrs[:agencies] && attrs[:agencies].each do |agency|
        find('label', text: agency[:type]).click if agency[:type]
        fill_in("#{agency[:type].tr(' ', '_')}-agency-name", with: agency[:name]) if agency[:name]
      end
      fill_in_datepicker('Cross Reported on Date', with: attrs[:date]) if attrs[:date]
      select(attrs[:communication_method], from: 'Communication Method') if attrs[:communication_method]
      click_button 'Save'
    end
  end

  def set_decision_attributes(attrs)
    within '#decision-card' do
      select(attrs[:screening_decision], from: 'Screening Decision') if attrs[:screening_decision]
      select(attrs[:response_time], from: 'Response time') if attrs[:response_time]
      click_button 'Save'
    end
  end

  def add_person_from_search(name:, additional_info: nil)
    within '#search-card' do
      autocompleter_fill_in 'Search for any person', "#{name} #{additional_info}"
      within('ul.react-autosuggest__suggestions-list') do
        page.first('li', text: name).click
      end
    end
  end

  def add_new_person
    within '#search-card' do
      autocompleter_fill_in 'Search for any person', 'abcdef'
      click_button 'Create a new person'
      sleep 0.5
    end
    parse_person_id
  end

  def set_participant_attributes(id, attrs)
    within "#participants-card-#{id}" do
      fill_in('First Name', with: attrs[:first_name]) if attrs[:first_name]
      fill_in('Middle Name', with: attrs[:middle_name]) if attrs[:middle_name]
      fill_in('Last Name', with: attrs[:last_name]) if attrs[:last_name]
      fill_in('Social security number', with: attrs[:ssn]) if attrs[:ssn]
      fill_in('Date of birth', with: attrs[:dob]) if attrs[:dob]
      fill_in_react_select('Role', with: attrs[:roles]) if attrs[:roles]
      select(attrs[:gender], from: 'Gender') if attrs[:gender]
      attrs[:addresses] && attrs[:addresses].each do |address|
        within '.card-body' do
          click_button 'Add new address'
          address_div = all('#address-undefined').last
          within address_div do
            fill_in('Address', with: address[:street_address]) if address[:street_address]
            fill_in('City', with: address[:city]) if address[:city]
            select(address[:state], from: 'State') if address[:state]
            fill_in('Zip', with: address[:zip]) if address[:zip]
          end
        end
      end
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

  private

  def parse_person_id
    page.all('div[id^="participants-card-"]').first[:id].split('-').last
  end
end
