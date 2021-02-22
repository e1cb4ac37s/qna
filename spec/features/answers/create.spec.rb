require 'rails_helper'

feature 'User can create answer', %q{
  As an authenticated user
  I'd like to be able to answer existing question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question.id)
    end

    scenario 'can answer the question' do
      expect(page).to have_content 'Enter your answer:'
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'lorem ipsum'
      click_on 'Send Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'lorem ipsum'
      expect(page).to have_css '.answer'
    end

    scenario 'gives invalid answer to the question' do
      fill_in 'Body', with: '   '
      click_on 'Send Answer'

      expect(page).to have_content 'Answer is invalid, try again'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).not_to have_css '.answer'
    end
  end

  scenario 'Unauthenticated user can not answer the question' do
    visit question_path(question.id)

    expect(page).not_to have_content 'Enter your answer:'
  end
end