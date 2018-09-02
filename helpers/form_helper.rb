# frozen_string_literal: true

require_relative 'date_time_helper'
require_relative 'card_controls_helper'
require_relative '../spec/helpers/wait'

# form helper
module FormHelper
  include Wait
  include CardControlsHelper

  def fill_form(**args)
    edit_form(card_id: self::CONTAINER) if not_editable?(card_id: self::CONTAINER)
    within(self::CONTAINER) do
      select_fields(args)
      fill_input_fields(args)
      fill_multi_select_form(args)
      select_check_box_fields(args)
    end
  end

  def select_fields(**args)
    self::SELECT_FIELDS.each do |key, value|
      select(args[key], from: value)
      Wait.for_ajax
    end
  end

  def fill_input_fields(**args)
    self::INPUT_FIELDS.each do |key, value|
      next if args[key].blank?
      if %i[start_date end_date incident_date].include?(key)
        2.times { fill_input_field(args[key], value) }
      else
        fill_input_field(args[key], value)
      end
    end
  end

  def fill_input_field(text, field)
    Capybara.find(:fillable_field, field)
            .set(text, clear: :backspace)
  end

  def fill_multi_select_form(**args)
    self::MULTI_SELECT_FIELDS.each do |key, value|
      args[key].to_a.each do |option|
        if self == Allegation
          find("#{self::CONTAINER} .Select-control input").set(option).send_keys(:enter)
        else
          fill_in(value, with: option).send_keys(:enter)
        end
      end
    end
  end

  def select_check_box_fields(**args)
    self::CHECKBOX_FIELDS.each_key do |key|
      if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
        str = "$('#{self::CONTAINER} label:contains(#{args[key]})').click()"
        page.execute_script(str)
      else
        find('label', text: args[key], exact_text: true).click
      end
    end
  end

  def fill_form_and_save(**args)
    fill_form(args)
    click_save(card_id: self::CONTAINER)
  end

  def complete_form(**args)
    self::DEFAULT_VALUES.each { |key, value| args[key] = value if args[key].blank? }
    fill_form(args)
  end

  def complete_form_and_save(**args)
    complete_form(args)
    click_save(card_id: self::CONTAINER)
  end

  def clear_field(selector)
    fill_in(selector, with: ' ').send_keys(:backspace)
  end
  module_function :clear_field
end
