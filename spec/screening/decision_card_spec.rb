# frozen_string_literal: true

describe 'Decision card', type: :feature do
  # Selecting Start Screening on homepage
  it 'Test decision card' do
    visit '/'
    login_user
    click_link 'Start Screening'

    # Set variable to test 64 char limit and fields to accept any char
    char66str = '0123@567890123G567890123%5678901A345&789' \
      '01234567890123456789012345'
    char64str = '0123@567890123G567890123%5678901A' \
      '345&789012345678901234567890123'

    within '#decision-card' do
      within '.card-header' do
        expect(page).to have_content 'DECISION'
      end
      within '.card-body' do
        expect(page).to have_content 'Decision'
        expect(page).to have_content 'Additional information'
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
        expect(page).not_to have_content('Service name')
        select 'Differential response', from: 'Decision'
        expect(page).to have_content('Service name')
        fill_in('Service name', with: 'Family Strengthening')
        fill_in('Additional information',
                with: 'This is a test for $peci@! char & num8er5')
        click_button 'Save'
        # validate content of show view
        expect(page).to have_content 'Service name'
        expect(page).to have_content 'Family Strengthening'
        expect(page).to have_content 'Decision'
        expect(page).to have_content 'Differential response'
        expect(page).to have_content 'Additional information'
        expect(page).to have_content 'This is a test for $peci@! char & num8er5'
      end
      # click on the pencil icon in header to invoke the edit page
      within '.card-header' do
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        expect(page).to have_select('Decision',
                                    selected: 'Differential response')
        expect(page).to have_field('Service name', with: 'Family Strengthening')
        # Test for char type and field only accepts 64 chars
        fill_in('Service name', with: char66str)
        # validate field only accepts 64 char
        expect(page).to have_field('Service name', with: char64str)
        click_button 'Save'
        expect(page).to have_content char64str
      end
      # click on the pencil icon in header to invoke the edit page
      within '.card-header' do
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        expect(page).not_to have_content('Staff name')
        select 'Information to child welfare services', from: 'Decision'
        expect(page).to have_content('Staff name')
        expect(page).not_to have_content('Service name')
        # Fill with 66 chars, two more than limit
        fill_in('Staff name', with: char66str)
        click_button 'Save'
        expect(page).to have_content 'Staff name'
        # validate field only accepts 64 char
        expect(page).to have_content char64str
        expect(page).to have_content 'Decision'
        expect(page).to have_content 'Information to child welfare services'
      end
      # click on the pencil icon in header to invoke the edit page
      within '.card-header' do
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        expect(page).not_to have_content('Response time')
        select 'Promote to referral', from: 'Decision'
        expect(page).to have_content('Response time')
        expect(page).not_to have_content('Staff name')
        select 'Immediate', from: 'Response time'
        expect(page).to have_select('Response time', selected: 'Immediate')
        select '3 days', from: 'Response time'
        expect(page).to have_select('Response time', selected: '3 days')
        select '5 days', from: 'Response time'
        expect(page).to have_select('Response time', selected: '5 days')
        select '10 days', from: 'Response time'
        expect(page).to have_select('Response time', selected: '10 days')
        expect(page).not_to have_content('Category')
        select 'Screen out', from: 'Decision'
        expect(page).to have_content('Category')
        expect(page).not_to have_content('Response time')
        select 'Evaluate out', from: 'Category'
        expect(page).to have_select('Category', selected: 'Evaluate out')
        select 'Information request', from: 'Category'
        expect(page).to have_select('Category', selected: 'Information request')
        select 'Consultation', from: 'Category'
        expect(page).to have_select('Category', selected: 'Consultation')
        select 'Abandoned call', from: 'Category'
        expect(page).to have_select('Category', selected: 'Abandoned call')
        select 'Other', from: 'Category'
        expect(page).to have_select('Category', selected: 'Other')
        # Verify original content before canceling remains
        click_button 'Cancel'
        expect(page).to have_content 'Staff name'
        expect(page).to have_content char64str
        expect(page).to have_content 'Decision'
        expect(page).to have_content 'Information to child welfare services'
      end
      within '.card-header' do
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        # validate de-selecting removes the conditional fields
        select '', from: 'Decision'
        expect(page).to have_content 'Decision'
        expect(page).to have_content 'Additional information'
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
        expect(page).not_to have_content 'Staff name'
        expect(page).not_to have_content 'Response time'
        expect(page).not_to have_content 'Service name'
        expect(page).not_to have_content 'Category'
      end
    end
  end
end
