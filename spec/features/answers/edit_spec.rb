require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)
    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    describe 'edits his answer', js: true do
      before do
        sign_in user
        visit question_path(question)
      end

      scenario 'without errors' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Your answer', with: 'lorem ipsum'
          click_on 'Save'

          expect(page).not_to have_content answer.body
          expect(page).to have_content 'lorem ipsum'
          expect(page).not_to have_selector 'textarea'
        end
      end

      scenario 'with errors' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_content "Body can't be blank"
          expect(page).to have_content answer.body
          expect(page).to have_selector 'textarea'
        end
      end
    end

    scenario "can not edit other user's answer" do
      sign_in create(:user)
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end