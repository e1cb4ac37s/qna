require 'rails_helper'

feature 'User can delete answer', %q{
  As an authenticated user
  I'd like to be able to delete given answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, user_id: user.id, question: question, body: 'answer body') }

  describe 'Authenticated user', js: true do
    scenario 'deletes her answer' do
      sign_in(user)
      visit question_path(question)
      click_on class: 'answer__delete'

      expect(page).not_to have_content answer.body
    end

    scenario "can not delete another user's answer" do
      another_user = create(:user)
      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_css '.answer__delete'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not delete answer' do
      visit question_path(question)

      expect(page).not_to have_css '.answer__delete'
    end
  end
end