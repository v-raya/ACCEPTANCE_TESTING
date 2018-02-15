# frozen_string_literal: true

require 'react_select_helpers'
require 'autocompleter_helpers'
require 'spec_helper'

class ScreeningPage
  include ReactSelectHelpers
  include Capybara::DSL

  attr_reader :id

  def initalize(id: nil)
    @id = id
  end

  def visit
    Capybara.visit '/'
    login_user

    id ? Capybara.visit("/screenings/#{id}/edit") : click_button('Start Screening')
    self
  end

  def populate(using:)
    set_screening_information_attributes(using)
    using[:participants]&.each { |person| add_new_person(person) }
    set_narrative(using)
    set_incident_information_attributes(using)
    add_allegations(using[:allegations]) if using[:allegations]
    set_worker_safety_attributes
    set_cross_report_attributes(using[:cross_reports]) if using[:cross_reports]
    set_decision_attributes(using[:decision]) if using[:decision]
    self
  end
  alias and_populate populate

  def set_worker_safety_attributes
    click_link 'Worker Safety'
    within '#worker-safety-card' do
      click_button 'Save'
    end
  end

  def add_allegations(attrs)
    click_link 'Allegations'
    within '#allegations-card' do
      attrs[:allegation_types] && attrs[:allegation_types].each do |type|
        fill_in_react_select(attrs[:field_label], with: type)
      end
      blur
      click_button 'Save'
    end
  end

  def set_screening_information_attributes(attrs)
    click_link 'Screening Information'
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
    click_link 'Narrative'
    within '#narrative-card' do
      fill_in('Report Narrative', with: attrs[:narrative]) if attrs[:narrative]
      click_button 'Save'
    end
  end

  def set_incident_information_attributes(attrs)
    click_link 'Incident Information'
    within '#incident-information-card' do
      fill_in_datepicker('Incident Date', with: attrs[:incident_date]) if attrs[:incident_date]
      select(attrs[:incident_county], from: 'Incident County') if attrs[:incident_county]
      fill_in('Address', with: attrs[:address]) if attrs[:address]
      fill_in('City', with: attrs[:city]) if attrs[:city]
      select(attrs[:state], from: 'State') if attrs[:state]
      fill_in('Zip', with: attrs[:zip]) if attrs[:zip]
      select(attrs[:location_type], from: 'Location Type') if attrs[:location_type]
      click_button 'Save'
    end
  end

  def set_allegations_attributes(attrs)
    click_link 'Allegations'
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
    click_link 'Cross Report'
    within '#cross-report-card' do
      if attrs[:county]
        select attrs[:county], from: 'County'
      else
        select 'Fresno', from: 'County'
      end
      if attrs[:agencies].any?
        attrs[:agencies].each do |agency|
          find('label', text: agency[:type]).click if agency[:type]
          select agency[:name], from: "#{agency[:type].tr(' ', '_').upcase}-agency-code" if agency[:name]
        end
        fill_in_datepicker('Cross Reported on Date', with: attrs[:date]) if attrs[:date]
        select(attrs[:communication_method], from: 'Communication Method') if attrs[:communication_method]
      end
      click_button 'Save'
    end
  end

  def set_decision_attributes(attrs)
    click_link 'Decision'
    within '#decision-card' do
      select(attrs[:screening_decision], from: 'Screening decision') if attrs[:screening_decision]
      select(attrs[:response_time], from: 'Response time') if attrs[:response_time]
      click_button 'Save'
    end
  end

  def add_person_from_search(name:, additional_info: nil)
    within '#search-card' do
      autocompleter_fill_in 'screening_participants', "#{name} #{additional_info}"
      find('.profile-picture').first('img').click
    end
  end

  def add_new_person(person = nil)
    within '#search-card' do
      autocompleter_fill_in 'screening_participants', 'abcdef'
      click_button 'Create a new person'
      sleep 0.5
    end
    person_id = page.find('div[id^="participants-card-"].edit')[:id].split('-').last
    set_participant_attributes(person_id, person) if person
    person_id
  end

  def set_participant_attributes(id, attrs)
    # TODO: Replace with `click_link Participant.full_name(attrs)` Once people are implemented in sidebar
    click_link 'People & Roles'
    within "#participants-card-#{id}.edit" do
      attrs[:roles] && attrs[:roles].each do |role|
        fill_in_react_select('Role', with: role)
      end
      fill_in('First Name', with: attrs[:first_name]) if attrs[:first_name]
      fill_in('Middle Name', with: attrs[:middle_name]) if attrs[:middle_name]
      fill_in('Last Name', with: attrs[:last_name]) if attrs[:last_name]
      fill_in('Social security number', with: attrs[:ssn]) if attrs[:ssn]
      fill_in('Date of birth', with: attrs[:date_of_birth]) if attrs[:date_of_birth]
      select(attrs[:gender], from: 'Gender') if attrs[:gender]
      attrs[:languages] && attrs[:languages].each do |language|
        fill_in_react_select('Language(s)', with: language)
      end
      attrs[:addresses] && attrs[:addresses].each do |address|
        within '.card-body' do
          click_button 'Add new address'
          # TODO: add an identifier to the newly created address div so we can find it
          # using the selector this way is very flaky
          # Note: don't try to use all(selector).last because it does not "wait"
          within 'div.list-item:nth-last-child(2)' do
            fill_in('Address', with: address[:street_address]) if address[:street_address]
            fill_in('City', with: address[:city]) if address[:city]
            select(address[:state], from: 'State') if address[:state]
            fill_in('Zip', with: address[:zip]) if address[:zip]
            select(address[:type], from: 'Address Type') if address[:type]
          end
        end
      end
      click_button 'Save'
    end
  end
end
