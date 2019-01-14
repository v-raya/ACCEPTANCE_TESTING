# frozen_string_literal: true

describe 'Screening Page Ready', type: :feature do
  before do
    login_user(path: intake_path)
  end

  it 'when clicking Start Screening link' do
    click_button('Start Screening')
    expect(page).to have_field('Title/Name of Screening')
  end
end    

describe 'Snapshot Page Ready', type: :feature do
  before do
    login_user(path: intake_path)
  end

  it 'when clicking Start Snapshot link' do
    click_button('Start Snapshot')
    expect(page).to have_button('Start Over')
  end
end
