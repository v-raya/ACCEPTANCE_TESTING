# frozen_string_literal: true

describe 'Screening Index', type: :feature do
  before do
    visit '/'
    login_user
  end
  
  it 'has a global header' do
    expect(page).to have_css('header')
  end
  
  it 'has a global header should have text CWDS' do
    expect(page).to have_button('CWDS')
  end
  
  it 'has a header that contains user full name' do
    within '.profile' do
      expect(page).to have_link('Testing CWDS')
    end
  end
  
  it 'has a Start Screening button' do
    expect(page).to have_button('Start Screening')
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
  
  it 'has a table populated with screenings' do
    pending("Until a predefined version of screenings will be found, this won't work")
    ScreeningPage.new.visit.and_populate using:
    Screening.referral(name: 'Acceptance Testing One', start_date: '08/21/2017')
    
    ScreeningPage.new.visit.and_populate using:
    Screening.random(name: 'Acceptance Testing Two',
    start_date: '09/21/2016', decision: { screening_decision: nil })
    
    ScreeningPage.new.visit.and_populate using:
    Screening.random(name: 'Acceptance Testing Three', start_date: '',
    decision: { screening_decision: 'Screen out' })
    
    visit '/'
    click_link 'Intake'
    expect(page).to have_css('tr', text: 'Acceptance Testing One')
    expect(page).to have_css('tr', text: 'Acceptance Testing Two')
    expect(page).to have_css('tr', text: 'Acceptance Testing Three')
  end
end
