# frozen_string_literal: true

require 'helper_methods'

describe 'Dashboard Ready', type: :feature do
  before do
    visit '/'
    login_user
  end

  it 'has a Start Screening link' do
    expect(page).to have_link('Start Screening')
  end

  it 'has a screening name column' do
    expect(page).to have_css('th', text: 'Screening Name')
  end

  it 'has a decision column' do
    expect(page).to have_css('th', text: 'Type/Decision')
  end

  it 'has a status column' do
    expect(page).to have_css('th', text: 'Status')
  end

  it 'has an assignee column' do
    expect(page).to have_css('th', text: 'Assignee')
  end

  it 'has a report date and time column' do
    expect(page).to have_css('th', text: 'Report Date and Time')
  end
end
