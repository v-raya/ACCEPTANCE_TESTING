# frozen_string_literal: true

require_relative 'date_time_helper'
require_relative '../spec/helpers/wait_for_ajax'

# form helper
module FormHelper
  include WaitForAjax

  def fill_form(**args)
    within(self::CONTAINER) do
      select_fields(args)
      fill_input_filds(args)
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

  def fill_input_filds(**args)
    self::INPUT_FIELDS.each do |key, value|
      clear_field(value)
      fill_in(value, with: args[key])
    end
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
      find('label', text: args[key], exact_text: true).click
    end
  end

  def fill_form_and_save(**args)
    fill_form(**args)
    click_save
  end

  def complete_form(**args)
    complete_hash = Hash[self::DEFAULT_VALUES.each { |key, value| args.fetch(key, value) }]
    fill_form(complete_hash)
  end

  def complete_form_and_save(**args)
    complete_form(**args)
    click_save
  end

  def click_save
    find(self::CONTAINER).click_button('Save')
  end

  def click_cancel
    find(self::CONTAINER).click_button('Cancel')
  end

  def edit_form
    find(self::CONTAINER).click_link('Edit')
  end

  def not_editable?
    !editable?
  end

  def editable?
    find(self::CONTAINER)[:class].include?('edit')
  end

  def clear_field(selector)
    fill_in(selector, with: ' ').send_keys(:backspace)
  end
  module_function :clear_field
end
