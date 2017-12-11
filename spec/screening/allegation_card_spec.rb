# frozen_string_literal: true

person1 = {
  fname: 'VICONE',
  lname: 'ONE',
  role: 'Victim',
  role2: 'Perpetrator',
  dob: '08/22/2006'
}
person2 = {
  fname: 'VICTWO',
  lname: 'TWO',
  role: 'Victim',
  role2: 'Non-mandated Reporter',
  dob: '08/01/2001'
}
person3 = {
  fname: 'PERPONE',
  lname: 'ONE',
  role: 'Perpetrator',
  role2: 'Mandated Reporter',
  dob: '01/01/1999'
}
person4 = {
  fname: 'PERPTWO',
  lname: 'TWO',
  role: 'Perpetrator',
  role2: 'Victim',
  dob: '05/01/1991'
}

describe 'Allegations Card Tests', type: :feature do
  # Selecting Start Screening on homepage
  before do
    ScreeningPage.new.visit
  end

  after do
    logout_user
  end

  it 'Test Allegation card' do
    skip 'This test is intermittent'
    within '#allegations-card' do
      within '.card-header' do
        expect(page).to have_content('Allegations')
      end
      within '.card-body' do
        expect(page).to have_content('Alleged Victim/Children')
        expect(page).to have_content('Alleged Perpetrator')
        expect(page).to have_content('Allegation(s)')
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
      end
    end
    # create and fill-in first card
    within '#search-card' do
      autocompleter_fill_in 'Search for any person', 'Tete'
      click_button 'Create a new person'
      sleep 0.3
    end
    person1_id = find('div[id^="participants-card-"]', text: 'Unknown')[:id]
    person1_card = find('#' + person1_id)
    find('#search-card .card-header span').click

    within person1_card do
      find('input#first_name').click
      fill_in('First Name', with: person1[:fname])
      fill_in('Last Name', with: person1[:lname])
      fill_in('Date of birth', with: person1[:dob])
      fill_in_react_select 'Role', with: person1[:role]
      click_button 'Save'
      expect(page).to have_content("#{person1[:fname]} " \
                                   "#{person1[:lname]}")
      within '.card-header' do
        expect(page).to have_content("#{person1[:fname]} " \
                                     "#{person1[:lname]}")
      end
    end
    # Verify that allegation card does not show the victim
    within '#allegations-card' do
      within '.card-header' do
        expect(page).to have_content('Allegations')
      end
      within '.card-body' do
        expect(page).to have_content('Alleged Victim/Children')
        expect(page).to have_content('Alleged Perpetrator')
        expect(page).to have_content('Allegation(s)')
        expect(page).not_to have_content("#{person1[:fname]} " \
                                         "#{person1[:lname]}")
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
      end
    end
    # create and fill-in second card
    within '#search-card', text: 'Search' do
      autocompleter_fill_in 'Search for any person', 'Tete'
      click_button 'Create a new person'
      sleep 0.3
    end
    person2_id = find('div[id^="participants-card-"]', text: 'Unknown')[:id]
    person2_card = find('#' + person2_id)
    find('#search-card .card-header span').click

    within person2_card do
      find('input#first_name').click
      fill_in('First Name', with: person2[:fname])
      fill_in('Last Name', with: person2[:lname])
      fill_in('Date of birth', with: person2[:dob])
      fill_in_react_select 'Role', with: person2[:role]
      click_button 'Save'
      expect(page).to have_content("#{person2[:fname]} " \
                                   "#{person2[:lname]}")
      within '.card-header' do
        expect(page).to have_content("#{person2[:fname]} " \
                                     "#{person2[:lname]}")
      end
    end
    # create and fill-in third card
    within '#search-card', text: 'Search' do
      autocompleter_fill_in 'Search for any person', 'Tete'
      click_button 'Create a new person'
      sleep 0.3
    end
    person3_id = find('div[id^="participants-card-"]', text: 'Unknown')[:id]
    person3_card = find('#' + person3_id)
    find('#search-card .card-header span').click

    within person3_card do
      find('input#first_name').click
      fill_in('First Name', with: person3[:fname])
      fill_in('Last Name', with: person3[:lname])
      fill_in('Date of birth', with: person3[:dob])
      fill_in_react_select 'Role', with: person3[:role]
      click_button 'Save'
      expect(page).to have_content("#{person3[:fname]} " \
                                   "#{person3[:lname]}")
      within '.card-header' do
        expect(page).to have_content("#{person3[:fname]} " \
                                     "#{person3[:lname]}")
      end
    end
    # Verify that allegation card does not show the victim
    within '#allegations-card' do
      within '.card-header' do
        expect(page).to have_content('Allegations')
      end
      within '.card-body' do
        expect(page).to have_content('Alleged Victim/Children')
        expect(page).to have_content('Alleged Perpetrator')
        expect(page).to have_content('Allegation(s)')
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
      end
      within('tbody') do
        table_rows = page.all('tr')
        expect(table_rows.count).to eq(2)

        # check initial rendering of the allegations card and filled-in values
        within(table_rows[0]) do
          expect(page).to have_content("#{person1[:fname]} " \
                                       "#{person1[:lname]}")
          expect(page).to have_content("#{person3[:fname]} " \
                                       "#{person3[:lname]}")
          row0_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row0_id, with: [])
        end
        within(table_rows[1]) do
          expect(page).to have_content("#{person2[:fname]} " \
                                       "#{person2[:lname]}")
          expect(page).to have_content("#{person3[:fname]} " \
                                       "#{person3[:lname]}")
          row1_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row1_id, with: [])
        end
      end
    end

    within '#search-card', text: 'Search' do
      autocompleter_fill_in 'Search for any person', 'Tete'
      click_button 'Create a new person'
      sleep 0.3
    end
    person4_id = find('div[id^="participants-card-"]', text: 'Unknown')[:id]
    person4_card = find('#' + person4_id)
    within person4_card do
      find('input#first_name').click
      fill_in('First Name', with: person4[:fname])
      fill_in('Last Name', with: person4[:lname])
      fill_in('Date of birth', with: person4[:dob])
      fill_in_react_select 'Role', with: person4[:role]
      click_button 'Save'
      expect(page).to have_content("#{person4[:fname]} " \
                                   "#{person4[:lname]}")
      within '.card-header' do
        expect(page).to have_content("#{person4[:fname]} " \
                                     "#{person4[:lname]}")
      end
    end
    within '#allegations-card' do
      within '.card-body' do
        expect(page).to have_content('Alleged Victim/Children')
        expect(page).to have_content('Alleged Perpetrator')
        expect(page).to have_content('Allegation(s)')
      end
      within('tbody') do
        table_rows = page.all('tr')
        expect(table_rows.count).to eq(4)

        # check initial rending of the allegations card and fill-in values
        within(table_rows[0]) do
          expect(page).to have_content("#{person1[:fname]} #{person1[:lname]}")
          expect(page).to have_content("#{person3[:fname]} #{person3[:lname]}")
          row0_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row0_id, with: [])
          fill_in_react_select(row0_id, with: ['Exploitation'])
          has_react_select_field(row0_id, with: ['Exploitation'])
          find_field(row0_id).send_keys(:backspace)
          has_react_select_field(row0_id, with: [])
          fill_in_react_select(row0_id, with: ['Physical abuse'])
        end
        within(table_rows[1]) do
          expect(page).not_to have_content("#{person1[:fname]} " \
                                           "#{person1[:lname]}")
          expect(page).to have_content("#{person4[:fname]} #{person4[:lname]}")
          row1_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row1_id, with: [])
          fill_in_react_select(row1_id, with: ['General neglect'])
          has_react_select_field(row1_id, with: ['General neglect'])
          find_field(row1_id).send_keys(:backspace)
          has_react_select_field(row1_id, with: [])
          fill_in_react_select(row1_id, with: ['Severe neglect'])
        end
        within(table_rows[2]) do
          expect(page).to have_content("#{person2[:fname]} #{person2[:lname]}")
          expect(page).to have_content("#{person3[:fname]} #{person3[:lname]}")
          row2_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row2_id, with: [])
          fill_in_react_select(row2_id, with: ['Sexual abuse'])
          has_react_select_field(row2_id, with: ['Sexual abuse'])
          find_field(row2_id).send_keys(:backspace)
          has_react_select_field(row2_id, with: [])
          fill_in_react_select(row2_id, with: ['Emotional abuse'])
        end
        within(table_rows[3]) do
          expect(page).not_to have_content("#{person2[:fname]} " \
                                           "#{person2[:lname]}")
          expect(page).to have_content("#{person4[:fname]} #{person4[:lname]}")
          row3_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row3_id, with: [])
          fill_in_react_select(row3_id, with: ['Caretaker absent/incapacity'])
          has_react_select_field(row3_id, with: ['Caretaker absent/incapacity'])
          find_field(row3_id).send_keys(:backspace)
          has_react_select_field(row3_id, with: [])
          fill_in_react_select(row3_id, with: ['At risk, sibling abused'])
        end
      end
    end
    # changing roles of person
    within person1_card do
      click_link 'Edit'
      fill_in_react_select 'Role', with: person1[:role2]
      click_button 'Save'
      expect(page).to have_content("#{person1[:fname]} #{person1[:lname]}")
      within '.card-header' do
        expect(page).to have_content("#{person1[:fname]} #{person1[:lname]}")
      end
    end
    within '#allegations-card' do
      within('tbody') do
        table_rows = page.all('tr')
        expect(table_rows.count).to eq(5)
        # check the person that is a victim and perpetrator show up properly
        within(table_rows[0]) do
          expect(page).to have_content("#{person1[:fname]} " \
                                           "#{person1[:lname]}")
          expect(page).to have_content("#{person3[:fname]} #{person3[:lname]}")
          row0_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row0_id, with: ['Physical abuse'])
        end
        within(table_rows[1]) do
          expect(page).not_to have_content("#{person1[:fname]} " \
                                           "#{person1[:lname]}")
          expect(page).to have_content("#{person4[:fname]} #{person4[:lname]}")
          row1_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row1_id, with: ['Severe neglect'])
        end
        within(table_rows[2]) do
          expect(page).to have_content("#{person2[:fname]} " \
                                       "#{person2[:lname]}")
          expect(page).to have_content("#{person1[:fname]} #{person1[:lname]}")
          row2_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row2_id, with: [])
        end
        within(table_rows[3]) do
          expect(page).not_to have_content("#{person2[:fname]} " \
                                           "#{person2[:lname]}")
          expect(page).to have_content("#{person3[:fname]} #{person3[:lname]}")
          row3_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row3_id, with: ['Emotional abuse'])
        end
        within(table_rows[4]) do
          expect(page).not_to have_content("#{person2[:fname]} " \
                                           "#{person2[:lname]}")
          expect(page).to have_content("#{person4[:fname]} #{person4[:lname]}")
          row4_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row4_id, with: ['At risk, sibling abused'])
        end
      end
    end
    # Verify the Allegation card is unchanged when adding a non-perpetrator/
    # victim role
    within person3_card do
      click_link 'Edit'
      fill_in_react_select 'Role', with: person3[:role2]
      has_react_select_field('Role', with: [person3[:role], person3[:role2]])
      click_button 'Save'
    end
    within '#allegations-card' do
      within('tbody') do
        table_rows = page.all('tr')
        expect(table_rows.count).to eq(5)
        # check the person that is a victim and perpetrator show up properly
        within(table_rows[0]) do
          expect(page).to have_content("#{person1[:fname]} " \
                                           "#{person1[:lname]}")
          expect(page).to have_content("#{person3[:fname]} #{person3[:lname]}")
          row0_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row0_id, with: ['Physical abuse'])
        end
        within(table_rows[1]) do
          expect(page).not_to have_content("#{person1[:fname]} " \
                                           "#{person1[:lname]}")
          expect(page).to have_content("#{person4[:fname]} #{person4[:lname]}")
          row1_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row1_id, with: ['Severe neglect'])
        end
        within(table_rows[2]) do
          expect(page).to have_content("#{person2[:fname]} " \
                                           "#{person2[:lname]}")
          expect(page).to have_content("#{person1[:fname]} #{person1[:lname]}")
          row2_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row2_id, with: [])
        end
        within(table_rows[3]) do
          expect(page).not_to have_content("#{person2[:fname]} " \
                                           " #{person2[:lname]}")
          expect(page).to have_content("#{person3[:fname]} #{person3[:lname]}")
          row3_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row3_id, with: ['Emotional abuse'])
        end
        within(table_rows[4]) do
          expect(page).not_to have_content("#{person2[:fname]} " \
                                           "#{person2[:lname]}")
          expect(page).to have_content("#{person4[:fname]} #{person4[:lname]}")
          row4_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row4_id, with: ['At risk, sibling abused'])
        end
      end
    end
    # delete the role of the person with perpetrator
    within person3_card do
      click_link 'Edit'
      role_input = find_field('Role')
      3.times do
        role_input.send_keys(:backspace)
      end
      has_react_select_field('Role', with: [])
      click_button 'Save'
    end
    # validate deleted person no longer displays
    within '#allegations-card' do
      within('tbody') do
        sleep 0.3
        table_rows = page.all('tr')
        expect(table_rows.count).to eq(3)
        # check correct display without person3
        within(table_rows[0]) do
          expect(page).to have_content("#{person1[:fname]} " \
                                           "#{person1[:lname]}")
          expect(page).to have_content("#{person4[:fname]} #{person4[:lname]}")
          row0_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row0_id, with: ['Severe neglect'])
        end
        within(table_rows[1]) do
          expect(page).to have_content("#{person2[:fname]} " \
                                       "#{person2[:lname]}")
          expect(page).to have_content("#{person1[:fname]} #{person1[:lname]}")
          row1_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row1_id, with: [])
        end
        within(table_rows[2]) do
          expect(page).not_to have_content("#{person2[:fname]} " \
                                           "#{person2[:lname]}")
          expect(page).to have_content("#{person4[:fname]} #{person4[:lname]}")
          row2_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row2_id, with: ['At risk, sibling abused'])
        end
      end
    end
    within person2_card do
      # find(:css, 'i.fa.fa-times').click
      click_link 'Edit'
      role_input = find_field('Role')
      2.times do
        role_input.send_keys(:backspace)
      end
      has_react_select_field('Role', with: [])
      click_button 'Save'
    end
    within '#allegations-card' do
      within('tbody') do
        sleep 0.3
        table_rows = page.all('tr')
        expect(table_rows.count).to eq(1)
        # check correct display without person2
        within(table_rows[0]) do
          expect(page).to have_content("#{person1[:fname]} " \
                                       "#{person1[:lname]}")
          expect(page).to have_content("#{person4[:fname]} #{person4[:lname]}")
          row0_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row0_id, with: ['Severe neglect'])
        end
      end
    end
    # Verify single perpetrator does not display in allegations
    within person1_card do
      click_link 'Edit'
      role_input = find_field('Role')
      2.times do
        role_input.send_keys(:backspace)
      end
      has_react_select_field('Role', with: [])
      click_button 'Save'
    end
    within '#allegations-card' do
      within '.card-body' do
        expect(page).to have_content('Alleged Victim/Children')
        expect(page).to have_content('Alleged Perpetrator')
        expect(page).to have_content('Allegation(s)')
        expect(page).not_to have_content("#{person1[:fname]} " \
                                         "#{person1[:lname]}")
      end
    end
    # Adding Alleged Victim to Allegations card
    within person1_card do
      click_link 'Edit'
      fill_in_react_select 'Role', with: person1[:role]
      click_button 'Save'
    end
    within '#allegations-card' do
      within('tbody') do
        sleep 0.3
        table_rows = page.all('tr')
        expect(table_rows.count).to eq(1)
        within(table_rows[0]) do
          expect(page).to have_content("#{person1[:fname]} " \
                                       "#{person1[:lname]}")
          expect(page).to have_content("#{person4[:fname]} #{person4[:lname]}")
          row0_id = find('input[id^="allegations_"]')[:id]
          has_react_select_field(row0_id, with: [])
        end
      end
    end
    # Testing if one person is alleged perpetrator it doesn't display
    # To do this remove person1 thru person4 and add one back
    within person1_card do
      find(:css, 'i.fa.fa-times').click
    end
    within person2_card do
      find(:css, 'i.fa.fa-times').click
    end
    within person3_card do
      find(:css, 'i.fa.fa-times').click
    end
    within '#allegations-card' do
      within '.card-body' do
        expect(page).to have_content('Alleged Victim/Children')
        expect(page).to have_content('Alleged Perpetrator')
        expect(page).to have_content('Allegation(s)')
        expect(page).not_to have_content("#{person4[:fname]} " \
                                         "#{person4[:lname]}")
      end
    end
  end
end
