# frozen_string_literal: true

# form helper
module RaceEthnicityHelper
  def select_check_box_fields(**args)
    self.class::CHECKBOX_FIELDS.each_key do |key|
      next if args[key].blank?
      check_race_and_select_detail(args)
    end
    check_ethnicity_and_select_detail(args)
  end

  def check_race_and_select_detail(args)
    return unless lookup_race_details_fields.keys.include?(args[:race])
    check_race(args[:race])
    select_race_detail(args[:race])
  end

  def check_race(value)
    snake_case = value.split(' ').join('_')
    return if Capybara.find('input', id: "participant-#{@id}-race-#{snake_case}").checked?
    if Capybara.current_driver == :selenium_safari
      Capybara.find('label', text: value).click
    else
      Capybara.check(value, allow_label_click: true)
    end
  end

  def select_race_detail(key)
    Capybara.find(lookup_race_details_fields[key])
            .first(:option, self.class::RACES[key].sample)
            .select_option
  end

  def check_ethnicity_and_select_detail(args)
    check_ethnicity(args[:ethnicity])
    select_ethnicity_detail(args) if args[:ethnicity] == 'Yes'
  end

  def check_ethnicity(value)
    return if Capybara.find('input', id: "#{@id}-ethnicity-yes").checked? ||
              Capybara.find('input', id: "#{@id}-ethnicity-no").checked?
    if Capybara.current_driver == :selenium_safari
      Capybara.find('label', text: value).click
    else
      Capybara.check(value, allow_label_click: true)
    end
  end

  def select_ethnicity_detail(**_args)
    Capybara.find("#participant-#{@id}-ethnicity-detail")
            .first(:option, self.class::HISPANIC_LATINO_ORIGIN['Yes'].sample)
            .select_option
  end
end
