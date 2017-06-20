require 'spec_helper'

feature 'Release Two Enabled' do
  scenario 'hide list of screenings on home page' do
    visit '/'
    login_user
    expect(page).not_to have_css 'table'
  end

  scenario 'edit an existing screening' do
    visit '/'
    login_user
    click_link 'Start Screening'

    within '#snapshot-card' do
      expect(page).to have_content(
        <<-STRING
        The Child Welfare History Snapshot allows you to search CWS/CMS for people and their past
        history with CWS. To start, search by any combination of name, date of birth, or social
        security number. Click on a person from the results to add them to the Snapshot, and their
        basic information and history will automatically appear below. You can add as many people
        as you like, and when ready, copy the summary of their history. You will need to manually
        paste it into a document or a field in CWS/CMS.
        STRING
      )
    end
    expect(page).to have_css('.card', text: 'Search')
    expect(page).to have_css('.card', text: 'History')

    expect(page).to_not have_content('Edit Screening')
    expect(page).to_not have_css('.card', text: 'Screening Information')
    expect(page).to_not have_css('.card', text: 'Narrative')
    expect(page).to_not have_css('.card', text: 'Incident Information')
    expect(page).to_not have_css('.card', text: 'Allegations')
    expect(page).to_not have_css('.card', text: 'Relationships')
    expect(page).to_not have_css('.card', text: 'Worker Safety')
    expect(page).to_not have_css('.card', text: 'Cross Report')
    expect(page).to_not have_css('.card', text: 'Decision')
  end
end

