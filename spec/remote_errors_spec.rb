# frozen_string_literal: true

require 'helper_methods'

describe 'Dashboard Ready', type: :feature do
  before do
    visit '/'
    login_user
  end

  it 'Displays error message for a failed request' do
    # visit a nonexistent screening to trigger a 404
    visit '/screenings/3247856237845'
    expect(page).to have_content('There was a problem with your request and the server returned an error.')
    click_button 'Expand'
    expect(page).to have_content 'error: api_error'
    expect(page).to have_content 'status: 404'
    expect(page).to have_content 'message: Error while calling /api/v1/screenings/3247856237845'
  end
end
