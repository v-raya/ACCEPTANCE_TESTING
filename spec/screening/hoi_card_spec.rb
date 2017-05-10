# frozen_string_literal: true
require 'react_select_helpers'
require 'autocompleter_helpers'

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

scr1 = {
  name: 'Harry1',
  worker: 'Florence Nightingale',
  sdate: '08-13-2016T10:00:00.000Z',
  edate: '08-13-2016T11:00:00.000Z',
  comm: 'Mail',
  decis: 'Promote to referral'
}

scr2 = {
  name: 'Harry2',
  worker: 'Flying Nun',
  sdate: '08-13-1996T10:00:00.000Z',
  edate: '08-15-1996T11:00:00.000Z',
  comm: 'Email'
}

scr3 = {
  name: 'Trin',
  worker: 'Mother Terri',
  sdate: '07-12-1996T10:00:00.000Z',
  edate: '07-13-1996T11:00:00.000Z',
  comm: 'Online',
  inc_cty: 'Amador',
  decis: 'Promote to referral'
}

scr4 = {
  name: 'Bay',
  worker: 'Jan Brady',
  sdate: '07-10-1996T10:00:00.000Z',
  edate: '07-11-1996T11:00:00.000Z',
  comm: 'Fax',
  inc_cty: 'Butte',
  decis: 'Promote to referral'
}

scr5 = {
  name: 'Trin&BayShared',
  worker: 'Marcia Brady',
  sdate: '07-09-1996T10:00:00.000Z',
  edate: '07-10-1996T11:00:00.000Z',
  comm: 'Fax',
  inc_cty: 'Del Norte'
}

scr6 = {
  name: 'Trin&BaySharedAgain',
  worker: 'Marcia Brady',
  sdate: '07-09-1996T10:00:00.000Z',
  edate: '07-10-1996T11:00:00.000Z',
  comm: 'Fax',
  inc_cty: 'Sacramento'
}
person1 = {
  fname: 'XAVIER',
  lname: 'PERSONONE',
  role1: 'Victim',
  role2: 'Mandated Reporter',
  phonenum: '213-432-4400',
  phonetype: 'Cell',
  dob: '08/22/1966',
  gender: 'Female',
  ssn: '765-44-4887',
  addr: '321 S. Main Street',
  city: 'Carmel',
  state: 'California',
  Zip: '90210',
  addrtype: 'Homeless'
}

person2 = {
  fname: 'Jim',
  lname: 'PERSONTWO',
  role1: 'Non-mandated Reporter',
  role2: 'Perpetrator'
}

person3 = {
  fname: 'TRIN',
  lname: 'NIRT',
  role1: 'Non-mandated Reporter',
  role2: 'Perpetrator'
}

person4 = {
  fname: 'BAY',
  lname: 'YAB',
  role1: 'Victim',
  role2: 'Mandated Reporter'
}

describe 'Test for History of Involvement', type: :feature do
  # Selecting Start Screening on landing
  before do
    visit '/'
    username_input = page.find('input[name=username]')
    username_input.send_keys 'guest'
    password_input = page.find('input[name=password]')
    password_input.send_keys 'guest'
    click_button('Sign In')
    click_link 'Start Screening'
  end

  #   it 'Populate first screening' do
  #     within '#screening-information-card' do
  #       fill_in('Title/Name of Screening', with: scr1[:name])
  #       fill_in('Assigned Social Worker', with: scr1[:worker])
  #       fill_in('Screening Start Date/Time', with: scr1[:sdate])
  #       fill_in('Screening End Date/Time', with: scr1[:edate])
  #       select scr1[:comm], from: 'Communication Method'
  #       click_button 'Save'
  #     end
  #     within '#search-card', text: 'SEARCH' do
  #       autocompleter_fill_in 'Search for any person', person1[:fname]
  #       within('ul.react-autosuggest__suggestions-list') do
  #         # page.all('li').each do |element|
  #           find('li', :text => person1[:fname].capitalize).click
  #         # end
  #       end
  #       sleep 0.3
  #     end
  #     person1_id = find('div[id^="participants-card-"]', text: person1[:fname])[:id]
  #     person1_card = find('#' + person1_id)
  #     within person1_card do
  #       expect(page).to have_content("#{person1[:fname]} " \
  #                                    "#{person1[:lname]}")
  #       fill_in_react_select 'Role', with: person1[:role2]
  # #      click_button 'Save'
  #     end
  #     within '#decision-card' do
  #       select scr1[:decis], from: 'Screening Decision'
  #       click_button 'Save'
  #     end
  #   end
  #   it 'Populate second screening and verify HOI' do
  #     within '#screening-information-card' do
  #       fill_in('Title/Name of Screening', with: scr2[:name])
  #       fill_in('Assigned Social Worker', with: scr2[:worker])
  #       fill_in('Screening Start Date/Time', with: scr2[:sdate])
  #       fill_in('Screening End Date/Time', with: scr2[:edate])
  #       select scr2[:comm], from: 'Communication Method'
  #       click_button 'Save'
  #     end
  #     within '#search-card', text: 'SEARCH' do
  #       autocompleter_fill_in 'Search for any person', person1[:fname]
  #       within('ul.react-autosuggest__suggestions-list') do
  #         # page.all('li').each do |element|
  #           find('li', :text => person1[:fname].capitalize).click
  #         # end
  #       end
  #       sleep 0.3
  #     end
  #     person1_id = find('div[id^="participants-card-"]', text: person1[:fname])[:id]
  #     person1_card = find('#' + person1_id)
  #     within person1_card do
  #       expect(page).to have_content("#{person1[:fname]} " \
  #                                    "#{person1[:lname]}")
  #       fill_in_react_select 'Role', with: person1[:role1]
  #       click_button 'Save'
  #     end
  #     within '#history-card' do
  #       within 'thead' do
  #         expect(page).to have_content('Date')
  #         expect(page).to have_content('Type/Status')
  #         expect(page).to have_content('County/Office')
  #         expect(page).to have_content('People and Roles')
  #       end
  #     end
  #     # within '#decision-card' do
  #     #   fill_in('screening_decision', with: scr1[:decis])
  #     #   click_button 'Save'
  #     # end
  #   end
  it 'Populate screening for Person 3' do
    within '#screening-information-card' do
      fill_in('Title/Name of Screening', with: scr3[:name])
      fill_in('Assigned Social Worker', with: scr3[:worker])
      fill_in('Screening Start Date/Time', with: scr3[:sdate])
      fill_in('Screening End Date/Time', with: scr3[:edate])
      select scr3[:comm], from: 'Communication Method'
      click_button 'Save'
    end
    within '#incident-information-card' do
      select scr3[:inc_cty], from: 'Incident County'
    end
    within '#search-card', text: 'SEARCH' do
      autocompleter_fill_in 'Search for any person', person3[:fname]
      within('ul.react-autosuggest__suggestions-list') do
        # page.all('li').each do |element|
        find('li', text: person3[:lname]).click
        # end
      end
      sleep 0.3
    end
    person3_id = find('div[id^="participants-card-"]', text: person3[:fname])[:id]
    person3_card = find('#' + person3_id)
    within person3_card do
      expect(page).to have_content("#{person3[:fname]} " \
                                   "#{person3[:lname]}")
      fill_in_react_select 'Role', with: person3[:role2]
      #      click_button 'Save'
    end
    within '#decision-card' do
      select scr3[:decis], from: 'Screening Decision'
      click_button 'Save'
    end
  end
  it 'Populate second screening for person 4' do
    within '#screening-information-card' do
      fill_in('Title/Name of Screening', with: scr4[:name])
      fill_in('Assigned Social Worker', with: scr4[:worker])
      fill_in('Screening Start Date/Time', with: scr4[:sdate])
      fill_in('Screening End Date/Time', with: scr4[:edate])
      select scr4[:comm], from: 'Communication Method'
      click_button 'Save'
    end
    within '#search-card', text: 'SEARCH' do
      autocompleter_fill_in 'Search for any person', person4[:fname]
      within('ul.react-autosuggest__suggestions-list') do
        # page.all('li').each do |element|
        find('li', text: person4[:lname]).click
        # end
      end
      sleep 0.3
    end
    person4_id = find('div[id^="participants-card-"]', text: person4[:fname])[:id]
    person4_card = find('#' + person4_id)
    within person4_card do
      expect(page).to have_content("#{person4[:fname]} " \
                                   "#{person4[:lname]}")
      fill_in_react_select 'Role', with: person4[:role1]
      click_button 'Save'
    end
    within '#history-card' do
      within 'thead' do
        expect(page).to have_content('Date')
        expect(page).to have_content('Type/Status')
        expect(page).to have_content('County/Office')
        expect(page).to have_content('People and Roles')
      end
    end
  end
  it 'Populate third screening for person 3 & 4' do
    within '#screening-information-card' do
      fill_in('Title/Name of Screening', with: scr5[:name])
      fill_in('Assigned Social Worker', with: scr5[:worker])
      fill_in('Screening Start Date/Time', with: scr5[:sdate])
      fill_in('Screening End Date/Time', with: scr5[:edate])
      select scr5[:comm], from: 'Communication Method'
      click_button 'Save'
    end
    within '#search-card', text: 'SEARCH' do
      autocompleter_fill_in 'Search for any person', person3[:fname]
      within('ul.react-autosuggest__suggestions-list') do
        # page.all('li').each do |element|
        find('li', text: person3[:lname]).click
        # end
      end
      sleep 0.3
      autocompleter_fill_in 'Search for any person', person4[:fname]
      within('ul.react-autosuggest__suggestions-list') do
        # page.all('li').each do |element|
        find('li', text: person4[:lname]).click
        # end
      end
      sleep 0.3
    end
    # person4_id = find('div[id^="participants-card-"]', text: person4[:fname])[:id]
    # person4_card = find('#' + person4_id)
    # within person1_card do
    #   expect(page).to have_content("#{person4[:fname]} " \
    #                                "#{person4[:lname]}")
    #   fill_in_react_select 'Role', with: person4[:role1]
    #   click_button 'Save'
    # end
    within '#history-card' do
      within 'thead' do
        expect(page).to have_content('Date')
        expect(page).to have_content('Type/Status')
        expect(page).to have_content('County/Office')
        expect(page).to have_content('People and Roles')
      end
      # within 'tbody' do
      # expect(page).to have_content(scr5[:sdate])
        expect(page).to have_content('Screening (Closed)')
        expect(page).to have_content(person3[:inc_cty])
        expect(page).to have_content(person3[:fname])
        expect(page).to have_content(person3[:lname])
      # end
      # expect(page).to have_content("Reporter: #{person3[:fname]} #{person3[:lname]}")
      # expect(page).to have_content("Worker: #{scr3[:worker]}")
    end
  end
  it 'Populate the joint Again screen and verify the history card' do
    within '#screening-information-card' do
      fill_in('Title/Name of Screening', with: scr6[:name])
      fill_in('Assigned Social Worker', with: scr6[:worker])
      fill_in('Screening Start Date/Time', with: scr6[:sdate])
      fill_in('Screening End Date/Time', with: scr6[:edate])
      select scr6[:comm], from: 'Communication Method'
      click_button 'Save'
    end
    within '#search-card', text: 'SEARCH' do
      autocompleter_fill_in 'Search for any person', person3[:fname]
      within('ul.react-autosuggest__suggestions-list') do
        # page.all('li').each do |element|
        find('li', text: person3[:lname]).click
        # end
      end
      sleep 0.3
    end
    within '#history-card' do
      within('tbody') do
        # n = the number that will be expected when run greenfield
        # expect(elements_containing(:tr, 'TRIN', 'NIRT').count).to be_greater_than(n)
        # table_rows = page.all('tr')
        # # expect(table_rows.count).to eq(2)
        # n= 2
        # check initial rendering of the HOI card and fill-in values
        expect(elements_containing(:tr,
                                   'Screening (Closed)',
                                   "#{person3[:fname]} #{person3[:lname]}",
                                   "Worker: #{scr3[:worker]}").count).to be >= 2
        # end
        # within(table_rows[1]) do
        #   # Need to check date once date picker is done.
        # n= 2
        # expect(page).to have_content('Screening (Closed)')
        # expect(page).to have_content(person3[:inc_cty])
        expect(elements_containing(:tr, 'Screening (Closed)', "#{person3[:fname]} " \
                                   "#{person3[:lname]}", 'Worker: ' \
                                   "#{scr5[:worker]}").count).to be >= 2
        #   expect(page).to have_content("#{person4[:fname]} " \
        #                                "#{person4[:lname]}" \
        #                                ", " \
        #                                "#{person3[:fname]} " \
        #                                "#{person3[:lname]}")
        #   expect(page).to have_content("Worker: " \
        #                                "#{scr5[:worker]}")
        # end
      end
    end
    within '#search-card', text: 'SEARCH' do
      autocompleter_fill_in 'Search for any person', person4[:fname]
      within('ul.react-autosuggest__suggestions-list') do
        # page.all('li').each do |element|
        find('li', text: person4[:lname]).click
        # end
      end
      sleep 0.3
    end
    within '#history-card' do
      within('tbody') do
        # table_rows = page.all('tr')
        # expect(table_rows.count).to eq(2)

        # check initial rendering of the HOI card and fill-in values
          # Need to check date once date picker is done.
        expect(elements_containing(:tr,
                                   'Screening (Closed)',
                                   "#{person3[:fname]} #{person3[:lname]}",
                                   "Worker: #{scr3[:worker]}").count).to be >= 2
        expect(elements_containing(:tr, 'Screening (Closed)',
                                   "#{person4[:fname]} #{person4[:lname]}",
                                   'Worker: ' \
                                   "#{scr5[:worker]}").count).to be >= 2
       expect(elements_containing(:tr, 'Screening (Closed)',
                                  "#{person4[:fname]} #{person4[:lname]}",
                                  'Worker: ' \
                                  "#{scr4[:worker]}").count).to be >= 2
      end
    end
    # Deleting a person
    within person4_card do
      find(:css, 'i.fa.fa-times').click
    end
    within '#history-card' do
      within('.tbody') do
        # table_rows = page.all('tr')
        # # expect(table_rows.count).to eq(2)
        expect(elements_containing(:tr,
                                   'Screening (Closed)',
                                   "#{person3[:fname]} #{person3[:lname]}",
                                   "Worker: #{scr3[:worker]}").count).to be >= 2
        expect(elements_containing(:tr, 'Screening (Closed)',
                                   "#{person4[:fname]} #{person4[:lname]}, " \
                                   "#{person3[:fname]} #{person3[:lname]}",
                                   'Worker: ' \
                                   "#{scr5[:worker]}").count).to be >= 2
        # check initial rendering of the HOI card and fill-in values
        # within(table_rows[0]) do
        #   # Need to check date once date picker is done.
        #   expect(page).to have_content('Screening (Closed)')
        #   # expect(page).to have_content(person3[:inc_cty])
        #   expect(page).to have_content("#{person3[:fname]} " \
        #                                "#{person3[:lname]}")
        #   expect(page).to have_content('Worker: ' \
        #                                "#{scr3[:worker]}")
        # end
        # within(table_rows[1]) do
        #   # Need to check date once date picker is done.
        #   expect(page).to have_content('Screening (Closed)')
        #   # expect(page).to have_content(person3[:inc_cty])
        #   expect(page).to have_content("#{person4[:fname]} " \
        #                                "#{person4[:lname]}" \
        #                                ', ' \
        #                                "#{person3[:fname]} " \
        #                                "#{person3[:lname]}")
        #   expect(page).to have_content('Worker: ' \
        #                                "#{scr5[:worker]}")
        # end
      end
    end
  end
  # within '#decision-card' do
  #   fill_in('screening_decision', with: scr1[:decis])
  #   click_button 'Save'
  # end
end
