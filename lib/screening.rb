# frozen_string_literal: true

require_relative 'snapshot'

# screening
class Screening < Snapshot
  attr_reader :id

  # instance methods
  def initialize
    @id ||= Capybara.current_url.match(%r((?<=screenings\/)([[:digit:]]{1,9})))
  end

  def complete
    ScreeningInformation.complete_form_and_save
    Narrative.complete_form_and_save
    IncidentInformation.complete_form_and_save
    Allegation.complete_form_and_save
    WorkerSafety.complete_form_and_save
    CrossReport.complete_form_and_save
    Decision.complete_form_and_save
  end

  def complete_and_submit
    complete
    click_submit
  end

  def click_submit
    find('div.page-header-container').click_button('SUBMIT')
    wait_for_ajax(time: 5)
  end

  def click_create_new_person
    click_button('Create a new person')
  end

  %w[victim reporter perpetrator].each do |role|
    define_method "create_#{role}" do |**args|
      (1..args.fetch("create_#{role}".to_sym, 1)).each do
        person = Object.const_get(role.capitalize).new(args)
        search_client(query: person.full_name)
        click_create_new_person
        WaitForAjax.wait_for_ajax
        person.complete_form(args)
      end
    end
  end
end
