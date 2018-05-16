# frozen_string_literal: true

require_relative '../helpers/form_helper'

# snapshot
class Snapshot
  extend FormHelper

  # instance methods
  %w[victim reporter perpetrator].each do |role|
    define_method "attach_#{role}" do |**args|
      (1..args.fetch("attach_#{role}".to_sym, 1)).each do
        person = Object.const_get(role.capitalize).new(args)
        search_client(query: person.full_name)
        wait_for_result_to_appear do
          find('strong.highlighted', text: person.full_name).click
        end
      end
    end
  end
end
