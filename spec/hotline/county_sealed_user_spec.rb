# frozen_string_literal: true

describe 'County Sealed user', type: :feature do
  ENV['ACCEPTANCE_TEST_USER'] = {
    "user": 'CLUSTR',
    "staffId": '0UX',
    "roles": ['SocialWorker'],
    "county_code": '34',
    "county_cws_code": '1101',
    "county_name": 'Sacramento',
    "privileges": ['CWS Case Management System', 'Sealed']
  }.to_json

  let(:same_county_not_sensitive_not_sealed) { { first_name: 'Peter', middle_name: '', last_name: 'Gasticke' } }
  let(:same_county_sensitive_not_sealed) { { first_name: 'David', middle_name: 'Duggan', last_name: 'Parminter' } }
  let(:same_county_not_sensitive_sealed) { { first_name: 'Jared', middle_name: '', last_name: 'Readshaw' } }
  let(:different_county_sensitive_not_sealed) { { first_name: 'Sam', middle_name: 'Silly', last_name: 'Yitzhok' } }
  let(:different_county_not_sensitive_sealed) { { first_name: 'Arkadi', middle_name: '', last_name: 'Eate' } }
  let(:no_county_sensitive_not_sealed) { { first_name: 'Bud', middle_name: '', last_name: 'Swainger' } }
  let(:no_county_not_sensitive_sealed) { { first_name: 'asdf', middle_name: '', last_name: 'Orgill' } }

  describe '.privileges' do
    before do
      ScreeningPage.new(id: 1).visit
    end

    describe 'return results from search' do
      it 'should attach people to Screening' do
        [same_county_not_sensitive_not_sealed, same_county_not_sensitive_sealed,
         no_county_not_sensitive_sealed].each do |participant|

          search_name = full_name(first: participant[:first_name], last: participant[:last_name])
          select_name = full_name(first: participant[:first_name], middle: participant[:middle_name],
                                  last: participant[:last_name])

          autocompleter_fill_in 'Search for any person', search_name
          wait_for_result_to_appear do
            find('strong.highlighted', text: select_name).click
          end

          within 'div.side-bar' do
            expect(page).to have_css('a.link', text: search_name)
          end

          within 'div#relationships-card' do
            expect(page).to have_css('span.person', text: select_name)
          end
        end
      end
    end

    describe 'return results from search' do
      it 'should not be able to attach same_county_sensitive_not_sealed to Screening' do
        search_name = full_name(first: same_county_sensitive_not_sealed[:first_name],
                                last: same_county_sensitive_not_sealed[:last_name])
        select_name = full_name(first: same_county_sensitive_not_sealed[:first_name],
                                middle: same_county_sensitive_not_sealed[:middle_name],
                                last: same_county_sensitive_not_sealed[:last_name])

        autocompleter_fill_in 'Search for any person', search_name
        alert_text = accept_alert do
          wait_for_result_to_appear do
            find('strong.highlighted', text: select_name).click
          end
        end

        expect(alert_text).to eq 'You are not authorized to add this person.'
        within 'div.side-bar' do
          expect(page).not_to have_css('a.link', text: search_name)
        end

        within 'div#relationships-card' do
          expect(page).not_to have_css('span.person', text: select_name)
        end
      end

      it 'should not be able to attach different_county_sensitive_not_sealed to Screening' do
        search_name = full_name(first: different_county_sensitive_not_sealed[:first_name],
                                last: different_county_sensitive_not_sealed[:last_name])
        select_name = full_name(first: different_county_sensitive_not_sealed[:first_name],
                                middle: different_county_sensitive_not_sealed[:middle_name],
                                last: different_county_sensitive_not_sealed[:last_name])

        autocompleter_fill_in 'Search for any person', search_name
        alert_text = accept_alert do
          wait_for_result_to_appear do
            find('strong.highlighted', text: select_name).click
          end
        end

        expect(alert_text).to eq 'You are not authorized to add this person.'
        within 'div.side-bar' do
          expect(page).not_to have_css('a.link', text: search_name)
        end

        within 'div#relationships-card' do
          expect(page).not_to have_css('span.person', text: select_name)
        end
      end

      it 'should not be able to attach people to Screening' do
        search_name = full_name(first: no_county_sensitive_not_sealed[:first_name],
                                last: no_county_sensitive_not_sealed[:last_name])
        select_name = full_name(first: no_county_sensitive_not_sealed[:first_name],
                                middle: no_county_sensitive_not_sealed[:middle_name],
                                last: no_county_sensitive_not_sealed[:last_name])

        autocompleter_fill_in 'Search for any person', search_name
        alert_text = accept_alert do
          wait_for_result_to_appear do
            find('strong.highlighted', text: select_name).click
          end
        end

        expect(alert_text).to eq 'You are not authorized to add this person.'
        within 'div.side-bar' do
          expect(page).not_to have_css('a.link', text: search_name)
        end

        within 'div#relationships-card' do
          expect(page).not_to have_css('span.person', text: select_name)
        end
      end
    end

    describe 'return not results from search' do
      it 'should not be able to attach people to Screening' do
        [different_county_not_sensitive_sealed].each do |participant|
          search_name = full_name(first: participant[:first_name], last: participant[:last_name])
          select_name = full_name(first: participant[:first_name], middle: participant[:middle_name],
                                  last: participant[:last_name])

          autocompleter_fill_in 'Search for any person', search_name
          wait_for_result_to_appear do
            @node = find('strong', text: /#{select_name}/)
          end

          expect(@node.text).to eq "No results were found for \"#{select_name}\""
        end
      end
    end
  end
end
