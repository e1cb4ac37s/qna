require 'rails_helper'

feature 'User can delete question', %q{
  As an authenticated user
  I'd like to be able to delete asked question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  describe 'Authenticated user' do
    scenario 'deletes her question' do
      sign_in(user)
      visit question_path(question)
      click_on class: 'question__delete'

      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario "can not delete another user's question" do
      another_user = create(:user)
      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_css '.question__delete'
    end
  end

  scenario 'Unauthenticated can not delete question' do
    visit question_path(question)

    expect(page).not_to have_css '.question__delete'
  end
end