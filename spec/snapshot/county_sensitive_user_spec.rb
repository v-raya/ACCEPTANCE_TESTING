# frozen_string_literal: true

describe 'A County Social Worker', type: :feature do
  user = COUNTY_SENSITIVE_SOCIAL_WORKER
  let(:different_county_not_sensitive_not_sealed) { Person.new(first_name: 'Peter', last_name: 'Gasticke') }
  let(:same_county_sensitive_not_sealed) { Person.new(first_name: 'Chatty', last_name: 'Naish') }
  let(:same_county_not_sensitive_sealed) { Person.new(first_name: 'Henry', last_name: 'Lowrie') }
  let(:different_county_sensitive_not_sealed) do
    Person.new(first_name: 'Sam', middle_name: 'Silly', last_name: 'Yitzhok')
  end
  let(:different_county_not_sensitive_sealed) { Person.new(first_name: 'Arkadi', last_name: 'Eate') }
  let(:no_county_sensitive_not_sealed) { Person.new(first_name: 'Bud', last_name: 'Swainger') }
  let(:no_county_not_sensitive_sealed) { Person.new(first_name: 'asdf', last_name: 'Orgill') }

  describe 'with Sensitive Persons' do
    before(:all) do
      login_user(user: user, path: snapshot_path)
    end

    describe 'privilege granted' do
      it 'should attach different_county_not_sensitive_not_sealed client' do
        search_client_and_select(label: 'Search for clients',
                                 query: different_county_not_sensitive_not_sealed.search_name,
                                 text: different_county_not_sensitive_not_sealed.full_name)

        within 'div.side-bar' do
          expect(page).to have_css('a.link', text: different_county_not_sensitive_not_sealed.search_name)
        end

        within 'div#relationships-card' do
          expect(page).to have_css('span.person', text: different_county_not_sensitive_not_sealed.full_name)
        end
      end

      it 'should be able to attach same_county_sensitive_not_sealed client' do
        search_client_and_select(label: 'Search for clients',
                                 query: same_county_sensitive_not_sealed.search_name,
                                 text: same_county_sensitive_not_sealed.full_name)

        within 'div.side-bar' do
          expect(page).to have_css('a.link', text: same_county_sensitive_not_sealed.search_name)
        end

        within 'div#relationships-card' do
          expect(page).to have_css('span.person', text: same_county_sensitive_not_sealed.full_name)
        end
      end

      it 'should be able to attach no_county_sensitive_not_sealed client' do
        search_client_and_select(label: 'Search for clients',
                                 query: no_county_sensitive_not_sealed.search_name,
                                 text: no_county_sensitive_not_sealed.full_name)

        within 'div.side-bar' do
          expect(page).to have_css('a.link', text: no_county_sensitive_not_sealed.search_name)
        end

        within 'div#relationships-card' do
          expect(page).to have_css('span.person', text: no_county_sensitive_not_sealed.full_name)
        end
      end

      it 'should not be able to see same_county_not_sensitive_sealed client' do
        search_client(label: 'Search for clients', query: same_county_not_sensitive_sealed.search_name)
        node = find('strong', text: /#{same_county_not_sensitive_sealed.full_name}/)

        expect(node.text).to eq "No results were found for \"#{same_county_not_sensitive_sealed.full_name}\""
      end

      it 'should not be able to see different_county_not_sensitive_sealed client' do
        search_client(label: 'Search for clients', query: different_county_not_sensitive_sealed.search_name)
        node = find('strong', text: /#{different_county_not_sensitive_sealed.full_name}/)

        expect(node.text).to eq "No results were found for \"#{different_county_not_sensitive_sealed.full_name}\""
      end

      it 'should not be able to see no_county_not_sensitive_sealed client' do
        search_client(label: 'Search for clients', query: no_county_not_sensitive_sealed.search_name)
        node = find('strong', text: /#{no_county_not_sensitive_sealed.full_name}/)

        expect(node.text).to eq "No results were found for \"#{no_county_not_sensitive_sealed.full_name}\""
      end
    end

    describe 'privilege revoked', user: user, path: snapshot_path do
      it 'should not be able to attach different_county_sensitive_not_sealed client' do
        alert_text = accept_alert do
          search_client_and_select(label: 'Search for clients',
                                   query: different_county_sensitive_not_sealed.search_name,
                                   text: different_county_sensitive_not_sealed.full_name)
        end

        expect(alert_text).to eq 'You are not authorized to add this person.'
        within 'div.side-bar' do
          expect(page).not_to have_css('a.link', text: different_county_sensitive_not_sealed.search_name)
        end

        within 'div#relationships-card' do
          expect(page).not_to have_css('span.person', text: different_county_sensitive_not_sealed.full_name)
        end
      end
    end
  end
end
