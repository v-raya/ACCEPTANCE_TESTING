# frozen_string_literal: true

require 'react_select_helpers'
require 'autocompleter_helpers'
require 'helper_methods'
require 'support/page/screening_page'

describe 'History Card with cases and referrals', type: :feature do
  let(:screening_page) { ScreeningPage.new }

  before do
    visit '/'
    login_user
    screening_page.visit_screening
  end

  let(:shared_hoi_1) { { dob: '1997-11-22', name: 'Marty R.', legacy_id: 'M5Xs0Xb0Bv' } }
  let(:shared_hoi_2) { { dob: '1979-07-24', name: 'Missy R.', legacy_id: 'N80EWpv0Bv' } }
  let(:shared_hoi_3) { { dob: '1967-02-24', name: 'Ricky W.', legacy_id: 'JdLgp760Bv' } }

  scenario 'copy button' do
    screening_page.add_person_from_search(shared_hoi_1[:dob], shared_hoi_1[:name])
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

      screening_page.add_person_from_search(shared_hoi_1[:dob], shared_hoi_1[:name])
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

        within '#referral-KftDS4J0Bv' do
          expect(page).to have_referral(start_date: '02/24/1999',
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
                                        }])
        end

        within '#referral-Tpe1rDI0Bv' do
          expect(page).to have_referral(
            start_date: '02/28/1999',
            end_date: '02/01/2000',
            status: 'Closed',
            county: 'Plumas',
            response_time: 'Immediate',
            worker: 'Daisie K',
            allegations: [
              {
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
              }
            ]
          )
        end

        within '#case-Evic91H0Bv' do
          expect(page).to have_case(
            start_date: '02/24/1999',
            status: 'Open',
            service_component: 'Family Reunification',
            county: 'Plumas',
            focus_child: 'Marty R.',
            parents: ['Ricky W.', 'Missy R.'],
            worker: 'Daisie K'
          )
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

      within '#history-of-involvement' do
        within '#case-DQ0ObR60Bv' do
          expect(page).to have_case(
            start_date: '02/28/1999',
            status: 'Open',
            service_component: 'Family Reunification',
            focus_child: 'Roland W.',
            parents: ['Ricky W.', 'Missy R.'],
            worker: 'Daisie K'
          )
        end

        within '#case-Evic91H0Bv' do
          expect(page).to have_case(
            start_date: '02/24/1999',
            status: 'Open',
            service_component: 'Family Reunification',
            focus_child: 'Marty R.',
            parents: ['Ricky W.', 'Missy R.'],
            worker: 'Daisie K'
          )
        end

        within '#case-LnC9V5Q0Bv' do
          expect(page).to have_case(
            start_date: '02/28/1999',
            status: 'Open',
            service_component: 'Family Reunification',
            focus_child: 'Sharon W.',
            parents: ['Ricky W.', 'Missy R.'],
            worker: 'Daisie K'
          )
        end

        expect('case-DQ0ObR60Bv').to be_before('case-Evic91H0Bv')
        expect('case-LnC9V5Q0Bv').to be_before('case-Evic91H0Bv')

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

  let(:open_referral) { { dob: '1955-03-31', first_name: 'Alex', legacy_id: '5YA8w0Q04Z' } }

  it 'displays an open referral correctly' do
    skip 'This test is intermittent'
    screening_page.add_person_from_search(open_referral[:dob], open_referral[:first_name])

    within '#history-of-involvement' do
      referral_rows = page.all('tr', text: 'Referral')
      expect(referral_rows.count).to eq 1

      within referral_rows[0] do
        expect(page).to have_referral(start_date: '05/08/1996',
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
                                      }])
      end
    end
  end

  let(:closed_case) { { dob: '1999-02-09', first_name: 'Bobby', legacy_id: 'ETSbL6a0Dv' } }

  it 'displays a closed case correctly' do
    screening_page.add_person_from_search(closed_case[:dob], closed_case[:first_name])

    within '#history-of-involvement' do
      case_rows = page.all('tr', text: 'Case')
      expect(case_rows.count).to eq 1

      within case_rows[0] do
        expect(page).to have_case(start_date: '01/25/2000',
                                  end_date: '09/26/2002',
                                  status: 'Closed',
                                  county: 'Monterey',
                                  service_component: 'Family Maintenance',
                                  focus_child: 'Bobby W.',
                                  parents: ['Dolly W.'],
                                  worker: 'Mary J')
      end
    end
  end

  let(:referral_with_reporter) { { dob: '2000-03-25', first_name: 'Jimmy', legacy_id: '6444XNo00E' } }

  it 'displays the reporter for referrals' do
    screening_page.add_person_from_search(referral_with_reporter[:dob], referral_with_reporter[:first_name])

    within '#history-of-involvement' do
      referral_rows = page.all('tr', text: 'Referral')
      expect(referral_rows.count).to eq 1

      within referral_rows[0] do
        expect(page).to have_referral(start_date: '03/25/2004',
                                      status: 'Open',
                                      county: 'State of California',
                                      response_time: '10 Day',
                                      worker: 'L S',
                                      allegations: [{
                                        victim: 'Jimmy M.',
                                        type: 'Physical Abuse',
                                        disposition: 'Pending decision'
                                      }])
      end
    end
  end
end
