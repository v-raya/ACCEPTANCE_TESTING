# frozen_string_literal: true

describe 'Snapshot Index', type: :feature do
  before do
    visit '/'
    login_user
    click_button 'Start Snapshot'
  end

  it 'has a sidebar' do
    expect(page).to have_link('People & Roles', :href => '#search-card-anchor')
    expect(page).to have_link('Relationships', :href => '#relationships-card-anchor')
    expect(page).to have_link('History', :href => '#history-card-anchor')
  end
end
