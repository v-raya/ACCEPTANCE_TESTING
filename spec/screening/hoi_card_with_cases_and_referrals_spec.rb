# frozen_string_literal: true

require 'react_select_helpers'
require 'autocompleter_helpers'
require 'helper_methods'
require 'support/page/screening_page'

describe 'History Card with cases and referrals', type: :feature do
  let(:screening_page) { ScreeningPage.new }

  before do
    # visit '/'
    # login_user
    screening_page.visit
  end

  let(:shared_hoi_1) { { dob: '', name: 'Nina Tunkin', legacy_id: '1657-4651-9945-8000814' } }
  let(:shared_hoi_2) { { dob: '12/29/1995', name: 'Lawrence Bloschke', legacy_id: '0212-4560-3721-8000794' } }

  scenario 'copy button' do
    pending 'implemented but fails because work-around no longer works'
    screening_page.add_person_from_search(additional_info: shared_hoi_1[:dob], name: shared_hoi_1[:name])
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

  it 'does not display duplicate referrals for people who share history' do
    within '.container' do
      within '#history-card' do
        expect(page).to have_content 'Search for people and add them to see their child welfare history.'
      end

      screening_page.add_person_from_search(additional_info: shared_hoi_1[:dob], name: shared_hoi_1[:name])
      expect(page).to have_content shared_hoi_1[:name]

      within '#history-card' do
        expect(page).to have_no_content 'Search for people and add them to see their child welfare history.'
        first 'thead' do
          expect(page).to have_content 'Date'
          expect(page).to have_content 'Type/Status'
          expect(page).to have_content 'County/Office'
          expect(page).to have_content 'People and Roles'
        end

        tr = page.find(:xpath, ".//tr[./td[contains(., '0767-8360-2365-0000808')]]")

        expect(tr).to have_referral(
          start_date: '12/23/1998',
          referral_id: '0767-8360-2365-0000808',
          status: 'Open',
          county: 'Imperial',
          worker: 'South ER Supervisor ERSUP',
          allegations: [{
            victim: 'Lawrence Bloschke',
            perpetrator: 'Patricia Bigglestone',
            type: 'Caretaker Absence/Incapacity'
          }]
        )

        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 1
      end
    end

    within '.container' do
      screening_page.add_person_from_search(additional_info: shared_hoi_2[:dob], name: shared_hoi_2[:name])
      expect(page).to have_content shared_hoi_2[:name]

      within '#history-card' do
        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 1
      end
    end
  end

  let(:complete_referral) { { dob: '08/12/1994', name: 'Robert C Chaman', legacy_id: '0199-8095-0742-9001316' } }

  it 'displays a complete referral correctly' do
    screening_page.add_person_from_search(additional_info: complete_referral[:dob], name: complete_referral[:name])

    within '#history-card' do
      within 'table.table-hover' do
        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 3

        within referral_rows[2] do
          expect(page).to have_referral(
            start_date: '01/18/2001',
            end_date: '01/19/2001',
            status: 'Closed',
            referral_id: '1251-0655-3661-3001316',
            county: 'Imperial',
            response_time: '5 Day',
            worker: 'North ER Worker 2 ER2',
            allegations: [
              {
                victim: 'Robert Chaman',
                perpetrator: 'Emily Reinger',
                type: 'Physical Abuse',
                disposition: 'Substantiated'
              }, {
                victim: 'Alyssa Twamley',
                perpetrator: 'Emily Reinger',
                type: 'At Risk, sibling abused',
                disposition: 'Substantiated'
              }, {
                victim: 'Ty Gossart',
                perpetrator: 'Emily Reinger',
                type: 'At Risk, sibling abused',
                disposition: 'Substantiated'
              }
            ]
          )
        end
      end
    end
  end

  let(:complete_case) { { first_name: 'Robert', last_name: 'Chaman', legacy_id: '0199-8095-0742-9001316' } }

  it 'displays a complete case correctly' do
    full_name = "#{complete_case[:first_name]} C #{complete_case[:last_name]}"
    focus_name = "#{complete_case[:first_name]} #{complete_case[:last_name]}"
    screening_page.add_person_from_search(name: full_name)

    within '#history-card' do
      within 'table.table-hover' do
        case_rows = page.all('tr', text: 'Case')
        expect(case_rows.count).to eq 2

        within case_rows[1] do
          expect(page).to have_case(
            start_date: '01/18/2001',
            end_date: '01/19/2001',
            case_id: '1194-4391-5581-3001320',
            status: 'Closed',
            county: 'Imperial',
            service_component: 'Family Maintenance',
            focus_child: focus_name,
            parents: ['Robert Gilpillan', 'Emily Reinger'],
            worker: 'North ER Worker 2 ER2'
          )
        end
      end
    end
  end
end
