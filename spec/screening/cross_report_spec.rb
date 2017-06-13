# frozen_string_literal: true

describe 'Cross Report card', type: :feature do
  # Selecting Create Person on homepage
  before do
    visit '/'
    login_user
    click_link 'Start Screening'
  end

  # Set variable to test 128 char limit and fields to accept any chars
  char132str = '0123@567890123G567890123%5678901A345&789' \
    '012345678901234567890123450123@567890123G567890123%5678901A345&789' \
    '01234567890123456789012345'
  char128str = '0123@567890123G567890123%5678901A345&789' \
    '012345678901234567890123450123@567890123G567890123%5678901A345&789' \
    '0123456789012345678901'

  it 'Testing of Cross Report' do
    within '#cross-report-card' do
      within '.card-header' do
        expect(page).to have_content 'Cross Report'
      end
      within '.card-body' do
        # Validate initial rendering of the card
        expect(page).to have_content('This report has cross reported to:')
        expect(page).to have_unchecked_field('District attorney')
        expect(page).to have_unchecked_field('Department of justice')
        expect(page).to have_unchecked_field('Law enforcement')
        expect(page).to have_unchecked_field('Licensing')
        expect(page).not_to have_field('District attorney agency name')
        expect(page).not_to have_field('Department of justice agency name')
        expect(page).not_to have_field('Law enforcement agency name')
        expect(page).not_to have_field('Licensing agency name')
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
        expect(page).to have_content('District attorney')
        expect(page).to have_content('Department of justice')
        expect(page).to have_content('Law enforcement')
        expect(page).to have_content('Licensing')
      end
      within '.card-body' do
        # Verify card is unfilled
        expect(page).to have_content('This report has cross reported to:')
        expect(page).to have_unchecked_field('District attorney')
        expect(page).to have_unchecked_field('Department of justice')
        expect(page).to have_unchecked_field('Law enforcement')
        expect(page).to have_unchecked_field('Licensing')
        expect(page).not_to have_field('District_attorney-agency-name')
        expect(page).not_to have_field('Department_of_justice-agency-name')
        expect(page).not_to have_field('Law_enforcement-agency-name')
        expect(page).not_to have_field('Licensing-agency-name')
        # fill in with allowable alphanumeric and special char
        find('label', text: 'District attorney').click
        fill_in 'District attorney agency name', with: 'Jan 1 $ully'
        find('label', text: 'Department of justice').click
        fill_in 'Department of justice agency name', with: 'S@cramento D0J'
        find('label', text: 'Law enforcement').click
        fill_in 'Law enforcement agency name', with: 'S@crament0 P%lice Dept'
        find('label', text: 'Licensing').click
        fill_in 'Licensing agency name', with: 'C0mmunity Care Licen$ing'
        expect(page).to have_select('Communication Method', options: ['', 'Child Abuse Form', 'Electronic Report',
                                                        'Suspected Child Abuse Report', 'Telephone Report'])
        select 'Suspected Child Abuse Report', from: 'Communication Method'

        fill_in 'Cross Reported on Date', with: '08/23/1654'
        click_button 'Save'
        # Validate information saved
        expect(page).to have_content('This report has cross reported to:')
        expect(page).to have_content('District attorney - Jan 1 $ully')
        expect(page).to have_content('Department of justice - S@cramento D0J')
        expect(page).to have_content('Law enforcement - S@crament0 P%lice Dept')
        expect(page).to have_content('Licensing - C0mmunity Care Licen$ing')
        expect(page).to have_content('Communication Method')
        expect(page).to have_content('Suspected Child Abuse Report')
        expect(page).to have_content('Cross Reported on Date')
        expect(page).to have_content('08/23/1654')
      end
      within '.card-header' do
        click_link 'Edit'
        expect(page).to have_content 'Cross Report'
      end
      within '.card-body' do
        # Validate edit mode fields contain information that was saved
        expect(page).to have_checked_field('District attorney')
        expect(page).to have_field('District_attorney-agency-name',
                                   with: 'Jan 1 $ully')
        expect(page).to have_checked_field('Department of justice')
        expect(page).to have_field('Department_of_justice-agency-name',
                                   with: 'S@cramento D0J')
        expect(page).to have_checked_field('Law enforcement')
        expect(page).to have_field('Law_enforcement-agency-name',
                                   with: 'S@crament0 P%lice Dept')
        expect(page).to have_checked_field('Licensing')
        expect(page).to have_field('Licensing-agency-name',
                                   with: 'C0mmunity Care Licen$ing')
        expect(page).to have_select('Communication Method', selected: 'Suspected Child Abuse Report')
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
        first('label', text: 'District attorney').click
        expect(page).not_to have_content('Jan 1 $ully')
        first('label', text: 'Department of justice').click
        expect(page).not_to have_content('S@cramento D0J')
        first('label', text: 'Law enforcement').click
        expect(page).not_to have_content('S@crament0 P%lice Dept')
        first('label', text: 'Licensing').click
        expect(page).not_to have_content('Community Care Licensing')
        expect(page).to have_unchecked_field('District attorney')
        expect(page).to have_unchecked_field('Department of justice')
        expect(page).to have_unchecked_field('Law enforcement')
        expect(page).to have_unchecked_field('Licensing')
        # revise fields with new data
        first('label', text: 'Licensing').click
        fill_in 'Licensing-agency-name', with: 'Jack Hume'
        li_input = find_field('Licensing agency name')
        9.times do
          li_input.send_keys [:backspace]
        end
        first('label', text: 'District attorney').click
        fill_in 'District_attorney-agency-name', with: 'Jack Hume'
        click_button 'Cancel'
        # Validate data prior to Cancelling is maintained
        expect(page).to have_content('This report has cross reported to:')
        expect(page).to have_content('District attorney - Jan 1 $ully')
        expect(page).to have_content('Department of justice - S@cramento D0J')
        expect(page).to have_content('Law enforcement - S@crament0 P%lice Dept')
        expect(page).to have_content('Licensing - C0mmunity Care Licen$ing')
      end
      within '.card-header' do
        click_link 'Edit'
      end
      # Changing only some of the data
      within '.card-body' do
        fill_in 'District attorney agency name', with: 'Jack Hume'
        le_input = find_field('Law enforcement agency name')
        22.times do
          le_input.send_keys [:backspace]
        end
        click_button 'Save'
        expect(page).to have_content('This report has cross reported to:')
        expect(page).to have_content('District attorney - Jack Hume')
        expect(page).to have_content('Department of justice - S@cramento D0J')
        expect(page).to have_content('Law enforcement')
        expect(page).not_to have_content('S@crament0 P%lice Dept')
        expect(page).to have_content('Licensing - C0mmunity Care Licen$ing')
      end
      within '.card-header' do
        click_link 'Edit'
      end
      # Validating char limit and acceptance of char types for each field
      within '.card-body' do
        first('label', text: 'Licensing').click
        first('label', text: 'Department of justice').click
        first('label', text: 'Law enforcement').click
        fill_in 'District attorney agency name', with: char132str
        expect(page).to have_field('District attorney agency name',
                                   with: char128str)
        click_button 'Save'
        expect(page).to have_content char128str
      end
      within '.card-header' do
        click_link 'Edit'
      end
      within '.card-body' do
        first('label', text: 'Law enforcement').click
        first('label', text: 'District attorney').click
        fill_in 'Law enforcement agency name', with: char132str
        expect(page).to have_field('Law enforcement agency name',
                                   with: char128str)
        click_button 'Save'
        expect(page).to have_content char128str
      end
      within '.card-header' do
        click_link 'Edit'
      end
      within '.card-body' do
        first('label', text: 'Law enforcement').click
        first('label', text: 'Department of justice').click
        fill_in 'Department of justice agency name', with: char132str
        expect(page).to have_field('Department of justice agency name',
                                   with: char128str)
        click_button 'Save'
        expect(page).to have_content char128str
      end
      within '.card-header' do
        click_link 'Edit'
      end
      within '.card-body' do
        first('label', text: 'Department of justice').click
        first('label', text: 'Licensing').click
        fill_in 'Licensing agency name', with: char132str
        expect(page).to have_field('Licensing agency name', with: char128str)
        click_button 'Save'
        expect(page).to have_content char128str
      end
    end
  end
end
