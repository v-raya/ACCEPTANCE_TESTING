describe 'Cross Report card', type: :feature do
  # Selecting Create Person on homepage
  before do
    visit '/'
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
        expect(page).to have_content 'CROSS REPORT'
      end
      within '.card-body' do
        # Validate initial rendering of the card
        expect(page).to have_content('Cross reported to')
        expect(page).to have_unchecked_field('District attorney')
        expect(page).to have_unchecked_field('Department of justice')
        expect(page).to have_unchecked_field('Law enforcement')
        expect(page).to have_unchecked_field('Licensing')
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
        click_button 'Save'
      end
      # Test that saving saving a blank card results in no data being saved.
      within '.card-header' do
        find(:css, 'i.fa.fa-pencil').click
        expect(page).to have_content 'CROSS REPORT'
      end
      within '.card-body' do
        # validate no value other than header are displayed
        expect(page).to have_content('Cross reported to')
        expect(page).to have_content('District attorney')
        expect(page).to have_content('Department of justice')
        expect(page).to have_content('Law enforcement')
        expect(page).to have_content('Licensing')
      end
      within '.card-body' do
        # fill in with allowable alphanumeric and special char
        find('label', text: 'District attorney').click
        fill_in 'District_attorney-agency-name', with: 'Jan 1 $ully'
        find('label', text: 'Department of justice').click
        fill_in 'Department_of_justice-agency-name', with: 'S@cramento D0J'
        find('label', text: 'Law enforcement').click
        fill_in 'Law_enforcement-agency-name', with: 'S@crament0 P%lice Dept'
        find('label', text: 'Licensing').click
        fill_in 'Licensing-agency-name', with: 'C0mmunity Care Licen$ing'
        click_button 'Save'
        # Validate information saved
        expect(page).to have_content('Cross reported to')
        expect(page).to have_content('District attorney - Jan 1 $ully')
        expect(page).to have_content('Department of justice - S@cramento D0J')
        expect(page).to have_content('Law enforcement - S@crament0 P%lice Dept')
        expect(page).to have_content('Licensing - C0mmunity Care Licen$ing')
      end
      within '.card-header' do
        # click on the pencil icon in header to invoke the edit page
        find(:css, 'i.fa.fa-pencil').click
        expect(page).to have_content 'CROSS REPORT'
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
        expect(page).to have_button 'Cancel'
        expect(page).to have_button 'Save'
        find('label', text: 'District attorney').click
        expect(page).not_to have_content('Jan Sully')
        find('label', text: 'Department of justice').click
        expect(page).not_to have_content('Sacramento DOJ')
        find('label', text: 'Law enforcement').click
        expect(page).not_to have_content('S@crament0 P%lice Dept')
        find('label', text: 'Licensing').click
        expect(page).not_to have_content('Community Care Licensing')
        expect(page).to have_unchecked_field('District attorney')
        expect(page).to have_unchecked_field('Department of justice')
        expect(page).to have_unchecked_field('Law enforcement')
        expect(page).to have_unchecked_field('Licensing')
        # revise fields with new data
        find('label', text: 'District attorney').click
        fill_in 'District_attorney-agency-name', with: 'Jack Hume'
        click_button 'Cancel'
        # Validate data prior to Cancelling is maintained
        expect(page).to have_content('Cross reported to')
        expect(page).to have_content('District attorney - Jan 1 $ully')
        expect(page).to have_content('Department of justice - S@cramento D0J')
        expect(page).to have_content('Law enforcement - S@crament0 P%lice Dept')
        expect(page).to have_content('Licensing - C0mmunity Care Licen$ing')
      end
      within '.card-header' do
        # click on the pencil icon in header to invoke the edit page
        find(:css, 'i.fa.fa-pencil').click
      end
      # Changing only some of the data
      within '.card-body' do
        fill_in 'District_attorney-agency-name', with: 'Jack Hume'
        le_input = find_field('Law_enforcement-agency-name')
        22.times do
          le_input.send_keys [:backspace]
        end
        click_button 'Save'
        expect(page).to have_content('Cross reported to')
        expect(page).to have_content('District attorney - Jack Hume')
        expect(page).to have_content('Department of justice - S@cramento D0J')
        expect(page).to have_content('Law enforcement')
        expect(page).not_to have_content('S@crament0 P%lice Dept')
        expect(page).to have_content('Licensing - C0mmunity Care Licen$ing')
      end
      within '.card-header' do
        # click on the pencil icon in header to invoke the edit page
        find(:css, 'i.fa.fa-pencil').click
      end
      # Validating char limit and acceptance of char types for each field
      within '.card-body' do
        find('label', text: 'Licensing').click
        find('label', text: 'Department of justice').click
        find('label', text: 'Law enforcement').click
        fill_in 'District_attorney-agency-name', with: char132str
        expect(page).to have_field('District_attorney-agency-name',
                                   with: char128str)
        click_button 'Save'
        expect(page).to have_content char128str
      end
      within '.card-header' do
        # click on the pencil icon in header to invoke the edit page
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        find('label', text: 'Law enforcement').click
        find('label', text: 'District attorney').click
        fill_in 'Law_enforcement-agency-name', with: char132str
        expect(page).to have_field('Law_enforcement-agency-name',
                                   with: char128str)
        click_button 'Save'
        expect(page).to have_content char128str
      end
      within '.card-header' do
        # click on the pencil icon in header to invoke the edit page
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        find('label', text: 'Law enforcement').click
        find('label', text: 'Department of justice').click
        fill_in 'Department_of_justice-agency-name', with: char132str
        expect(page).to have_field('Department_of_justice-agency-name',
                                   with: char128str)
        click_button 'Save'
        expect(page).to have_content char128str
      end
      within '.card-header' do
        # click on the pencil icon in header to invoke the edit page
        find(:css, 'i.fa.fa-pencil').click
      end
      within '.card-body' do
        find('label', text: 'Department of justice').click
        find('label', text: 'Licensing').click
        fill_in 'Licensing-agency-name', with: char132str
        expect(page).to have_field('Licensing-agency-name', with: char128str)
        click_button 'Save'
        expect(page).to have_content char128str
      end
    end
  end
end
