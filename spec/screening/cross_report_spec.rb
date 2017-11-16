# frozen_string_literal: true

describe 'Cross Report card', type: :feature do
  # Selecting Create Person on homepage
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  it 'Testing of Cross Report' do
    within '#cross-report-card' do
      within '.card-header' do
        expect(page).to have_content 'Cross Report'
      end
      within '.card-body' do
        # Validate initial rendering of the card
        expect(page).to have_content('This report has cross reported to:')
        expect(page).to have_select('County', options: [
          '',
          'Alameda',
          'Alpine',
          'Amador',
          'Butte',
          'Calaveras',
          'Colusa',
          'Contra Costa',
          'Del Norte',
          'El Dorado',
          'Fresno',
          'Glenn',
          'Humboldt',
          'Imperial',
          'Inyo',
          'Kern',
          'Kings',
          'Lake',
          'Lassen',
          'Los Angeles',
          'Madera',
          'Marin',
          'Mariposa',
          'Mendocino',
          'Merced',
          'Modoc',
          'Mono',
          'Monterey',
          'Napa',
          'Nevada',
          'Orange',
          'Placer',
          'Plumas',
          'Riverside',
          'Sacramento',
          'San Benito',
          'San Bernardino',
          'San Diego',
          'San Francisco',
          'San Joaquin',
          'San Luis Obispo',
          'San Mateo',
          'Santa Barbara',
          'Santa Clara',
          'Santa Cruz',
          'Shasta',
          'Sierra',
          'Siskiyou',
          'Solano',
          'Sonoma',
          'Stanislaus',
          'State of California',
          'Sutter',
          'Tehama',
          'Trinity',
          'Tulare',
          'Tuolumne',
          'Ventura',
          'Yolo',
          'Yuba'
        ])
        select 'Fresno', from: 'County'
        expect(page).to have_unchecked_field('District attorney')
        expect(page).to have_unchecked_field('Department of justice')
        expect(page).to have_unchecked_field('Law enforcement')
        expect(page).to have_unchecked_field('Community care licensing')
        expect(page).to have_unchecked_field('County licensing')
        expect(page).not_to have_field('District attorney agency name')
        expect(page).not_to have_field('Department of justice agency name')
        expect(page).not_to have_field('Law enforcement agency name')
        expect(page).not_to have_field('Commuity care licensing agency name')
        expect(page).not_to have_field('County licensing agency name')
        expect(page).not_to have_css('legend', text: 'Communication Time and Method')
        expect(page).not_to have_field('Cross Reported on Date')
        expect(page).not_to have_field('Communication Method')
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
        click_button 'Save'
        # Verify nothing on show view except headers
        expect(page).to have_content('This report has cross reported to:')
      end
      # Verify that saving a blank card results in no data being saved.
      within '.card-header' do
        expect(page).to have_content 'Cross Report'
        click_link 'Edit'
        expect(page).to have_content 'Cross Report'
      end

      within '.card-body' do
        # validate no value other than header are displayed
        expect(page).to have_content('This report has cross reported to:')
        select 'Fresno', from: 'County'
        expect(page).to have_content('District attorney')
        expect(page).to have_content('Department of justice')
        expect(page).to have_content('Law enforcement')
        expect(page).to have_content('Community care licensing')
        expect(page).to have_content('County licensing')
      end
      within '.card-body' do
        # Verify card is unfilled
        expect(page).to have_content('This report has cross reported to:')
        expect(page).to have_unchecked_field('District attorney')
        expect(page).to have_unchecked_field('Department of justice')
        expect(page).to have_unchecked_field('Law enforcement')
        expect(page).to have_unchecked_field('Community care licensing')
        expect(page).to have_unchecked_field('County licensing')
        expect(page).not_to have_field('DISTRICT_ATTORNEY-agency-name')
        expect(page).not_to have_field('DEPARTMENT_OF_JUSTICE-agency-name')
        expect(page).not_to have_field('LAW_ENFORCEMENT-agency-name')
        expect(page).not_to have_field('COUNTY_LICENSING-agency-name')
        expect(page).not_to have_field('COMMUNITY_CARE_LICENSING-agency-name')
        # fill in with allowable alphanumeric and special char
        find('label', text: 'District attorney').click
        select 'Fresno County DA', from: 'District attorney agency name'
        find('label', text: 'Department of justice').click
        select 'Demo Department of Justice', from: 'Department of justice agency name'
        find('label', text: 'Law enforcement').click
        select 'Fresno Police Dept', from: 'Law enforcement agency name'
        find('label', text: 'County licensing').click
        select 'Demo County Licensing', from: 'County licensing agency name'
        find('label', text: 'Community care licensing').click
        select 'Demo Community Care Licensing', from: 'Community care licensing agency name'
        expect(page).to have_select('Communication Method', options: [
          '',
          'Child Abuse Form',
          'Electronic Report',
          'Suspected Child Abuse Report',
          'Telephone Report'
        ])
        select 'Suspected Child Abuse Report', from: 'Communication Method'

        fill_in 'Cross Reported on Date', with: '08/23/1654'
        click_button 'Save'
        # Validate information saved
        expect(page).to have_content('This report has cross reported to:')
        expect(page).to have_content('District attorney - Fresno County DA')
        expect(page).to have_content('Department of justice - Demo Department of Justice')
        expect(page).to have_content('Law enforcement - Fresno Police Dept')
        expect(page).to have_content('County licensing - Demo County Licensing')
        expect(page).to have_content(
          'Community care licensing - Demo Community Care Licensing'
        )
        expect(page).to have_content('Communication Method Suspected Child Abuse Report')
        expect(page).to have_content('Cross Reported on Date 08/23/1654')
      end
      within '.card-header' do
        click_link 'Edit'
        expect(page).to have_content 'Cross Report'
      end
      within '.card-body' do
        # Validate edit mode fields contain information that was saved
        expect(page).to have_checked_field('District attorney')
        expect(page).to have_select('District attorney agency name',
                                   selected: 'Fresno County DA')
        expect(page).to have_checked_field('Department of justice')
        expect(page).to have_select('Department of justice agency name',
                                   selected: 'Demo Department of Justice')
        expect(page).to have_checked_field('Law enforcement')
        expect(page).to have_select('Law enforcement agency name',
                                   selected: 'Fresno Police Dept')
        expect(page).to have_checked_field('County licensing')
        expect(page).to have_select('County licensing agency name',
                                   selected: 'Demo County Licensing')
        expect(page).to have_checked_field('Community care licensing')
        expect(page).to have_select('Community care licensing agency name',
                                   selected: 'Demo Community Care Licensing')
        expect(page).to have_select('Communication Method', selected: 'Suspected Child Abuse Report')
        expect(page).to have_field('Cross Reported on Date', with: '08/23/1654')
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
        first('label', text: 'District attorney').click
        expect(page).not_to have_content('Fresno County DA')
        first('label', text: 'Department of justice').click
        expect(page).not_to have_content('Demo Department of Justice')
        first('label', text: 'Law enforcement').click
        expect(page).not_to have_content('Fresno Police Dept')
        first('label', text: 'County licensing').click
        expect(page).not_to have_content('Demo County Licensing')
        first('label', text: 'Community care licensing').click
        expect(page).not_to have_content('Demo Community Care Licensing')
        expect(page).to have_unchecked_field('District attorney')
        expect(page).to have_unchecked_field('Department of justice')
        expect(page).to have_unchecked_field('Law enforcement')
        expect(page).to have_unchecked_field('County licensing')
        expect(page).to have_unchecked_field('Community care licensing')
        # revise fields with new data
        find('label', text: 'Community care licensing').click
        select 'The Agency', from: 'Community care licensing agency name'
        find('label', text: 'District attorney').click
        select 'Demo District Attorney', from: 'District attorney agency name'
        click_button 'Cancel'
        # Validate data prior to Cancelling is maintained
        expect(page).to have_content('This report has cross reported to:')
        expect(page).to have_content('District attorney - Fresno County DA')
        expect(page).to have_content('Department of justice - Demo Department of Justice')
        expect(page).to have_content('Law enforcement - Fresno Police Dept')
        expect(page).to have_content('County licensing - Demo County Licensing')
        expect(page).to have_content(
          'Community care licensing - Demo Community Care Licensing'
        )
        expect(page).to have_content('Communication Method Suspected Child Abuse Report')
        expect(page).to have_content('Cross Reported on Date 08/23/1654')
      end
      within '.card-header' do
        click_link 'Edit'
      end
      # Changing only some of the data
      within '.card-body' do
        select 'Demo District Attorney', from: 'District attorney agency name'
        click_button 'Save'
        expect(page).to have_content('This report has cross reported to:')
        expect(page).to have_content('District attorney - Demo District Attorney')
        expect(page).to have_content('Department of justice - Demo Department of Justice')
        expect(page).to have_content('Law enforcement - Fresno Police Dept')
        expect(page).to have_content('County licensing - Demo County Licensing')
        expect(page).to have_content(
          'Community care licensing - Demo Community Care Licensing'
        )
        expect(page).to have_content('Communication Method Suspected Child Abuse Report')
        expect(page).to have_content('Cross Reported on Date 08/23/1654')
      end
    end
  end
end
