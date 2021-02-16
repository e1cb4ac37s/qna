require 'rails_helper'

feature 'User can create answer', %q{
  As an authenticated user
  I'd like to be able to answer existing question
} do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'answers the question' do
      sign_in(create(:user))
      visit question_path(question.id)
      fill_in 'Body', with: 'lorem ipsum'
      click_on 'Send Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'lorem ipsum'
      expect(page).to have_css 'form.new-answer'
    end
  end

  scenario 'Unauthenticated user can not answer the question' do
    visit question_path(question.id)

    expect(page).not_to have_css 'form.new-answer'
  end
end