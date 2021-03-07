require 'rails_helper'

feature 'User can select best answer for asked question', %q{
  In order to mark answer, which helped with my problem
  In a best way
  As an owner of the question
  I'd like to be able to mark best answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user, body: 'answer 2 body') }

  describe 'Authenticated user' do
    scenario "can't select best answer for other user's question" do
      sign_in(create(:user))
      visit question_path(question)

      expect(page).not_to have_link 'Best!'
    end
    describe do
      before do
        sign_in(user)
        visit question_path(question)
      end

      describe 'as author of the question', js: true do
        before do
          within "#answer-#{answer2.id}" do
            click_on 'Best!'
          end
        end

        scenario 'selects best answer' do
          expect(page).to have_content '[Best Answer]'
        end

        scenario 'sees best answer once on a page' do
          expect(page).to have_selector("#answer-#{answer2.id}", count: 1)
        end

        scenario 'selects another best answer' do
          within "#answer-#{answer.id}" do
            click_on 'Best!'
          end

          within ".answer--best" do
            expect(page).to have_content answer.body
            expect(page).not_to have_content answer2.body
          end
        end

        scenario 'deletes best answer' do
          within "#answer-#{answer2.id}" do
            click_on 'Delete'
          end

          expect(page).not_to have_content '[Best Answer]'
          expect(page).not_to have_content answer2.body
        end
      end
    end
  end

  scenario 'Unauthenticated user can not mark answer as best' do
    expect(page).not_to have_link 'Best!'
  end
end