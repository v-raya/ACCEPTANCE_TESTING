# frozen_string_literal: true

describe 'Basic Person Search', type: :feature do
  let(:screening_page) { ScreeningPage.new }
  let(:person) do
    {
      fname: 'Johnny',
      mname: 'Bobo',
      lname: 'Grissett',
      suffix: 'Jr',
      language: 'French',
      language2: 'German',
      races: ['Asian', 'American Indian or Alaska Native'],
      phonenum: '3653636363',
      formatted_phonenum: '(365)363-6363',
      phonetype: 'Cell',
      dob: '5/4/1981',
      gender: 'Male',
      ssn: '953-00-9775',
      addr: '368 Westport Pass',
      city: 'Lakeport',
      state: 'California',
      zip: '45435',
      addrtype: 'Home'
    }
  end

  before do
    screening_page.visit
  end

  it 'searches for and finds a known person' do
    within '#search-card' do
      autocompleter_fill_in 'screening_participants', 'Grissett'
      within '.profile-picture' do
        expect(page).to have_css 'img'
      end
      expect(page).to have_content 'Johnny Bobo Grissett Jr'
      find('strong.highlighted em', text: 'Grissett')
      expect(page).to have_content 'Male, Asian, American Indian or Alaska Native'
      expect(page).to have_content '(DOB:5/4/1981)'
      expect(page).to have_content 'LanguageFrench (Primary), German'
      expect(page).to have_content 'SSN953-00-9775'
      expect(page).to have_content 'Home368 Westport Pass, Lakeport, CA 45435'
      expect(page).to have_content 'Cell3653636363'
    end
  end

  it 'adds a person from search' do
    within '#search-card' do
      autocompleter_fill_in 'screening_participants', 'Grissett'
      within '.profile-picture' do
        expect(page).to have_css 'img'
      end
      find('strong.highlighted em', text: 'Grissett').click
    end
    person_css_id = find('div[id^="participants-card-"]', text: 'Johnny Bobo Grissett, Jr')[:id]
    person_id = person_css_id.split('-')[2]
    person_card = find("##{person_css_id}")
    within person_card do
      # check demographics
      expect(page).to have_field('First Name', disabled: false, with: 'Johnny')
      expect(page).to have_field('Middle Name', disabled: false, with: 'Bobo')
      expect(page).to have_field('Last Name', disabled: false, with: 'Grissett')
      expect(page).to have_select('name_suffix', disabled: false, selected: 'Jr')
      expect(page).to have_field('Social security number', disabled: false, with: '953-00-9775')
      expect(page).to have_field('Date of birth', disabled: false, with: '05/04/1981')
      expect(page).to have_select('gender', disabled: false, selected: 'Male')
      has_react_select_field("languages_#{person_id}", with: %w[German French])
      # check race
      expect(page).to have_field('Asian', disabled: false, checked: true)
      expect(page).to have_select(
        "participant-#{person_id}-Asian-race-detail",
        disabled: false,
        selected: 'Cambodian'
      )
      expect(page).to have_field('American Indian or Alaska Native', disabled: false, checked: true)
      expect(page).to have_select(
        "participant-#{person_id}-American_Indian_or_Alaska_Native-race-detail",
        disabled: false,
        selected: 'Alaska Native'
      )
      expect(page).to have_field('No', disabled: false, checked: true)
      # check numbers
      expect(page).to have_field('number-0', disabled: false, with: '(365)363-6363')
      expect(page).to have_field('type-0', disabled: false, with: 'Cell')
      expect(page).to have_field('number-1', disabled: false, with: '(808)000-2880')
      expect(page).to have_field('type-1', disabled: false, with: nil)
      expect(page).to have_field('number-2', disabled: false, with: '(363)635-6365')
      expect(page).to have_field('type-2', disabled: false, with: 'Other')
      # check address
      expect(page).to have_field('Address', disabled: false, with: '368 Westport Pass')
      expect(page).to have_field('City', disabled: false, with: 'Lakeport')
      expect(page).to have_select('state', disabled: false, selected: 'California')
      expect(page).to have_field('Zip', disabled: false, with: '45435')
      expect(page).to have_select('address_type', disabled: false, selected: '')
    end
  end
end
