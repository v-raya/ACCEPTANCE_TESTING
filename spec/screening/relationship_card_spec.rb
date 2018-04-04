# frozen_string_literal: true

describe 'Relationship card QA test', type: :feature do
  rel_1 = { fn: 'Billy', ln: 'Treppas', rel: 'Sister', rel_type: '(Half)' }
  rel_2   = { fn: 'Joe', ln: 'Atkyns', rel: 'Daughter', rel_type: '(Alleged)' }
  rel_3 = { fn: 'Larry', ln: 'Felgat', rel: 'Brother', rel_type: '' }
  rel_4  = { fn: 'Phil', ln: 'Bartoleyn', rel: 'Sister', rel_type: '(Half)' }
  p_2 = {
    fn: 'Grandpa',
    ln: 'Preece',
    rel: 'Granddaughter',
    rel_type: '(Paternal)',
    relationships: [
      rel_1.merge(rel: 'Grandparen', rel_type: '(Paternal)'),
      rel_2.merge(rel: 'Father', rel_type: '(Birth)'),
      rel_3.merge(rel: 'Grandparen', rel_type: '(Paternal)'),
      rel_4.merge(rel: 'No Relation', rel_type: ''),
    ]
  }
  p_1 = {
    fn: 'Lucy',
    mn: 'Lee',
    ln: 'Gaspar',
    relationships: [rel_1, rel_2, p_2, rel_3, rel_4]
  }
  p_2[:relationships].push(p_1.merge(rel: 'Grandparent', rel_type: '(Paternal)') )

  before(:each) do
    ScreeningPage.new.visit
    autocompleter_fill_in('Search for any person', "#{p_1[:fn]} #{p_1[:ln]}")
    wait_for_result_to_appear(element: 'div.autocomplete-menu div.profile-picture') do
      page.find('div.autocomplete-menu').first('strong.highlighted', text: 'Lucy Lee Gaspar').double_click
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
      name = [p_1[:fn], p_1[:mn], p_1[:ln]].reject(&:blank?).join(' ')
      within '#relationships-card' do
        expect(page).to have_content("#{name} is the...")
        p_1[:relationships].each do |relation|
          expect(page).to have_content("#{relation[:rel]} #{relation[:rel_type]}   of #{relation[:fn]} #{relation[:ln]}")
        end
      end
    end
  end

  describe 'existing adult' do
    before(:each) do
      find('li', text: /#{p_2[:fn]} #{p_2[:ln]}/).first('a').click
    end

    describe 'Adding participant to an existing child on a screening' do
      it 'should add participant to the sidebar' do
        within 'div.side-bar' do
          expect(page).to have_css('a.link', text: "#{p_2[:fn]} #{p_2[:ln]}")
        end
      end

      it "should remove 'Attach' link for the existing participant's relationship that is added to the screening" do
        expect(page).not_to have_content("#{p_2[:rel]} #{p_2[:rel_type]}   of #{p_2[:fn]} #{p_2[:ln]} Attach")
      end

      it 'should verify rendering of related relations card' do
        name = [p_2[:fn], p_2[:mn], p_2[:ln]].reject(&:blank?).join(' ')
        within '#relationships-card' do
          expect(page).to have_content("#{name} is the...")
          p_2[:relationships].each do |relation|
            expect(page).to have_content("#{relation[:rel]} #{relation[:rel_type]}   of #{relation[:fn]} #{relation[:ln]}")
          end
        end
      end

      it "should remove 'Attach' link for the new participant's relationship to the existing participant on the screening" do
        expect(page).not_to have_content("#{p_2[:rel]} #{p_2[:rel_type]}   of #{p_1[:fn]} #{p_1[:ln]}")
      end

    end

    describe 'Deleting a person that was added to a screening.' do
      before(:each) do
        find('div.card.double-gap-bottom span', text: "#{p_2[:fn]} #{p_2[:ln]}")
          .sibling('button', text: 'Remove').click
      end

      it 'should remove participant to the sidebar' do
        within 'div.side-bar' do
          expect(page).not_to have_css('a.link', text: "#{p_2[:fn]} #{p_2[:ln]}")
        end
      end

      it 'should verify removal of card' do
        name = [p_2[:fn], p_2[:mn], p_2[:ln]].reject(&:blank?).join(' ')
        within '#relationships-card' do
          expect(page).not_to have_content("#{name} is the...")
          p_2[:relationships].each do |relation|
            expect(page).not_to have_content("#{relation[:rel]} #{relation[:rel_type]}   of #{relation[:fn]} #{relation[:ln]}")
          end
        end
      end
    end
  end
end
