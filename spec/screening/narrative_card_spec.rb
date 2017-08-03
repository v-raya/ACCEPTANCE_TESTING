# frozen_string_literal: true

describe 'Narrative card', type: :feature do
  context 'with valid values' do
    let(:screening_page) { ScreeningPage.new }

    it 'Testing narrative card' do
      screening_page.visit_screening

      within '#narrative-card' do
        within '.card-header' do
          expect(page).to have_content('Narrative')
        end
        expect(page).not_to have_css('.input-error-message', text: 'Please enter a narrative')

        # Saving a blank card and validating
        click_button 'Save'
        within '.card-body' do
          expect(page).to have_content('Report Narrative')
        end

        within '.input-error-message' do
          expect(page).to have_content('Please enter a narrative')
        end

        within '.card-header' do
          expect(page).to have_content('Narrative')
          click_link 'Edit'
        end

        within '.card-body' do
          fill_in 'Report Narrative', with: 'P'
          click_button 'Save'
          expect(page).to have_content('P')
        end

        within '.card-header' do
          click_link 'Edit'
        end

        within '.card-body' do
          fill_in 'Report Narrative',
                  with: 'Fr1ends, Rom@ns, countrymen, 1end me your ears;'
          click_button 'Save'
          expect(page).to have_content(
            'Fr1ends, Rom@ns, countrymen, 1end me your ears;'
          )
        end

        expect(page).not_to have_css('.input-error-message', text: 'Please enter a narrative')
        within '.card-header' do
          click_link 'Edit'
        end

        within '.card-body' do
          expect(page).to have_field(
            'Report Narrative',
            with: 'Fr1ends, Rom@ns, countrymen, 1end me your ears;'
          )
          fill_in 'Report Narrative', with: 'Et Tu Brute?'
          # Verify new data was not saved on 'Cancel'
          click_button 'Cancel'
          expect(page).to have_content(
            'Fr1ends, Rom@ns, countrymen, 1end me your ears;'
          )
        end
        expect(page).not_to have_css('.input-error-message', text: 'Please enter a narrative')
      end
    end
  end

  context 'with errors' do
    let(:screening_page) { ScreeningPage.new }

    before do
      screening_page.visit_screening
    end

    it 'notifies the user when they focus out' do
      within '#narrative-card.edit' do
        expect(page).not_to have_css('.input-error-message', text: 'Please enter a narrative')

        focus 'Report Narrative'
        blur

        within '.input-error-message' do
          expect(page).to have_content('Please enter a narrative')
        end
      end
    end

    it 'shows error message on show card after save' do
      within '#narrative-card.edit' do
        focus 'Report Narrative'

        click_button 'Save'
      end

      within '#narrative-card .input-error-message' do
        expect(page).to have_content('Please enter a narrative')
      end
    end

    it 'removes error when field is fixed' do
      timestamp = Time.now.to_i

      within '#narrative-card.edit' do
        fill_in 'Report Narrative', with: '   '
        blur

        within '.input-error-message' do
          expect(page).to have_content('Please enter a narrative')
        end

        fill_in 'Report Narrative', with: "Valid data #{timestamp}"

        within '.input-error-message' do
          expect(page).not_to have_content('Please enter a narrative')
        end

        click_button 'Save'
      end

      within '#narrative-card' do
        expect(page).to have_content("Valid data #{timestamp}")
        within '.input-error-message' do
          expect(page).not_to have_content('Please enter a narrative')
        end
      end
    end
  end
end
