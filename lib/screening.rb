# frozen_string_literal: true

require_relative 'snapshot'

# screening
class Screening < Snapshot
  attr_reader :id

  # instance methods
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
    @id = Capybara.current_url.match(/\d+/).to_s
    puts "Screening ID: #{@id}"
    find('div.page-header-container').click_button('Submit')
    WaitForAjax.wait_for_ajax
  end

  def click_create_new_person
    click_button('Create a new person')
  end

  %w[victim reporter perpetrator].each do |role|
    define_method "attach_#{role}" do |**args, &block|
      person = Object.const_get(role.capitalize).new(args)
      search_client(query: person.full_name)
      select_client(text: person.search_name)
      block.present? ? block.call(person) : person.fill_form(args)
      WaitForAjax.wait_for_ajax
    end
  end

  %w[victim reporter perpetrator].each do |role|
    define_method "create_#{role}" do |**args, &block|
      person = Object.const_get(role.capitalize).new(args)
      search_client(query: person.full_name)
      click_create_new_person
      block.present? ? block.call(person) : person.fill_form(args)
      WaitForAjax.wait_for_ajax
    end
  end
end
