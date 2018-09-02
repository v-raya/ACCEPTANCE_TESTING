# frozen_string_literal: true

require_relative 'card_controls_helper'
require_relative 'date_time_helper'
require_relative 'race_ethnicity_helper'
require_relative '../spec/helpers/wait'

# form helper
module PersonFormHelper
  include Wait
  include RaceEthnicityHelper
  include CardControlsHelper

  def fill_form(**args)
    within(participant_element) do
      select_fields(args)
      fill_input_fields(args)
      fill_multi_select_form(args)
      select_check_box_fields(args)
    end
  end

  def participant_element
    return "#participants-card-#{@id}" if @id.present?

    element = first('.card.participant')
    @id = element[:id].match(/\d+/)
    "#participants-card-#{@id}"
  end

  def select_fields(**args)
    self.class::SELECT_FIELDS.each do |key, value|
      next if args[key].blank?
      Capybara.select(args[key], from: value)
    end
  end

  def select_fields_with_card_id(**args)
    lookup_race_details_fields.each do |key, value|
      assign_race_detail(key, value)
    end
    assign_ethnicity_detail(args)
  end

  def fill_input_fields(**args)
    self.class::INPUT_FIELDS.each do |key, value|
      next if args[key].blank?
      if key == :date_of_birth_input
        2.times { fill_input_field(args[key], value) }
      else
        fill_input_field(args[key], value)
      end
    end
  end

  def fill_input_field(text, field)
    Capybara.find(:fillable_field, field).set('') if Capybara.current_driver == :selenium_ie
    Capybara.find(:fillable_field, field).set(text, clear: :backspace)
  end

  def fill_multi_select_form(**args)
    self.class::MULTI_SELECT_FIELDS.each do |key, value|
      next if args[key].blank?
      args[key].to_a.each do |option|
        Capybara.fill_in(value, with: option).send_keys(:enter)
      end
    end
  end

  def select_check_box_fields(**args)
    self.class::CHECKBOX_FIELDS.each_key do |key|
      next if args[key].blank?
      check_race_and_select_detail(args)
    end
    check_ethnicity_and_select_detail(args)
  end

  def fill_form_and_save(**args)
    fill_form(args)
    click_save(card_id: participant_element)
  end

  def complete_form(**args)
    default_values.merge!(approximate_age) if args[:date_of_birth].blank?
    default_values.each { |key, value| args[key] = value if args[key].blank? }
    fill_form(args)
  end

  def complete_form_and_save(**args)
    complete_form(args)
    click_save(card_id: participant_element)
  end

  def click_remove
    if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
      Capybara.execute_script("$('#{participant_element} button:contains(\"Remove\")').click()")
    else
      Capybara.find(participant_element).click_button('Remove')
    end
  end

  def clear_field(selector)
    Capybara.fill_in(selector, with: ' ').send_keys(:backspace)
  end
  module_function :clear_field
end
