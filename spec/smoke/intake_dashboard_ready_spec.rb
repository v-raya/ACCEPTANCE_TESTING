# frozen_string_literal: true

describe 'Dashboard Ready', type: :feature do
  before do
    login_user(path: intake_path)
  end

  it 'has a Start Screening/Snapshot link' do
    expect(page).to have_button('Start Screening')
    expect(page).to have_button('Start Snapshot')
  end
end
