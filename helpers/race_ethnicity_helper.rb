# frozen_string_literal: true

# form helper
module RaceEthnicityHelper
  def check_race_and_select_detail(args)
    return unless lookup_race_details_fields.keys.include?(args[:race])
    check_race(args[:race])
    select_race_detail(args[:race])
  end

  def check_race(value)
    snake_case = value.split(' ').join('_')
    id = "participant-#{@id}-race-#{snake_case}"
    return if Capybara.find('input', id: id).checked?
    if Capybara.current_driver == :selenium_safari
      Capybara.find('label', text: value).click
    elsif Capybara.current_driver == :selenium_ie
      str = "$('#{participant_element} input[value=\"#{value}\"]').click()"
      Capybara.execute_script(str)
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
    yes_id = "#{@id}-ethnicity-yes"
    return if Capybara.find('input', id: yes_id).checked? ||
              Capybara.find('input', id: "#{@id}-ethnicity-no").checked?
    if Capybara.current_driver == :selenium_safari
      Capybara.find('label', text: value).click
    elsif Capybara.current_driver == :selenium_ie
      str = "$('#{participant_element} input[value=\"#{value}\"]').click()"
      Capybara.execute_script(str)
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
