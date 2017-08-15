# frozen_string_literal: true

module DateTimeHelpers
  def mouse_select_datepicker(locator, day)
    component = page.find(locator)
    component.find('.rw-btn-calendar').click
    component.find(
      "[id*='calendar__month'][id$='-#{day}']", visible: :all
    ).click
  end

  def mouse_select_timepicker(locator, time)
    component = page.find(locator)
    component.find('.rw-btn-time').native.click
    component.find('.rw-list-option', text: /\A#{time.strip}\z/).click
  end

  def select_today_from_calendar(locator)
    within locator do
      find('.rw-btn-calendar').native.click
      find('button', text: Time.now.strftime('%B %-d, %Y')).click
    end
  end
end

RSpec.configure do |config|
  config.include DateTimeHelpers, type: :feature
end
