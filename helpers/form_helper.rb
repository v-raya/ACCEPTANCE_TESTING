# frozen_string_literal: true

require_relative 'date_time_helper'
require_relative '../spec/helpers/wait_for_ajax'

# form helper
module FormHelper
  include WaitForAjax

  def fill_form(**args)
    edit_form if not_editable?
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
      WaitForAjax.wait_for_ajax
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
      if Capybara.current_driver == :selenium_ie
        str = "$('#{self::CONTAINER} label:contains(#{args[key]})').click()"
        page.execute_script(str)
      else
        find('label', text: args[key], exact_text: true).click
      end
    end
  end

  def fill_form_and_save(**args)
    fill_form(args)
    click_save
  end

  def complete_form(**args)
    self::DEFAULT_VALUES.each { |key, value| args[key] = value if args[key].blank? }
    fill_form(args)
  end

  def complete_form_and_save(**args)
    complete_form(args)
    click_save
  end

  def click_save
    if Capybara.current_driver == :selenium_ie
      Capybara.execute_script("$('#{self::CONTAINER} button:contains("'Save'")').click()")
    else
      find(self::CONTAINER).click_button('Save')
    end
  end

  def click_cancel
    if Capybara.current_driver == :selenium_ie
      Capybara.execute_script("$('#{self::CONTAINER} button:contains("'Cancel'")').click()")
    else
      find(self::CONTAINER).click_button('Cancel')
    end
  end

  def edit_form
    if Capybara.current_driver == :selenium_ie
      Capybara.execute_script("$('#{self::CONTAINER} a:contains("'Edit'")').click()")
    else
      find(self::CONTAINER).click_link('Edit')
    end
  end

  def not_editable?
    !editable?
  end

  def editable?
    if Capybara.current_driver == :selenium_ie
      !Capybara.evaluate_script("$('#{self::CONTAINER} a:contains("'Edit'")').length")
               .zero?
    else
      find(self::CONTAINER)[:class].include?('edit')
    end
  end

  def clear_field(selector)
    fill_in(selector, with: ' ').send_keys(:backspace)
  end
  module_function :clear_field
end
