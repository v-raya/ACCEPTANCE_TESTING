# frozen_string_literal: true

DATE_FORMATS = {
  'Date' => '%m/%d/%Y',
  'Time' => '%m/%d/%y %l:%m %p',
  'DateTime' => '%m/%d/%y%l:%m %p',
  'ActiveSupport::TimeWithZone' => '%m/%d/%y %l:%m %p'
}.freeze

def fill_in_datepicker(locator, with:, blur: true)
  date_string = date_to_string(with)
  # change events for the datepicker are only firing correctly after the
  # second event because of differences in how capybara is triggering
  # change events
  # also, the blur event is important to the component lifecycle so we
  # need to trigger that by clicking on an arbitrary element.
  fill_in(locator, with: date_string)
  fill_in(locator, with: date_string)
  first('*').click if blur
end

def date_to_string(date_object)
  date_format = DATE_FORMATS[date_object.class.to_s]

  if date_format
    date_object.strftime(date_format)
  else
    date_object
  end
end

def focus(locator)
  element = page.find_field(locator)
  if element.tag_name == 'select'
    execute_script("$('##{element['id']}').trigger('focus')")
  else
    element.click
  end
end

def blur
  first('*').native.click
end
