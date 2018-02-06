# frozen_string_literal: true

require 'active_support/core_ext/numeric/time'

describe 'Screening Validation QA Test', type: :feature do
  before do
    visit '/'
    login_user
    click_button 'Start Screening'
  end

  describe 'screening information card validations' do
    context 'with required fields' do
      let(:required_field_error_messages) do
        {
          'Assigned Social Worker' => 'Please enter an assigned worker.',
          'Communication Method' => 'Please select a communication method.'
        }
      end

      it 'validates required fields' do
        within '#screening-information-card' do
          required_field_error_messages.each do |label, expected_error_message|
            expect(page).to_not have_content(expected_error_message)
            focus(label)
            expect(page).to_not have_content(expected_error_message)
            blur
            expect(page).to have_content(expected_error_message)
          end

          click_button 'Save'

          required_field_error_messages.each do |_label, expected_error_message|
            expect(page).to have_content(expected_error_message)
          end
        end
      end

      it 'validates start date required' do
        label = 'Screening Start Date/Time'
        expected_error_message = 'Please enter a screening start date.'

        within '#screening-information-card' do
          fill_in_datepicker('Screening Start Date/Time', with: '', blur: false)
          expect(page).to_not have_content(expected_error_message)
          focus(label)
          expect(page).to_not have_content(expected_error_message)
          blur
          expect(page).to have_content(expected_error_message)
        end
      end

      it 're-validates required fields' do
        started_error_message = 'Please enter a screening start date.'
        within '#screening-information-card' do
          fill_in_datepicker('Screening Start Date/Time', with: '', blur: true)
          required_field_error_messages.each do |label, expected_error_message|
            expect(page).to_not have_content(expected_error_message)
            focus(label)
            blur
            expect(page).to have_content(expected_error_message)
          end
          expect(page).to have_content(started_error_message)

          fill_in('Assigned Social Worker', with: 'John Worker')
          fill_in_datepicker('Screening Start Date/Time', with: 3.days.ago)
          select('Mail', from: 'Communication Method')

          click_button 'Save'

          required_field_error_messages.each do |_label, expected_error_message|
            expect(page).to_not have_content(expected_error_message)
          end
        end
      end

      it 'clears errors on change' do
        within '#screening-information-card' do
          required_field_error_messages.each do |label, expected_error_message|
            expect(page).to_not have_content(expected_error_message)
            focus(label)
            blur
            expect(page).to have_content(expected_error_message)
          end

          fill_in('Assigned Social Worker', with: 'John Worker')
          expect(page).to_not have_content('Please enter an assigned worker.')
          select('Mail', from: 'Communication Method')
          expect(page).to_not have_content('Please select a communication method.')
        end
      end

      it 'clears errors on change for date picker' do
        pending 'Known bug onChange does not work for date picker fields'

        within '#screening-information-card' do
          label = 'Screening Start Date/Time'
          expected_error_message = 'Please enter a screening start date.'

          expect(page).to_not have_content(expected_error_message)
          focus(label)
          blur
          expect(page).to have_content(expected_error_message)

          fill_in_datepicker('Screening Start Date/Time', with: 3.days.ago, blur: false)
          expect(page).to_not have_content(expected_error_message)
        end
      end
    end

    context 'with future dates' do
      let(:future_dates_error_messages) do
        [
          [
            'Screening Start Date/Time',
            'The start date and time cannot be in the future.',
            40.days.from_now,
            2.days.ago
          ],
          [
            'Screening End Date/Time',
            'The end date and time cannot be in the future.',
            42.days.from_now,
            Time.now
          ]
        ]
      end

      it 'validates dates cannot be in the future' do
        within '#screening-information-card' do
          future_dates_error_messages.each do |label, expected_error_message, future, past|
            expect(page).to_not have_content(expected_error_message)
            fill_in_datepicker(label, with: future, blur: false)
            expect(page).to_not have_content(expected_error_message)
            blur
            expect(page).to have_content(expected_error_message)
            fill_in_datepicker(label, with: past, blur: false)
            expect(page).to have_content(expected_error_message)
            blur
            fill_in_datepicker(label, with: Time.now, blur: true)
            expect(page).to_not have_content(expected_error_message)
            fill_in_datepicker(label, with: future, blur: false)
          end

          click_button 'Save'

          future_dates_error_messages.each do |_label, expected_error_message|
            expect(page).to have_content(expected_error_message)
          end
        end
      end
    end

    context 'with multiple errors' do
      let(:expected_error_messages) do
        [
          'The start date and time must be before the end date and time.',
          'The start date and time cannot be in the future.'
        ]
      end

      it 'shows both errors' do
        within '#screening-information-card' do
          fill_in_datepicker('Screening Start Date/Time', with: 15.days.from_now)
          fill_in_datepicker('Screening End Date/Time', with: 10.days.from_now)

          focus('Screening Start Date/Time')
          blur

          expected_error_messages.each do |expected_error_message|
            expect(page).to have_content(expected_error_message)
          end

          click_button 'Save'

          expected_error_messages.each do |expected_error_message|
            expect(page).to have_content(expected_error_message)
          end
        end
      end
    end

    context 'with start date after end date' do
      let(:twenty_days_ago) { 20.days.ago }
      let(:ten_days_ago) { 10.days.ago }
      let(:expected_error_message) { 'The start date and time must be before the end date and time.' }

      it 'validates start date with no end date' do
        within '#screening-information-card' do
          expect(page).to_not have_content(expected_error_message)
          fill_in_datepicker('Screening Start Date/Time', with: ten_days_ago)
          expect(page).to_not have_content(expected_error_message)
          focus('Screening Start Date/Time')
          blur
          expect(page).to_not have_content(expected_error_message)

          click_button 'Save'

          expect(page).to_not have_content(expected_error_message)
        end
      end

      it 'validates start date cannot be after end date' do
        within '#screening-information-card' do
          expect(page).to_not have_content(expected_error_message)
          fill_in_datepicker('Screening Start Date/Time', with: ten_days_ago)
          expect(page).to_not have_content(expected_error_message)

          fill_in_datepicker('Screening End Date/Time', with: twenty_days_ago, blur: false)
          expect(page).to_not have_content(expected_error_message)
          focus('Screening Start Date/Time')
          blur
          expect(page).to have_content(expected_error_message)

          click_button 'Save'

          expect(page).to have_content(expected_error_message)
        end
      end
    end
  end
end
