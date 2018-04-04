# frozen_string_literal: true

describe 'Relationship card QA test', type: :feature do
  billy = { first_name: 'Billy', last_name: 'Treppas', relationship: 'Sister', relationship_type: '(Half)' }
  joe   = { first_name: 'Joe', last_name: 'Atkyns', relationship: 'Daughter', relationship_type: '(Alleged)' }
  larry = { first_name: 'Larry', last_name: 'Felgat', relationship: 'Brother', relationship_type: '' }
  phil  = { first_name: 'Phil', last_name: 'Bartoleyn', relationship: 'Sister', relationship_type: '(Half)' }
  grandpa = {
    first_name: 'Grandpa',
    last_name: 'Preece',
    relationship: 'Granddaughter',
    relationship_type: '(Paternal)',
    relationships: [
      billy.merge(relationship: 'Grandparen', relationship_type: '(Paternal)'),
      joe.merge(relationship: 'Father', relationship_type: '(Birth)'),
      larry.merge(relationship: 'Grandparen', relationship_type: '(Paternal)'),
      phil.merge(relationship: 'No Relation', relationship_type: '')
    ]
  }
  lucy = {
    first_name: 'Lucy',
    middle_name: 'Lee',
    last_name: 'Gaspar',
    relationships: [billy, joe, grandpa, larry, phil]
  }
  grandpa[:relationships].push(lucy.merge(relationship: 'Grandparent', relationship_type: '(Paternal)'))

  grandpa_name = full_name(first: grandpa[:first_name],
                           middle: grandpa[:middle_name],
                           last: grandpa[:last_name])

  lucy_name = full_name(first: lucy[:first_name],
                        middle: lucy[:middle_name],
                        last: lucy[:last_name])

  before(:each) do
    ScreeningPage.new.visit
    autocompleter_fill_in('Search for any person', "#{lucy[:first_name]} #{lucy[:last_name]}")
    wait_for_result_to_appear(element: 'div.autocomplete-menu div.profile-picture') do
      page.find('div.autocomplete-menu').first('strong.highlighted', text: lucy_name).double_click
    end
  end

  describe 'Test initial rendering of card' do
    it 'should verify initial rendering of card' do
      within '#relationships-card' do
        expect(page).to have_content('Relationships')
        expect(page).to have_content('Search for people and add them to see their relationships.')
      end
    end

    it 'should add an existing child to a screening' do
      within '#relationships-card' do
        expect(page).to have_content("#{lucy_name} is the...")

        lucy[:relationships].each do |relation|
          name = full_name(first: relation[:first_name],
                           middle: relation[:middle_name],
                           last: relation[:last_name])
          expect(page).to \
            have_content("#{relation[:relationship]} #{relation[:relationship_type]}   of #{name}  Attach")
        end
      end
    end
  end

  describe 'existing adult' do
    before(:each) do
      find('li', text: /#{grandpa_name}/).first('a').click
    end

    describe 'Adding participant to an existing child on a screening' do
      it 'should add participant to the sidebar' do
        within 'div.side-bar' do
          expect(page).to have_css('a.link', text: grandpa_name)
        end
      end

      it "should remove 'Attach' link for the existing participant's relationship that is added to the screening" do
        expect(page).not_to \
          have_content("#{grandpa[:relationship]} #{grandpa[:relationship_type]}   of #{grandpa_name} Attach")
      end

      it 'should verify rendering of related relations card' do
        within '#relationships-card' do
          expect(page).to have_content("#{grandpa_name} is the...")

          grandpa[:relationships].each do |relation|
            name = full_name(first: relation[:first_name],
                             last: relation[:last_name])
            expect(page).to \
              have_content("#{relation[:relationship]} #{relation[:relationship_type]}   of #{name}")
          end
        end
      end

      it "should remove 'Attach' link from newly added participant from relationships-card" do
        expect(page).not_to \
          have_content("#{grandpa[:relationship]} #{grandpa[:relationship_type]}   of #{lucy_name}  Attach")
      end
    end

    describe 'Deleting a person that was added to a screening.' do
      before(:each) do
        find('div.card.double-gap-bottom span', text: grandpa_name)
          .sibling('button', text: 'Remove').click
      end

      it 'should remove participant to the sidebar' do
        within 'div.side-bar' do
          expect(page).not_to have_css('a.link', text: grandpa_name)
        end
      end

      it 'should verify removal of card' do
        within '#relationships-card' do
          expect(page).not_to have_content("#{grandpa_name} is the...")

          grandpa[:relationships].each do |relation|
            name = full_name(first: relation[:first_name],
                             middle: relation[:middle_name],
                             last: relation[:last_name])
            expect(page).not_to \
              have_content("#{relation[:relationship]} #{relation[:relationship_type]}   of #{name}")
          end
        end
      end
    end
  end
end
