# frozen_string_literal: true

describe 'Social Worker', type: :feature do
  let(:screening) { Screening.new }
  describe 'submit screening' do
    before(:each) do
      login_user(path: new_screening_path)
    end

    it 'complete and save screening information' do
      screening.complete
      expect(page).to have_button('SUBMIT', disabled: false)
    end
  end
end
