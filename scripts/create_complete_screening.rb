# frozen_string_literal: true

require 'react_select_helpers'
require 'spec_helper'
require 'capybara'

describe 'Submitting a referral when screening is valid', type: :feature do
  it 'enables the submit button' do
    referral_screening = Screening.referral
    ScreeningPage.new.visit.and_populate using: referral_screening
    puts "Go find your screening, named #{referral_screening[:name]}, at #{page.current_url}"
    expect(find_button('Submit').disabled?).to be(false)
  end
end
