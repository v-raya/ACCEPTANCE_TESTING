# frozen_string_literal: true

describe 'A Social Worker', type: :feature do
  let(:screening) { Screening.new }
  describe 'when submitting screening' do
    before(:each) do
      login_user(path: new_screening_path)
    end

    it 'completes and saves screening information' do
      screening.complete
      expect(page).to have_button('SUBMIT', disabled: false)
    end
  end
end
