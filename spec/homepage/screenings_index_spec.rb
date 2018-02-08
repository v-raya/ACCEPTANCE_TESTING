# frozen_string_literal: true

describe 'Screening Index', type: :feature do
  before do
    visit '/'
    login_user
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

  it 'has a table populated with screening information' do
    ScreeningPage.new.visit.and_populate using:
      Screening.referral(name: 'Eclipse', start_date: '08/21/2017')
    ScreeningPage.new.visit.and_populate using:
      Screening.random(name: 'Illuminati',
                       start_date: '09/21/2016', decision: { screening_decision: nil })

    ScreeningPage.new.visit.and_populate using:
      Screening.random(name: 'Sunglasses', start_date: '',
                       decision: { screening_decision: 'Screen out' })

    visit '/'
    expect(page).to have_css('tr', text: 'Eclipse Promote to referral Dracula 08/21/2017')
    expect(page).to have_css('tr', text: 'Illuminati prefer not to answer 09/21/2016')
    expect(page).to have_css('tr', text: 'Sunglasses Screen out John G')
  end

  it 'renders a link with the screening id if screening name is not set' do
    screening_page = ScreeningPage.new.visit.and_populate using: Screening.random(name: '')
    visit '/'
    expect(page).to have_link(screening_page.id)
  end
end
