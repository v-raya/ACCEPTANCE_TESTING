# frozen_string_literal: true

describe 'County Sealed user', type: :feature do
  let(:same_county_not_sensitive_not_sealed) { { first_name: 'Peter', middle_name: '', last_name: 'Gasticke' } }
  let(:same_county_sensitive_not_sealed) { { first_name: 'David', middle_name: 'Duggan', last_name: 'Parminter' } }
  let(:same_county_not_sensitive_sealed) { { first_name: 'Jared', middle_name: '', last_name: 'Readshaw' } }
  let(:different_county_sensitive_not_sealed) { { first_name: 'Sam', middle_name: 'Silly', last_name: 'Yitzhok' } }
  let(:different_county_not_sensitive_sealed) { { first_name: 'Arkadi', middle_name: '', last_name: 'Eate' } }
  let(:no_county_sensitive_not_sealed) { { first_name: 'Bud', middle_name: '', last_name: 'Swainger' } }
  let(:no_county_not_sensitive_sealed) { { first_name: 'asdf', middle_name: '', last_name: 'Orgill' } }

  describe '.privileges' do
    before do
      ScreeningPage.new.visit
    end

    describe 'return results from search' do
      it 'should attach people to Screening' do
        [same_county_not_sensitive_not_sealed, same_county_sensitive_not_sealed,
         same_county_not_sensitive_sealed, no_county_not_sensitive_sealed].each do |participant|
          search_name = full_name(first: participant[:first_name], last: participant[:last_name])
          select_name = full_name(first: participant[:first_name], middle: participant[:middle_name],
                                  last: participant[:last_name])

          puts search_name

          autocompleter_fill_in 'Search for any person', search_name
          wait_for_result_to_appear(element: 'div.autocomplete-menu div.profile-picture') do
            node = page.find('div.autocomplete-menu').first('strong.highlighted', text: select_name)
            interact_with_node(capybara_node: node, event: 'double_click')
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
      it 'should not be able to attach people to Screening' do
        [different_county_sensitive_not_sealed, no_county_sensitive_not_sealed].each do |participant|
          search_name = full_name(first: participant[:first_name], last: participant[:last_name])
          select_name = full_name(first: participant[:first_name], middle: participant[:middle_name],
                                  last: participant[:last_name])

          puts search_name

          autocompleter_fill_in 'Search for any person', search_name
          wait_for_result_to_appear(element: 'div.autocomplete-menu div.profile-picture') do
            node = page.find('div.autocomplete-menu').first('strong.highlighted', text: select_name)
            interact_with_node(capybara_node: node, event: 'double_click')
          end

          alert_text = page.driver.accept_modal(true)

          expect(alert_text).to eq 'You are not authorized to add this person.'
          within 'div.side-bar' do
            expect(page).not_to have_css('a.link', text: search_name)
          end

          within 'div#relationships-card' do
            expect(page).not_to have_css('span.person', text: select_name)
          end
        end
      end
    end

end
