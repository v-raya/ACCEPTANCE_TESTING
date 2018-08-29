# frozen_string_literal: true

describe 'A County Social Worker', type: :feature do
  user = COUNTY_SEALED_SOCIAL_WORKER
  let(:same_county_not_sensitive_not_sealed) { Person.new(first_name: 'Peter', last_name: 'Gasticke') }
  let(:same_county_sensitive_not_sealed) do
    Person.new(first_name: 'David', middle_name: 'Duggan', last_name: 'Parminter')
  end
  let(:same_county_not_sensitive_sealed) { Person.new(first_name: 'Jared', last_name: 'Readshaw') }
  let(:different_county_sensitive_not_sealed) do
    Person.new(first_name: 'Sam', middle_name: 'Silly', last_name: 'Yitzhok')
  end
  let(:different_county_not_sensitive_sealed) { Person.new(first_name: 'Arkadi', last_name: 'Eate') }
  let(:no_county_sensitive_not_sealed) { Person.new(first_name: 'Bud', last_name: 'Swainger') }
  let(:no_county_not_sensitive_sealed) { Person.new(first_name: 'asdf', last_name: 'Orgill') }

  describe 'with Sealed' do
    before(:all) do
      login_user(user: user, path: snapshot_path)
    end

    describe 'privilege granted' do
      it 'should attach same_county_not_sensitive_not_sealed client' do
        search_client(query: same_county_not_sensitive_not_sealed.search_name)
        select_client(text: same_county_not_sensitive_not_sealed.full_name)

        within('div.side-bar') do
          expect(page).to \
            have_css('div.side-bar a.link',
                     text: same_county_not_sensitive_not_sealed.search_name)
        end

        within('div#relationships-card') do
          expect(page).to \
            have_css('.card-body', text: "#{same_county_not_sensitive_not_sealed.full_name} is the...")
        end

        within('div#history-card') do
          expect(page).to have_css('table')
        end
      end

      it 'should attach relation for same_county_not_sensitive_not_sealed' do
        first('div#relationships-card a', text: 'Attach').click

        within('div#relationships-card') do
          expect(page).to \
            have_css('span', text: "of #{same_county_not_sensitive_not_sealed.full_name}")
        end
      end

      it 'should remove same_county_not_sensitive_not_sealed' do
        first('div.card-header h2', text: same_county_not_sensitive_not_sealed.full_name)
          .find(:xpath, '../..').click_button('Remove')

        expect(page).not_to have_css('div.side-bar a.link', text: same_county_not_sensitive_not_sealed.search_name)

        within('div#relationships-card') do
          expect(page).not_to \
            have_css('.card-body', text: "#{same_county_not_sensitive_not_sealed.full_name} is the...")
        end

        within('div#history-card') do
          expect(page).not_to have_css('table')
        end
      end

      it 'should attach same_county_not_sensitive_sealed client' do
        search_client(query: same_county_not_sensitive_sealed.search_name)
        select_client(text: same_county_not_sensitive_sealed.full_name)

        side_bar_link = find('div.side-bar a.link', text: same_county_not_sensitive_sealed.search_name)
        expect(side_bar_link).to be_present

        relation_card = find('div#relationships-card .card-body',
                             text: "#{same_county_not_sensitive_sealed.full_name} is the...")
        expect(relation_card).to be_present
      end

      it 'should attach no_county_not_sensitive_sealed client' do
        search_client(query: no_county_not_sensitive_sealed.search_name)
        select_client(text: no_county_not_sensitive_sealed.full_name)

        within('div.side-bar') do
          expect(page).to have_css('div.side-bar a.link', text: no_county_not_sensitive_sealed.search_name)
        end

        within('div#relationships-card') do
          expect(page).to \
            have_css('.card-body',
                     text: "#{no_county_not_sensitive_sealed.full_name} has no known relationships")
        end
      end

      it 'should not be able to attach different_county_not_sensitive_sealed client' do
        search_client(query: different_county_not_sensitive_sealed.search_name)
        node = find('strong', text: /#{different_county_not_sensitive_sealed.full_name}/)

        expect(node.text).to eq "No results were found for \"#{different_county_not_sensitive_sealed.full_name}\""
      end
    end

    describe 'privilege revoked', user: user, path: snapshot_path do
      it 'should not be able to attach same_county_sensitive_not_sealed client' do
        alert_text = accept_alert do
          search_client(query: same_county_sensitive_not_sealed.search_name)
          select_client(text: same_county_sensitive_not_sealed.full_name)
        end

        expect(alert_text).to eq 'You are not authorized to add this person.'
        within 'div.side-bar' do
          expect(page).not_to have_css('a.link', text: same_county_sensitive_not_sealed.search_name)
        end

        within 'div#relationships-card' do
          expect(page).to have_css('span.person', text: same_county_sensitive_not_sealed.full_name)
        end

        expect(page).to have_no_table('div#history-card')
      end

      it 'should not be able to attach different_county_sensitive_not_sealed client' do
        alert_text = accept_alert do
          search_client(query: different_county_sensitive_not_sealed.search_name)
          select_client(text: different_county_sensitive_not_sealed.full_name)
        end

        expect(alert_text).to eq 'You are not authorized to add this person.'
        within 'div.side-bar' do
          expect(page).not_to have_css('a.link', text: different_county_sensitive_not_sealed.search_name)
        end

        within 'div#relationships-card' do
          expect(page).not_to have_css('span.person', text: different_county_sensitive_not_sealed.full_name)
        end
      end

      it 'should not be able to attach no_county_sensitive_not_sealed client' do
        alert_text = accept_alert do
          search_client(query: no_county_sensitive_not_sealed.search_name)
          select_client(text: no_county_sensitive_not_sealed.full_name)
        end

        expect(alert_text).to eq 'You are not authorized to add this person.'
        within 'div.side-bar' do
          expect(page).not_to have_css('a.link', text: no_county_sensitive_not_sealed.search_name)
        end

        within 'div#relationships-card' do
          expect(page).not_to have_css('span.person', text: no_county_sensitive_not_sealed.full_name)
        end
      end
    end
  end
end
