# frozen_string_literal: true
require 'react_select_helpers'
require 'autocompleter_helpers'
require 'helper_methods'
require 'support/page/screening_page'

def build_regex(words)
  arr = words.map do |word|
    "(?=.*#{Regexp.quote(word)})"
  end
  Regexp.new(arr.join(''))
end

def elements_containing(element, *words)
  elements = page.all(element.to_s, text: build_regex(words))
  elements
end

describe 'Test for History of Involvement', type: :feature do

  context 'testing screenings' do
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
        screening_page = ScreeningPage.new
        screening_page.visit_screening

        expect(page).to have_content 'Screening #'
        screening_id = page.current_path.match(/\d+/)[0]
        screening[:id] = screening_id

        screening_page.set_screening_information_attributes({
          name: screening[:name],
          social_worker: screening[:worker],
          start_date: screening[:start_date],
          end_date: screening[:end_date],
        })
        screening_page.set_incident_information_attributes({
          incident_county: screening[:county]
        })
        screening[:people].each do |person|
          screening_page.add_person_from_search(person[:dob], person[:name])
          expect(page).to have_content person[:name]
          person_id = page.all('div[id^="participants-card-"]').first[:id].split('-').last
          screening_page.set_participant_attributes(person_id, {
            roles: person[:roles]
          })
        end
      end
    end

    it 'Displays screenings on the history card' do
      skip 'This test is intermittent'
      screening_page = ScreeningPage.new
      screening_page.visit_screening
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

  context 'Cases and Referrals in HOI' do
    let(:screening_page) { ScreeningPage.new }

    before do
      visit '/'
      login_user
      screening_page.visit_screening
    end

    let(:shared_hoi_1) { {dob: '1997-11-22', name: 'Marty R.', legacy_id: 'M5Xs0Xb0Bv'} }
    let(:shared_hoi_2) { {dob: '1979-07-24', name: 'Missy R.', legacy_id: 'N80EWpv0Bv'} }
    let(:shared_hoi_3) { {dob: '1967-02-24', name: 'Ricky W.', legacy_id: 'JdLgp760Bv'} }

    scenario 'copy button' do
      #
      # This test will need the History card to have contents.
      #
      # visit screening_path(id: existing_screening.id)
      within '#history-card.card.show', text: 'History' do
        click_button 'Copy'
      end
      #
      # Capybara has no way of checking the clipboard contents, so we insert a textarea
      # to this card to paste into and check the value.
      #
      js = [
        'var spec_meta = document.createElement("textarea")',
        'var label = document.createElement("label")',
        'label.setAttribute("for", "spec_meta")',
        'spec_meta.setAttribute("id", "spec_meta")',
        'document.getElementById("history-card").appendChild(spec_meta)',
        'document.getElementById("spec_meta").appendChild(label)'
      ].join(';')
      page.execute_script js
      paste_into '#spec_meta'
      expect(find('#spec_meta').value).to eq(first('#history-card table')[:innerText])
    end

    it 'does not display duplicate referrals and cases for people who share history' do
      within '#history-card table' do
        expect(page).to have_content 'Date'
        expect(page).to have_content 'Type/Status'
        expect(page).to have_content 'County/Office'
        expect(page).to have_content 'People and Roles'
      end

      within '.container' do
        screening_page.add_person_from_search(shared_hoi_1[:dob], shared_hoi_1[:name])
        expect(page).to have_content shared_hoi_1[:name]

        expect('referral-KftDS4J0Bv').to be_after('referral-Tpe1rDI0Bv')

        within '#history-of-involvement' do
          within '#referral-KftDS4J0Bv' do
            expect(page).to have_referral({
              start_date: '02/24/1999',
              end_date: '12/02/1999',
              status: 'Closed',
              county: 'Plumas',
              response_time: 'Immediate',
              worker: 'Daisie K',
              allegations: [{
                victim: 'Marty R.',
                perpetrator: 'Missy R.',
                type: 'Physical Abuse',
                disposition: 'Substantiated'
              }]
            })
          end

          within '#referral-Tpe1rDI0Bv' do
            expect(page).to have_referral({
              start_date: '02/28/1999',
              end_date: '02/01/2000',
              status: 'Closed',
              county: 'Plumas',
              response_time: 'Immediate',
              worker: 'Daisie K',
              allegations: [{
                victim: 'Sharon W.',
                perpetrator: 'Ricky W.',
                type: 'Sexual Abuse',
                disposition: 'Substantiated'
              }, {
                victim: 'Sharon W.',
                perpetrator: 'Roland W.',
                type: 'Sexual Abuse',
                disposition: 'Substantiated'
              }, {
                victim: 'Roland W.',
                type: 'Sexual Abuse',
                disposition: 'Substantiated'
              }, {
                victim: 'Marty R.',
                perpetrator: 'Missy R.',
                type: 'Sexual Abuse',
                disposition: 'Inconclusive'
              }]
            })
          end


          within '#case-Evic91H0Bv' do
            expect(page).to have_case({
              start_date: '02/24/1999',
              status: 'Open',
              service_component: 'Family Reunification',
              county: 'Plumas',
              focus_child: 'Marty R.',
              parents: ['Ricky W.', 'Missy R.'],
              worker: 'Daisie K'
            })
          end

          referral_rows = page.all('tr', text: 'Referral')
          expect(referral_rows.count).to eq 2

          case_rows = page.all('tr', text: 'Case')
          expect(case_rows.count).to eq 1
        end
      end

      within '.container' do
        screening_page.add_person_from_search(shared_hoi_2[:dob], shared_hoi_2[:name])
        expect(page).to have_content shared_hoi_2[:name]

        expect('case-DQ0ObR60Bv').to be_before('case-Evic91H0Bv')
        expect('case-LnC9V5Q0Bv').to be_before('case-Evic91H0Bv')

        within '#history-of-involvement' do
          within '#case-DQ0ObR60Bv' do
            expect(page).to have_case({
              start_date: '02/28/1999',
              status: 'Open',
              service_component: 'Family Reunification',
              focus_child: 'Roland W.',
              parents: ['Ricky W.', 'Missy R.'],
              worker: 'Daisie K'
            })
          end

          within '#case-Evic91H0Bv' do
            expect(page).to have_case({
              start_date: '02/24/1999',
              status: 'Open',
              service_component: 'Family Reunification',
              focus_child: 'Marty R.',
              parents: ['Ricky W.', 'Missy R.'],
              worker: 'Daisie K'
            })
          end

          within '#case-LnC9V5Q0Bv' do
            expect(page).to have_case({
              start_date: '02/28/1999',
              status: 'Open',
              service_component: 'Family Reunification',
              focus_child: 'Sharon W.',
              parents: ['Ricky W.', 'Missy R.'],
              worker: 'Daisie K'
            })
          end

          referral_rows = page.all('tr', text: 'Referral')
          expect(referral_rows.count).to eq 2

          case_rows = page.all('tr', text: 'Case')
          expect(case_rows.count).to eq 3
        end
      end

      within '.container' do
        screening_page.add_person_from_search(shared_hoi_3[:dob], shared_hoi_3[:name])
        expect(page).to have_content shared_hoi_3[:name]

        within '#history-of-involvement' do
          ['#case-DQ0ObR60Bv', '#case-Evic91H0Bv', '#case-LnC9V5Q0Bv'].each do |case_id|
            expect(page).to have_css case_id
          end

          ['#referral-Tpe1rDI0Bv', '#referral-KftDS4J0Bv'].each do |referral_id|
            expect(page).to have_css referral_id
          end

          referral_rows = page.all('tr', text: 'Referral')
          expect(referral_rows.count).to eq 2

          case_rows = page.all('tr', text: 'Case')
          expect(case_rows.count).to eq 3
        end
      end
    end

    let(:open_referral) { {dob: '1955-03-31', first_name: 'Alex', legacy_id: '5YA8w0Q04Z'} }

    it 'displays an open referral correctly' do
      skip 'This test is intermittent'
      screening_page.add_person_from_search(open_referral[:dob], open_referral[:first_name])

      within '#history-of-involvement' do
        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 1

        within referral_rows[0] do
          expect(page).to have_referral({
            start_date: '05/08/1996',
            status: 'Open',
            county: 'Modoc',
            response_time: 'Immediate',
            worker: 'Tester W',
            allegations: [{
              victim: 'Alexandra Z.',
              perpetrator: 'Alexandra Z.',
              type: 'Emotional Abuse',
              disposition: 'Pending decision'
            }, {
              victim: 'Alejandro Z.',
              perpetrator: 'Alexandra Z.',
              type: 'Severe Neglect',
              disposition: 'Pending decision'
            }, {
              victim: 'Alejandro Z.',
              perpetrator: 'Alejandro Z.',
              type: 'Physical Abuse',
              disposition: 'Pending decision'
            }]
          })
        end
      end
    end

    let(:closed_case) { {dob: '1999-02-09', first_name: 'Bobby', legacy_id: 'ETSbL6a0Dv'} }

    it 'displays a closed case correctly' do
      screening_page.add_person_from_search(closed_case[:dob], closed_case[:first_name])

      within '#history-of-involvement' do
        case_rows = page.all('tr', text: 'Case')
        expect(case_rows.count).to eq 1

        within case_rows[0] do
          expect(page).to have_case({
            start_date: '01/25/2000',
            end_date: '09/26/2002',
            status: 'Closed',
            county: 'Monterey',
            service_component: 'Family Maintenance',
            focus_child: 'Bobby W.',
            parents: ['Dolly W.'],
            worker: 'Mary J'
          })
        end
      end
    end

    let(:referral_with_reporter) { {dob: '2000-03-25', first_name: 'Jimmy', legacy_id: '6444XNo00E'} }

    it 'displays the reporter for referrals' do
      screening_page.add_person_from_search(referral_with_reporter[:dob], referral_with_reporter[:first_name])

      within '#history-of-involvement' do
        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 1

        within referral_rows[0] do
          expect(page).to have_referral({
            start_date: '03/25/2004',
            status: 'Open',
            county: 'State of California',
            response_time: '10 Day',
            worker: 'L S',
            allegations: [{
              victim: 'Jimmy M.',
              type: 'Physical Abuse',
              disposition: 'Pending decision'
            }]
          })
        end
      end
    end
  end
end
