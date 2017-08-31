# frozen_string_literal: true

require 'react_select_helpers'
require 'autocompleter_helpers'
require 'helper_methods'
require 'support/page/screening_page'

describe 'History Card with screenings', type: :feature do
  person1 = { dob: '1994-08-28', name: 'Kerrie A.', id: 'BOXzjJm0Mu', roles: ['Victim'] }
  person2 = { dob: '1999-10-24', name: 'Penny B.', id: '  BiuWhGQ0Dv', roles: ['Perpetrator'] }
  person3 = { dob: '2001-11-01', name: 'Jonney Q.', id: 'AKgQavu07n', roles: ['Non-mandated Reporter', 'Perpetrator'] }
  person4 = { dob: '1987-09-01', name: 'Rocky O.', id: 'BOCMS8p0Mb', roles: ['Victim', 'Mandated Reporter'] }

  scr1 = {
    name: 'Harry1',
    worker: "Florence Nightingale #{Time.now.to_i}",
    start_date: '02/01/2015',
    end_date: '01/02/2016',
    status: 'Closed',
    people: [person1],
    people_names: [person1[:name]]
  }

  scr2 = {
    name: 'Harry2',
    worker: "Flying Nun #{Time.now.to_i}",
    start_date: '02/03/2015',
    end_date: '02/03/2016',
    status: 'Closed',
    people: [person2, person3],
    people_names: [person3[:name], person2[:name]],
    reporter: person3[:name]
  }

  scr3 = {
    name: 'Trin',
    worker: "Mother Terri #{Time.now.to_i}",
    start_date: '03/04/2015',
    status: 'In Progress',
    county: 'Amador',
    people: [person3],
    people_names: [person3[:name]],
    reporter: person3[:name]
  }

  scr4 = {
    name: 'Bay',
    worker: "Jan Brady #{Time.now.to_i}",
    start_date: '2015-05-06',
    status: 'In Progress',
    county: 'Butte',
    people: [person4],
    people_names: [person4[:name]],
    reporter: person4[:name]
  }

  scr5 = {
    name: 'Trin&BayShared',
    worker: "Marcia Brady #{Time.now.to_i}",
    start_date: '06/07/2015',
    end_date: '06/07/2016',
    status: 'Closed',
    county: 'Del Norte',
    people: [person1, person2],
    people_names: [person2[:name], person1[:name]]
  }

  scr6 = {
    name: 'Trin&BaySharedAgain',
    worker: "Tom Brady  #{Time.now.to_i}",
    start_date: '07/08/2015',
    status: 'In Progress',
    county: 'Sacramento',
    people: [person1, person2],
    people_names: [person2[:name], person1[:name]]
  }

  before do
    skip 'This test is intermittent'
    visit '/'
    login_user

    screenings = [scr1, scr2, scr3, scr4, scr5, scr6]
    screenings.each do |screening|
      screening_page = ScreeningPage.new.visit

      expect(page).to have_content 'Screening #'
      screening_id = page.current_path.match(/\d+/)[0]
      screening[:id] = screening_id

      screening_page.set_screening_information_attributes(name: screening[:name],
                                                          social_worker: screening[:worker],
                                                          start_date: screening[:start_date],
                                                          end_date: screening[:end_date])
      screening_page.set_incident_information_attributes(incident_county: screening[:county])
      screening[:people].each do |person|
        screening_page.add_person_from_search(person[:dob], person[:name])
        expect(page).to have_content person[:name]
        person_id = page.all('div[id^="participants-card-"]').first[:id].split('-').last
        screening_page.set_participant_attributes(person_id, roles: person[:roles])
      end
    end
  end

  it 'Displays screenings on the history card' do
    skip 'This test is intermittent'
    screening_page = ScreeningPage.new.visit
    sleep 60

    screening_page.add_person_from_search(person1[:dob], person1[:name])
    within '#history-card' do
      within 'thead' do
        expect(page).to have_content('Date')
        expect(page).to have_content('Type/Status')
        expect(page).to have_content('County/Office')
        expect(page).to have_content('People and Roles')
      end

      within 'tbody' do
        within "#screening-#{scr1[:id]}" do
          expect(page).to have_screening(scr1)
        end

        within "#screening-#{scr5[:id]}" do
          expect(page).to have_screening(scr5)
        end

        within "#screening-#{scr6[:id]}" do
          expect(page).to have_screening(scr6)
        end

        expect(page).not_to have_css("#screening-#{scr2[:id]}")
        expect(page).not_to have_css("#screening-#{scr3[:id]}")
        expect(page).not_to have_css("#screening-#{scr4[:id]}")
      end
    end

    screening_page.add_person_from_search(person2[:dob], person2[:name])
    within '#history-card' do
      within "#screening-#{scr1[:id]}" do
        expect(page).to have_screening(scr1)
      end

      within "#screening-#{scr2[:id]}" do
        expect(page).to have_screening(scr2)
      end

      within "#screening-#{scr6[:id]}" do
        expect(page).to have_screening(scr6)
      end

      within "#screening-#{scr5[:id]}" do
        expect(page).to have_screening(scr5)
      end

      expect(page).not_to have_css("#screening-#{scr3[:id]}")
      expect(page).not_to have_css("#screening-#{scr4[:id]}")
    end

    screening_page.add_person_from_search(person3[:dob], person3[:name])
    within '#history-card' do
      within "#screening-#{scr1[:id]}" do
        expect(page).to have_screening(scr1)
      end

      within "#screening-#{scr2[:id]}" do
        expect(page).to have_screening(scr2)
      end

      within "#screening-#{scr3[:id]}" do
        expect(page).to have_screening(scr3)
      end

      within "#screening-#{scr6[:id]}" do
        expect(page).to have_screening(scr6)
      end

      within "#screening-#{scr5[:id]}" do
        expect(page).to have_screening(scr5)
      end

      expect(page).not_to have_css("#screening-#{scr4[:id]}")
    end

    screening_page.add_person_from_search(person3[:dob], person3[:name])
    within '#history-card' do
      within "#screening-#{scr1[:id]}" do
        expect(page).to have_screening(scr1)
      end

      within "#screening-#{scr2[:id]}" do
        expect(page).to have_screening(scr2)
      end

      within "#screening-#{scr3[:id]}" do
        expect(page).to have_screening(scr3)
      end

      within "#screening-#{scr4[:id]}" do
        expect(page).to have_screening(scr4)
      end

      within "#screening-#{scr6[:id]}" do
        expect(page).to have_screening(scr6)
      end

      within "#screening-#{scr5[:id]}" do
        expect(page).to have_screening(scr5)
      end
    end
  end
end
