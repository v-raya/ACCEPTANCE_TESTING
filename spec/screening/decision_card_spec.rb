# frozen_string_literal: true

require 'keyboard_helper'

describe 'Decision card', type: :feature do
  let(:screening_page) { ScreeningPage.new }
  # Selecting Start Screening on homepage
  before do
    screening_page.visit
  end

  it 'Test decision card' do
    # Set variable to test 64 char limit and fields to accept any char
    char66str = '0123@567890123G567890123%5678901A345&789' \
      '01234567890123456789012345'
    char64str = '0123@567890123G567890123%5678901A' \
      '345&789012345678901234567890123'

    within '#decision-card' do
      within '.card-header' do
        expect(page).to have_content 'Decision'
      end
      within '.card-body' do
        # validate content of edit view
        expect(page).to have_content 'Screening decision'
        expect(page).to have_content 'Additional information'
        expect(page).to have_content 'SDM Hotline Tool'
        expect(page).to have_content 'Determine Decision and Response Time by using Structured Decision Making.'
        expect(page).to have_link 'Complete SDM'
        link_from_show = find_link('Complete SDM')
        expect(link_from_show[:href]).to eq 'https://ca.sdmdata.org/'
        expect(link_from_show[:target]).to eq '_blank'
        sdm_window = window_opened_by { click_link 'Complete SDM' }
        # We can't switch_to_window to check current URL from within a 'within' block
        # Capybara API limitation
        expect(sdm_window.exists?).to be_truthy
        sdm_window.close
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
        expect(page).not_to have_content('Service name')
        select 'Differential response', from: 'Screening decision'
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
        expect(page).to have_content 'SDM Hotline Tool'
        expect(page).to have_content 'Determine Decision and Response Time by using Structured Decision Making.'
        expect(page).to have_link 'Complete SDM'
        link_from_show = find_link('Complete SDM')
        expect(link_from_show[:href]).to eq 'https://ca.sdmdata.org/'
        expect(link_from_show[:target]).to eq '_blank'
        sdm_window = window_opened_by { click_link 'Complete SDM' }
        # We can't switch_to_window to check current URL from within a 'within' block
        # Capybara API limitation
        expect(sdm_window.exists?).to be_truthy
        sdm_window.close
      end
      within '.card-header' do
        click_link 'Edit'
      end
      within '.card-body' do
        expect(page).to have_select('Screening decision',
                                    selected: 'Differential response')
        expect(page).to have_field('Service name', with: 'Family Strengthening')
        # Test for char type and field only accepts 64 chars
        fill_in('Service name', with: char66str)
        # validate field only accepts 64 char
        expect(page).to have_field('Service name', with: char64str)
        click_button 'Save'
        expect(page).to have_content char64str
      end
      within '.card-header' do
        click_link 'Edit'
      end
      within '.card-body' do
        expect(page).not_to have_content('Staff name')
        select 'Information to child welfare services', from: 'Screening decision'
        expect(page).to have_content('Staff name')
        expect(page).not_to have_content('Service name')
        # Fill with 66 chars, two more than limit
        fill_in('Staff name', with: char66str)
        click_button 'Save'
        expect(page).to have_content 'Staff name'
        # validate field only accepts 64 char
        expect(page).to have_content char64str
        expect(page).to have_content 'Screening decision'
        expect(page).to have_content 'Information to child welfare services'
      end
      within '.card-header' do
        click_link 'Edit'
      end
      within '.card-body' do
        expect(page).not_to have_content('Response time')
        select 'Promote to referral', from: 'Screening decision'
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
        select 'Screen out', from: 'Screening decision'
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
        expect(page).to have_content 'Screening decision'
        expect(page).to have_content 'Information to child welfare services'
      end
      within '.card-header' do
        click_link 'Edit'
      end
      within '.card-body' do
        # validate de-selecting removes the conditional fields
        select '', from: 'Screening decision'
        expect(page).to have_content 'Screening decision'
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

  it 'displays an error message if screening decision is blank' do
    message = 'Please enter a decision'

    within '#decision-card.edit' do
      expect(page).not_to have_content(message)
      click_button 'Save'
    end

    within '#decision-card.show' do
      expect(page).to have_content(message)
      click_link 'Edit'
    end

    within '#decision-card.edit' do
      expect(page).to have_content(message)
      select 'Differential response', from: 'Screening decision'
      expect(page).not_to have_content(message)
      click_button 'Save'
    end

    within '#decision-card.show' do
      expect(page).not_to have_content(message)
    end
  end

  it 'when decision is promote to referral, displays an error message if response time is blank' do
    message = 'Please enter a response time'

    within '#decision-card.edit' do
      select 'Promote to referral', from: 'Screening decision'
      blur
      expect(page).not_to have_content(message)
      click_button 'Save'
    end

    within '#decision-card.show' do
      expect(page).to have_content(message)
      click_link 'Edit'
    end

    within '#decision-card.edit' do
      expect(page).to have_content(message)
      select 'Immediate', from: 'Response time'
      expect(page).not_to have_content(message)
      click_button 'Save'
    end

    within '#decision-card.show' do
      expect(page).not_to have_content(message)
    end
  end

  it 'with Promote to referral without allegations' do
    referal_without_allegation_message = 'Please enter at least one allegation to promote to referral'
    response_time_error_message = 'Please enter a response time'

    ## with out Allegation
    within '#decision-card.edit' do
      expect(page).to_not have_content(referal_without_allegation_message)
      select 'Promote to referral', from: 'Screening decision'
      expect(page).to have_content('Response time')
      blur
      expect(page).to have_content(referal_without_allegation_message)
      click_button 'Save'
    end

    within '#decision-card.show' do
      expect(page).to have_content('Promote to referral')
      expect(page).to have_content(referal_without_allegation_message)
      expect(page).to have_content(response_time_error_message)
      click_link 'Edit'
    end

    within '#decision-card.edit' do
      expect(page).to have_content(response_time_error_message)
      expect(page).to have_content('Promote to referral')
      select 'Immediate', from: 'Response time'
      expect(page).to have_select('Response time', selected: 'Immediate')
      select '3 days', from: 'Response time'
      expect(page).to have_select('Response time', selected: '3 days')
      select '5 days', from: 'Response time'
      expect(page).to have_select('Response time', selected: '5 days')
      select '10 days', from: 'Response time'
      expect(page).to have_select('Response time', selected: '10 days')
      expect(page).to_not have_content(response_time_error_message)
      click_button 'Save'
    end

    within '#decision-card.show' do
      expect(page).to have_content('Promote to referral')
      expect(page).to_not have_content(response_time_error_message)
      expect(page).to have_content('10 days')
    end
  end

  it 'with Promote to referral having atleast one allegation' do
    decision_error_message = 'Please enter at least one allegation to promote to referral.'
    allegation_error_message = 'Any report that is promoted for referral must include at least one allegation.'

    victim = Participant.victim
    perpetrator = Participant.perpetrator

    expect(page).to have_content "Screening #{screening_page.id}"

    victim[:id] = screening_page.add_new_person victim
    perpetrator[:id] = screening_page.add_new_person perpetrator

    screening_page.set_decision_attributes(screening_decision: 'Promote to referral')

    within '#allegations-card' do
      expect(page).to have_content allegation_error_message
    end

    screening_page.set_allegations_attributes(allegations: [
                                                {
                                                  victim_id: victim[:id],
                                                  perpetrator_id: perpetrator[:id],
                                                  allegation_types: ['Exploitation']
                                                }
                                              ])
    within '#decision-card.edit' do
      expect(page).to have_content('Promote to referral')
      expect(page).not_to have_content(decision_error_message)
      select '10 days', from: 'Response time'
      expect(page).to have_content('10 days')
      click_button 'Save'
    end

    within '#decision-card.show' do
      expect(page).not_to have_content(decision_error_message)
      expect(page).to have_content('Promote to referral')
      expect(page).to have_content('10 days')
    end
  end

  it 'with Screen Out and Category Value' do
    additional_info_required_error_message = 'Please enter additional information'
    within '#decision-card.edit' do
      expect(page).to_not have_content(additional_info_required_error_message)
      select 'Screen out', from: 'Screening decision'
      expect(page).to have_content('Screen out')
      select 'Consultation', from: 'Category'
      expect(page).to have_content('Consultation')
      expect(page.find('label', text: 'Additional information')[:class]).to_not include('required')
      expect(page).to_not have_content(additional_info_required_error_message)
      select 'Evaluate out', from: 'Category'
      expect(page).to have_content('Evaluate out')
      expect(page.find('label', text: 'Additional information')[:class]).to include('required')
      expect(page).to_not have_content(additional_info_required_error_message)
      click_button 'Save'
    end

    within '#decision-card.show' do
      expect(page).to have_content(additional_info_required_error_message)
      expect(page).to have_content('Screen out')
      expect(page).to have_content('Evaluate out')
      click_link 'Edit'
    end
    within '#decision-card.edit' do
      expect(page).to have_content(additional_info_required_error_message)
    end
  end

  describe 'when Acess restriciton' do
    restriciton_rationale = 'Text to confirm Access Restriction'
    access_restriction_error = 'Please enter an access restriction reason'

    it 'is marked as Sensitive' do
      within '#decision-card.edit' do
        expect(page).not_to have_content('Restrictions Rationale')
        select 'Mark as Sensitive', from: 'Access Restrictions'
        expect(page).to have_select('Access Restrictions', selected: 'Mark as Sensitive')
        expect(page).to have_content('Restrictions Rationale')
        expect(page).not_to have_content(access_restriction_error)
        fill_in('Restrictions Rationale', with: '')
        blur
        expect(page).to have_content(access_restriction_error)
        click_button 'Save'
      end

      within '#decision-card.show' do
        expect(page).to have_content('Sensitive')
        expect(page).to have_content(access_restriction_error)
        click_link 'Edit'
      end

      within '#decision-card.edit' do
        expect(page).to have_content(access_restriction_error)
        expect(page).to have_select('Access Restrictions', selected: 'Mark as Sensitive')
        fill_in('Restrictions Rationale', with: restriciton_rationale)
        expect(page).to have_field('Restrictions Rationale', with: restriciton_rationale)
        expect(page).not_to have_content(access_restriction_error)
        click_button 'Save'
      end

      within '#decision-card.show' do
        expect(page).to have_content('Sensitive')
        expect(page).to have_content(restriciton_rationale)
        expect(page).not_to have_content(access_restriction_error)
      end
    end
    it 'is marked as Sealed' do
      within '#decision-card.edit' do
        expect(page).not_to have_content('Restrictions Rationale')
        select 'Mark as Sealed', from: 'Access Restrictions'
        expect(page).to have_select('Access Restrictions', selected: 'Mark as Sealed')
        expect(page).to have_content('Restrictions Rationale')
        expect(page).not_to have_content(access_restriction_error)
        fill_in('Restrictions Rationale', with: '')
        blur
        expect(page).to have_content(access_restriction_error)
        click_button 'Save'
      end

      within '#decision-card.show' do
        expect(page).to have_content('Sealed')
        expect(page).to have_content(access_restriction_error)
        click_link 'Edit'
      end

      within '#decision-card.edit' do
        expect(page).to have_content(access_restriction_error)
        expect(page).to have_select('Access Restrictions', selected: 'Mark as Sealed')
        fill_in('Restrictions Rationale', with: restriciton_rationale)
        expect(page).to have_field('Restrictions Rationale', with: restriciton_rationale)
        expect(page).not_to have_content(access_restriction_error)
        click_button 'Save'
      end

      within '#decision-card.show' do
        expect(page).to have_content('Sealed')
        expect(page).to have_content(restriciton_rationale)
        expect(page).not_to have_content(access_restriction_error)
      end
    end
    it 'is marked as Do not restrict access' do
      within '#decision-card.edit' do
        select 'Do not restrict access', from: 'Access Restrictions'
        expect(page).to have_content('Do not restrict access')
        expect(page).not_to have_content('Restrictions Rationale')
        click_button 'Save'
      end

      within '#decision-card.show' do
        expect(page).not_to have_content(access_restriction_error)
        click_link 'Edit'
      end

      within '#decision-card.edit' do
        expect(page).to have_content('Do not restrict access')
        expect(page).not_to have_content('Restrictions Rationale')
        click_button 'Save'
      end
    end
  end
end
