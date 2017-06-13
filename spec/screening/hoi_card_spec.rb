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

  context 'Cases and Referrals in HOI' do
    let(:screening_page) { ScreeningPage.new }

    before do
      visit '/'
      login_user
      screening_page.visit_screening
    end

    let(:shared_hoi_1) { {dob: '1997-11-22', first_name: 'Marty', legacy_id: 'M5Xs0Xb0Bv'} }
    let(:shared_hoi_2) { {dob: '1979-07-24', first_name: 'Missy', legacy_id: 'N80EWpv0Bv'} }
    let(:shared_hoi_3) { {dob: '1967-02-24', first_name: 'Ricky', legacy_id: 'JdLgp760Bv'} }

    it 'does not display duplicate referrals and cases for people who share history' do
      within '#history-card table' do
        expect(page).to have_content 'Date'
        expect(page).to have_content 'Type/Status'
        expect(page).to have_content 'County/Office'
        expect(page).to have_content 'People and Roles'
      end

      screening_page.add_person_from_search(shared_hoi_1[:dob], shared_hoi_1[:first_name])

      within '#history-of-involvement' do
        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 2

        within referral_rows[0] do
          expect(page).to have_content '02/24/1999 - 12/02/1999'
          expect(page).to have_content 'Referral (Closed - Immediate)'
          expect(page).to have_content 'Plumas'
          expect(page).to have_content 'Victim Perpetrator Allegation(s) & Disposition'
          expect(page).to have_content 'Marty R. Missy R. Physical Abuse (Substantiated)'
          expect(page).to have_content 'Reporter: '
          expect(page).to have_content 'Worker: Daisie K'
        end

        within referral_rows[1] do
          expect(page).to have_content '02/28/1999 - 02/01/2000'
          expect(page).to have_content 'Referral (Closed - Immediate)'
          expect(page).to have_content 'Plumas'
          expect(page).to have_content 'Victim Perpetrator Allegation(s) & Disposition'
          expect(page).to have_content 'Sharon W. Ricky W. Sexual Abuse (Substantiated)'
          expect(page).to have_content 'Sharon W. Roland W. Sexual Abuse (Substantiated)'
          expect(page).to have_content 'Roland W. Sexual Abuse (Substantiated)'
          expect(page).to have_content 'Marty R. Missy R. Sexual Abuse (Inconclusive)'
          expect(page).to have_content 'Reporter: '
          expect(page).to have_content 'Worker: Daisie K'
        end

        case_rows = page.all('tr', text: 'Case')
        expect(case_rows.count).to eq 1

        within case_rows[0] do
          expect(page).to have_content '02/24/1999'
          expect(page).to have_content 'Case (Open - Family Reunification)'
          expect(page).to have_content 'Plumas'
          expect(page).to have_content 'Focus Child: Marty R.'
          expect(page).to have_content 'Parent(s): Ricky W., Missy R.'
          expect(page).to have_content 'Worker: Daisie K'
        end
      end

      screening_page.add_person_from_search(shared_hoi_2[:dob], shared_hoi_2[:first_name])

      within '#history-of-involvement' do
        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 2

        case_rows = page.all('tr', text: 'Case')
        expect(case_rows.count).to eq 3

        within case_rows[0] do
          expect(page).to have_content '02/28/1999'
          expect(page).to have_content 'Case (Open - Family Reunification)'
          expect(page).to have_content 'Plumas'
          expect(page).to have_content 'Focus Child: Roland W.'
          expect(page).to have_content 'Parent(s): Ricky W., Missy R.'
          expect(page).to have_content 'Worker: Daisie K'
        end

        within case_rows[1] do
          expect(page).to have_content '02/24/1999'
          expect(page).to have_content 'Case (Open - Family Reunification)'
          expect(page).to have_content 'Plumas'
          expect(page).to have_content 'Focus Child: Marty R.'
          expect(page).to have_content 'Parent(s): Ricky W., Missy R.'
          expect(page).to have_content 'Worker: Daisie K'
        end

        within case_rows[2] do
          expect(page).to have_content '02/28/1999'
          expect(page).to have_content 'Case (Open - Family Reunification)'
          expect(page).to have_content 'Plumas'
          expect(page).to have_content 'Focus Child: Sharon W.'
          expect(page).to have_content 'Parent(s): Ricky W., Missy R.'
          expect(page).to have_content 'Worker: Daisie K'
        end
      end

      screening_page.add_person_from_search(shared_hoi_3[:dob], shared_hoi_3[:first_name])

      within '#history-of-involvement' do
        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 2

        case_rows = page.all('tr', text: 'Case')
        expect(case_rows.count).to eq 3
      end
    end

    let(:open_referral) { {dob: '1955-03-31', first_name: 'Alex', legacy_id: '5YA8w0Q04Z'} }

    it 'displays an open referral correctly' do
      screening_page.add_person_from_search(open_referral[:dob], open_referral[:first_name])

      within '#history-of-involvement' do
        referral_rows = page.all('tr', text: 'Referral')
        expect(referral_rows.count).to eq 1

        within referral_rows[0] do
          expect(page).to have_content '05/08/1996'
          expect(page).to have_content 'Referral (Open - Immediate)'
          expect(page).to have_content 'Modoc'
          expect(page).to have_content 'Victim Perpetrator Allegation(s) & Disposition'
          expect(page).to have_content 'Alexandra Z. Alejandro Z. Emotional Abuse (Pending decision)'
          expect(page).to have_content 'Alejandro Z. Alexandra Z. Severe Neglect (Pending decision)'
          expect(page).to have_content 'Alejandro Z. Alejandro Z. Physical Abuse (Pending decision)'
          expect(page).to have_content 'Reporter: '
          expect(page).to have_content 'Worker: Tester W'
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
          expect(page).to have_content '01/25/2000 - 09/26/2002'
          expect(page).to have_content 'Case (Closed - Family Maintenance)'
          expect(page).to have_content 'Monterey'
          expect(page).to have_content 'Focus Child: Bobby W.'
          expect(page).to have_content 'Parent(s): Dolly W.'
          expect(page).to have_content 'Worker: Mary J'
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
          expect(page).to have_content '03/25/2004'
          expect(page).to have_content 'Referral (Open - 10 Day)'
          expect(page).to have_content 'State of California'
          expect(page).to have_content 'Victim Perpetrator Allegation(s) & Disposition'
          expect(page).to have_content 'Jimmy M. Physical Abuse (Pending decision)'
          expect(page).to have_content 'Reporter: Jimmm M.'
          expect(page).to have_content 'Worker: L S'
        end
      end
    end
  end
end
