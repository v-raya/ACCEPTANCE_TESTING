# frozen_string_literal: true

describe 'Screening Page Ready', type: :feature do
  before do
    login_user(path: intake_path)
    expect(page).to have_content('Hotline')
    expect(page).to have_content('Snapshot')
  end
end    
