# frozen_string_literal: true

require 'react_select_helpers'
require 'autocompleter_helpers'
require 'helper_methods'
require 'support/page/screening_page'

describe 'History Card with screenings', type: :feature do
  person1 = { dob: '01/10/1998', name: 'Jason Yashnov', roles: ['Victim'] }
  person2 = { dob: '12/22/1963', name: 'Peggy Brankley', roles: ['Perpetrator'] }
  person3 = { dob: '03/26/1970', name: 'Willie Daal', roles: ['Anonymous Reporter'] }
  person4 = { dob: '08/01/1998', name: 'Terrick Puffett', roles: ['Victim', 'Mandated Reporter'] }

  scr1 = {
    name: 'Harry',
    start_date: '02/01/2015',
    end_date: '01/02/2016',
    status: 'Closed',
    people: [person1],
    people_names: [person1[:name]]
  }

  scr2 = {
    name: 'Barry',
    start_date: '02/03/2015',
    end_date: '02/03/2016',
    status: 'Closed',
    people: [person2, person3],
    people_names: [person3[:name], person2[:name]],
    reporter: person3[:name]
  }

  scr3 = {
    name: 'Trin',
    start_date: '03/04/2015',
    status: 'In Progress',
    people: [person3],
    people_names: [person3[:name]],
    reporter: person3[:name]
  }

  scr4 = {
    name: 'Bay',
    start_date: '05/06/2015',
    status: 'In Progress',
    people: [person4],
    people_names: [person4[:name]],
    reporter: person4[:name]
  }

  scr5 = {
    name: 'TrinBayShared',
    start_date: '06/07/2015',
    end_date: '06/07/2016',
    status: 'Closed',
    people: [person1, person2],
    people_names: [person2[:name], person1[:name]]
  }

  scr6 = {
    name: 'TrinBaySharedAgain',
    start_date: '07/08/2015',
    status: 'In Progress',
    people: [person1, person2],
    people_names: [person2[:name], person1[:name]]
  }

  before do
    visit '/'
    login_user

    screenings = [scr1, scr2, scr3, scr4, scr5, scr6]
    screenings.each do |screening|
      screening_page = ScreeningPage.new.visit

      expect(page).to have_content 'Screening '
      screening[:id] = screening_page.id

      screening_page.set_screening_information_attributes(name: screening[:name],
                                                          start_date: screening[:start_date],
                                                          end_date: screening[:end_date])
      screening[:people].each do |person|
        screening_page.add_person_from_search(name: person[:name], additional_info: person[:dob])
        expect(page).to have_content person[:name]
        person_id = page.find('div[id^="participants-card-"]', text: person[:name])[:id].split('-').last
        screening_page.set_participant_attributes(person_id, roles: person[:roles])
      end
    end
  end

  it 'Displays screenings on the history card' do
    screening_page = ScreeningPage.new.visit
    screening_page.set_screening_information_attributes(name: scr1[:name],
                                                        start_date: scr1[:start_date],
                                                        end_date: scr1[:end_date])

    screening_page.add_person_from_search(name: person1[:name], additional_info: person1[:dob])

    within '#history-card' do
      expect(page).to have_css('thead > tr > th', text: 'Date')
      expect(page).to have_css('thead > tr > th', text: 'Type/Status')
      expect(page).to have_css('thead > tr > th', text: 'County/Office')
      expect(page).to have_css('thead > tr > th', text: 'People and Roles')

      expect(page).to have_screening(scr1)
      expect(page).to have_screening(scr5)
      expect(page).to have_screening(scr6)

      expect(page).not_to have_xpath("//td[contains(.,'" + scr2[:start_date] + "')]")
      expect(page).not_to have_xpath("//td[contains(.,'" + scr3[:start_date] + "')]")
      expect(page).not_to have_xpath("//td[contains(.,'" + scr4[:start_date] + "')]")
    end

    screening_page.add_person_from_search(name: person2[:name], additional_info: person2[:dob])
    within '#history-card' do
      expect(page).to have_screening(scr1)
      expect(page).to have_screening(scr2)
      expect(page).to have_screening(scr5)
      expect(page).to have_screening(scr6)

      expect(page).not_to have_xpath("//td[contains(.,'" + scr3[:start_date] + "')]")
      expect(page).not_to have_xpath("//td[contains(.,'" + scr4[:start_date] + "')]")
    end

    screening_page.add_person_from_search(name: person3[:name], additional_info: person3[:dob])
    within '#history-card' do
      expect(page).to have_screening(scr1)
      expect(page).to have_screening(scr2)
      expect(page).to have_screening(scr3)
      expect(page).to have_screening(scr5)
      expect(page).to have_screening(scr6)

      expect(page).not_to have_xpath("//td[contains(.,'" + scr4[:start_date] + "')]")
    end

    screening_page.add_person_from_search(name: person4[:name], additional_info: person4[:dob])
    within '#history-card' do
      expect(page).to have_screening(scr1)
      expect(page).to have_screening(scr2)
      expect(page).to have_screening(scr3)
      expect(page).to have_screening(scr4)
      expect(page).to have_screening(scr5)
      expect(page).to have_screening(scr6)
    end
  end
end
