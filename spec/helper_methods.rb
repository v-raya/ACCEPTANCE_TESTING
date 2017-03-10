# frozen_string_literal: true
def autocompleter_fill_in(label, string)
  input = find(:fillable_field, label)
  string.split('').each do |char|
    input.send_keys(char)
    sleep(0.08)
  end
end
