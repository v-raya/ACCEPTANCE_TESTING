# frozen_string_literal: true

require 'react_select_helpers'
describe 'fail to save a zippy referral', type: :feature do
  describe 'when decision is promote to referral but fields not filled in' do
    it 'displays an error' do
      ScreeningPage
        .new.visit
        .set_decision_attributes(screening_decision: 'Promote to referral', response_time: '3 days')
      click_button 'Submit'
      # wait for the errors to appear after the requests complete
      find('.page-error')
      # there currently is an alert that shows up in allegations that has the same css
      # pattern so this count is written like this.
      expect(all('.error-message .alert-icon i.fa-warning').count).to be >= 1
      total_number_of_errors = all('.error-message .alert-text ul li').count
      expect(find('.page-error')).to have_content(
        "#{total_number_of_errors} error(s) have been identified. Please fix them and try submitting again."
      )
    end
  end
end
