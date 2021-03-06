require 'rails_helper'

feature 'User can create answer', %q{
  As an authenticated user
  I'd like to be able to answer existing question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
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

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      within '.answers' do
        expect(page).to have_content 'lorem ipsum'
        expect(page).to have_css '.answer'
      end
    end

    scenario 'gives invalid answer to the question' do
      fill_in 'Body', with: '   '
      click_on 'Send Answer'

      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).not_to have_css '.answer'
    end

    scenario 'gives answer with attached files' do
      fill_in 'Body', with: 'lorem ipsum'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Send Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user can not answer the question' do
    visit question_path(question.id)

    expect(page).not_to have_content 'Enter your answer:'
  end
end