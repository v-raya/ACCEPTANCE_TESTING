# frozen_string_literal: true

require_relative 'date_time_helper'
require_relative '../spec/helpers/wait_for_ajax'

# form helper
module PersonFormHelper
  include WaitForAjax

  def fill_form(**args)
    # edit_form if not_editable?
    within(participant_element) do
      select_fields(args)
      fill_input_fields(args)
      fill_multi_select_form(args)
      select_check_box_fields(args)
    end
  end

  def participant_element
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

  def fill_input_fields(**args)
    self.class::INPUT_FIELDS.each do |key, value|
      next if args[key].blank?
      Capybara.fill_in(value, with: args[key],
                              fill_options: { clear: :backspace })
    end
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
      Capybara.find('label', text: args[key], exact_text: true).click
    end
  end

  def fill_form_and_save(**args)
    fill_form(args)
    click_save
  end

  def complete_form(**args)
    default_values.merge!(approximate_age) if args[:date_of_birth].blank?
    default_values.each { |key, value| args[key] = value if args[key].blank? }
    fill_form(args)
  end

  def complete_form_and_save(**args)
    complete_form(args)
    click_save
  end

  def click_save
    Capybara.find(participant_element).click_button('Save')
    WaitForAjax.wait_for_ajax
  end

  def click_cancel
    Capybara.find(participant_element).click_button('Cancel')
  end

  def edit_form
    Capybara.find(participant_element).click_link('Edit')
  end

  def click_remove
    Capybara.find(participant_element).click_button('Remove')
  end

  def not_editable?
    !editable?
  end

  def editable?
    Capybara.find(participant_element)[:class].include?('edit')
  end

  def clear_field(selector)
    Capybara.fill_in(selector, with: ' ').send_keys(:backspace)
  end
  module_function :clear_field
end
