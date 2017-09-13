# frozen_string_literal: true

describe 'Marking screening as Sealed', type: :feature do
  screening = ScreeningPage.new
  referral = Screening.referral(
    name: 'Restricted Screening',
    access_restrictions: 'Mark as Sealed',
    restrictions_rationale: 'Screening is marked as sealed for testing'
  )
  before do
    screening.visit(
      {
        'user': 'user',
        'staffId': '0X5',
        'privileges': ['Sensitive Persons','Sealed'],
        'county_code': '01'
      }.to_json,
      'guest'
    )
  end

  it 'renders the access restrictions field' do
    expect(page).to have_select('Access Restrictions', options:[
      'Do not restrict access',
      'Mark as Sensitive',
      'Mark as Sealed'
    ])
  end

  it 'defaults access restrictions with no restrictions' do
    expect(page).to have_select('Access Restrictions', selected: 'Do not restrict access' )
  end

  it 'does not render restrictions rationale field by default' do
    expect(page).to_not have_field('Restrictions Rationale')
  end

  it 'displays restrictions rationale field when screening is marked as sealed' do
    select 'Mark as Sealed', from: 'Access Restrictions'
    expect(page).to have_field('Restrictions Rationale')
  end

  it 'hides restrictions rationale when access restrictions are removed' do
    select 'Mark as Sealed', from: 'Access Restrictions'
    select 'Do not restrict access', from: 'Access Restrictions'
    expect(page).to_not have_field('Restrictions Rationale')
  end

  it 'displays restrictions rationale field when screening is marked as sensitive' do
    select 'Mark as Sensitive', from: 'Access Restrictions'
    expect(page).to have_field('Restrictions Rationale')
  end

  it 'renders restrictions rationale label as required' do
    select 'Mark as Sensitive', from: 'Access Restrictions'
    expect(page).to have_css('label.required', text: 'Restrictions Rationale')
  end

  it "displays 'Sensitive' without 'Mark as' in show mode" do
    select 'Mark as Sensitive', from: 'Access Restrictions'
    within '#decision-card.edit' do
      click_button 'Save'
    end
    expect(page).to have_text('Access Restrictions Sensitive Restrictions Rationale')
  end

  it "displays 'Sealed' without 'Mark as' in show mode" do
    select 'Mark as Sealed', from: 'Access Restrictions'
    fill_in('Restrictions Rationale', with: 'Screening is marked as sealed for testing')
    within '#decision-card.edit' do
      click_button 'Save'
    end
    expect(page).to have_text(
      'Access Restrictions Sealed Restrictions Rationale Screening is marked as sealed for testing'
    )
  end

  it 'creates a referral successfully' do
    screening.populate using: referral
    click_button 'Submit'
    sleep 1
    dialog = page.driver.browser.switch_to.alert
    expect(dialog.text).to include('Successfully created referral')
  end

  context 'within the same screening' do
    it 'renders sealed label in participants headers' do
      referral[:participants].each do |participant|
        header_text = "#{Participant.full_name(participant)} Sealed"
        expect(page).to have_css('div.card-header', text: header_text)
      end
    end
  end
  context 'when searching for screening participants' do
    it 'renders sealed label next to participants in search results' do
      ScreeningPage.new.visit
      referral[:participants].each do |participant|
        name = Participant.full_name(participant)
        autocompleter_fill_in 'Search for any person', name
        within('ul.react-autosuggest__suggestions-list') do
          expect(page).to have_css('li', text: "Sealed #{name}")
        end
      end
    end
  end
end
