# frozen_string_literal: true

require 'helper_methods'

describe 'Dashboard Ready', type: :feature do
  before do
    visit '/intake'
    login_user
  end

  it 'has a Start Screening link' do
    expect(page).to have_button('Start Screening')
  end

end
