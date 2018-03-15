# frozen_string_literal: true

describe 'Screening Index', type: :feature, js: true do
  before do
    visit '/'
    login_user
    click_button 'Start Screening'
  end

  let(:nav_links) { page.all('.side-bar ul li a') }
  let(:card_elements) { page.all('a.anchor', visible: false) }

  it 'has a sidebar' do
    expect(page).to have_css('.side-bar')
  end

  it 'has list of anchor links on the left hand side of the page' do
    within '.side-bar' do
      expect(page).to have_link('People & Roles', href: '#search-card-anchor')
      expect(page).to have_link('Relationships', href: '#relationships-card-anchor')
      expect(page).to have_link('History', href: '#history-card-anchor')
    end
  end

  it 'has a sidebar anchor links that appear in the same order as they are presented on the right hand side' do
    card_elements.each_with_index do |element, index|
      expect(nav_links[index][:href]).to include element[:id]
    end
  end

  it 'has a side anchor links, when clicked should automatically scroll and put the card in focus' do
    click_link('People & Roles')
    expect(page).to have_css ('#search-card')
    expect(page.current_url).to include '#search-card-anchor'
    click_link('Relationships')
    expect(page).to have_css ('#relationships-card')
    expect(page.current_url).to include '#relationships-card-anchor'
    click_link('History')
    expect(page).to have_css ('#history-card')
    expect(page.current_url).to include '#history-card-anchor'
  end

  it 'has a sidebar that sticks to the left side when scrolling down the page' do
    page.execute_script "window.scrollBy(0,10000)"
    click_link('People & Roles')
    click_link('Relationships')
    click_link('History')
    expect(page).to have_css('.side-bar')
  end
end
