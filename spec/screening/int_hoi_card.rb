# frozen_string_literal: true

require 'react_select_helpers'
require 'autocompleter_helpers'
require 'helper_methods'
require 'support/page/screening_page'

describe 'Integration history card', type: :feature do
  let(:screening_page) { ScreeningPage.new }

  before do
    screening_page.visit
  end

  let(:shared_hoi_1) { { name: 'Kelly Cafe' } }
  let(:shared_hoi_2) { { name: 'Brian Beere' } }
  let(:shared_hoi_3) { { name: 'Al Giannotti' } }

  scenario 'copy button' do
    screening_page.add_person_from_search(name: shared_hoi_1[:name])
    within '#history-card' do
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
    within '.container' do
      within '#history-card' do
        expect(page).to have_content 'Search for people and add them to see their child welfare history.'
      end

      screening_page.add_person_from_search(name: shared_hoi_1[:name])
      expect(page).to have_content shared_hoi_1[:name]

      within '#history-card' do
        first 'thead' do
          expect(page).to have_content 'Date'
          expect(page).to have_content 'Type/Status'
          expect(page).to have_content 'County/Office'
          expect(page).to have_content 'People and Roles'
        end
      end

      within '#history-of-involvement' do
        expect('referral-KftDS4J0Bv').to be_after('referral-Tpe1rDI0Bv')

        within '.referral', text: '0455-9891-4364-9000037' do
          expect(page).to have_referral(start_date: '09/02/1997',
                                        end_date: '09/02/1997',
                                        referral_id: '0455-9891-4364-9000037',
                                        status: 'Closed',
                                        county: 'Santa Clara',
                                        response_time: '3 Day',
                                        worker: '10 Papcs',
                                        allegations: [{
                                          victim: 'Kelly Cafe',
                                          perpetrator: 'Al Giannotti',
                                          type: 'Exploitation',
                                          disposition: 'Substantiated'
                                        }, {
                                          victim: 'Brian Beere',
                                          perpetrator: 'Al Giannotti',
                                          type: 'General Neglect',
                                          disposition: 'Substantiated'
                                        }, {
                                          victim: 'Kelly Cafe',
                                          perpetrator: 'Peggy Devany',
                                          type: 'General Neglect',
                                          disposition: 'Substantiated'
                                        }, {
                                          victim: 'Kelly Cafe',
                                          perpetrator: 'Al Giannotti',
                                          type: 'General Neglect',
                                          disposition: 'Substantiated'
                                        }, {
                                          victim: 'Brian Beere',
                                          perpetrator: 'Peggy Devany',
                                          type: 'General Neglect',
                                          disposition: 'Substantiated'
                                        }])
        end

        within '.case', text: '1703-5514-4508-9000037' do
          expect(page).to have_case(
            start_date: '09/02/1997',
            end_date: '03/20/1998',
            status: 'Closed',
            case_id: '1703-5514-4508-9000037',
            service_component: 'Emergency Response',
            county: 'Santa Clara',
            focus_child: 'Kelly Cafe',
            parents: ['Al Giannotti', 'Peggy Devany'],
            worker: '10 Papcs'
          )
        end

        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 1

        case_rows = page.all('tr', text: 'Case')
        expect(case_rows.count).to eq 1
      end
    end

    within '.container' do
      screening_page.add_person_from_search(name: shared_hoi_2[:name])
      expect(page).to have_content shared_hoi_2[:name]

      within '#history-of-involvement' do
        within '.case', text: '0774-0391-8013-0000004' do
          expect(page).to have_case(
            start_date: '04/09/1998',
            end_date: '04/24/1998',
            status: 'Closed',
            case_id: '0774-0391-8013-0000004',
            service_component: 'Emergency Response',
            county: 'Santa Clara',
            focus_child: 'Brian Beere',
            parents: ['Al Giannotti', 'Peggy Devany'],
            worker: 'Possiel Pat'
          )
        end

        within '.case', text: '0435-9950-2755-3000037' do
          expect(page).to have_case(
            start_date: '09/02/1997',
            end_date: '03/20/1998',
            status: 'Closed',
            case_id: '0435-9950-2755-3000037',
            service_component: 'Permanent Placement',
            county: 'Santa Clara',
            focus_child: 'Brian Beere',
            parents: ['Al Giannotti', 'Peggy Devany'],
            worker: '10 Papcs'
          )
        end

        expect('.case', text: '0774-0391-8013-0000004').to be_before('.case', text: '0435-9950-2755-3000037')
        expect('.case', text: '0435-9950-2755-3000037').to be_before('.case', text: '1703-5514-4508-9000037')

        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 1

        case_rows = page.all('tr', text: 'Case')
        expect(case_rows.count).to eq 3
      end
    end

    within '.container' do
      screening_page.add_person_from_search(name: shared_hoi_3[:name])
      expect(page).to have_content shared_hoi_3[:name]

      within '#history-of-involvement' do
        ['0774-0391-8013-0000004', '0435-9950-2755-3000037', '1703-5514-4508-9000037'].each do |case_id|
          expect(page).to have_content case_id
        end

        ['0455-9891-4364-9000037'].each do |referral_id|
          expect(page).to have_content referral_id
        end

        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 1

        case_rows = page.all('tr', text: 'Case')
        expect(case_rows.count).to eq 3
      end
    end
  end

  let(:open_referral) { { name: 'Tiny Tim Paris' } }
  it 'displays an open referral correctly' do
    skip 'This test is intermittent'
    screening_page.add_person_from_search(name: open_referral[:name])
    expect(page).to have_content open_referral[:name]

    within '#history-of-involvement' do
      referral_rows = page.all('tr', text: 'Referral')
      expect(referral_rows.count).to eq 2

      within '.referral', text: '0551-2757-0211-5000739' do
        expect(page).to have_referral(start_date: '08/26/1999',
                                      status: 'Open',
                                      referral_id: '0551-2757-0211-5000739',
                                      county: 'Plumas',
                                      worker: 'Daisie Knowles',
                                      allegations: [{
                                        victim: 'Tonya Doche',
                                        type: 'Caretaker Absence/Incapacity'
                                      }, {
                                        victim: 'Tiny Tim Paris',
                                        type: 'Caretaker Absence/Incapacity'
                                      }])
      end

      within '.referral', text: '0109-9381-9017-9000739' do
        expect(page).to have_referral(start_date: '06/07/1999',
                                      status: 'Open',
                                      referral_id: '0551-2757-0211-5000739',
                                      county: 'Plumas',
                                      worker: 'Daisie Knowles',
                                      allegations: [{
                                        victim: 'Tonya Doche',
                                        perpetrator: 'Tommy Langrish',
                                        type: 'Physical Abuse'
                                      }, {
                                        victim: 'Tiny Tim Paris',
                                        perpetrator: 'Tommy Langrish',
                                        type: 'At Risk, sibling abused'
                                      }])
      end
    end
  end

  let(:open_case) { { name: 'Johnny Berthouloume' } }
  it 'displays an open case correctly' do
    screening_page.add_person_from_search(name: open_case[:name])
    expect(page).to have_content open_case[:name]

    within '#history-of-involvement' do
      case_rows = page.all('tr', text: 'Case')
      expect(case_rows.count).to eq 1

      within '.case', text: '1271-4424-4976-2000119' do
        expect(page).to have_case(start_date: '06/02/1998',
                                  case_id: '1271-4424-4976-2000119',
                                  status: 'Open',
                                  county: 'Butte',
                                  service_component: 'Permanent Placement',
                                  focus_child: 'Johnny Berthouloume',
                                  parents: ['Mom MacCrossan', 'Mom Llywarch'],
                                  worker: 'Branch Branch')
      end
    end
  end

  let(:referral_with_reporter) { { name: 'Sally Heathcoat' } }
  it 'displays the reporter for referrals' do
    screening_page.add_person_from_search(name: referral_with_reporter[:name])
    expect(page).to have_content referral_with_reporter[:name]

    within '#history-of-involvement' do
      referral_rows = page.all('tr', text: 'Referral')
      expect(referral_rows.count).to eq 1

      within '.referral', text: '1080-6973-5049-9000631' do
        expect(page).to have_referral(
          start_date: '10/14/1998',
          referral_id: '1080-6973-5049-9000631',
          status: 'Open',
          county: 'San Diego',
          worker: 'Kay Riley',
          reporter: 'Alexander Wilson',
          allegations: [{
            victim: 'Sally Heathcoat',
            perpetrator: 'Walter Trimmill',
            type: 'Physical Abuse'
          }, {
            victim: 'Mark Mordy',
            perpetrator: 'Walter Trimmill',
            type: 'Physical Abuse'
          }, {
            victim: 'Carin Riccard',
            perpetrator: 'Walter Trimmill',
            type: 'Physical Abuse'
          }]
        )
      end
    end
  end
end
