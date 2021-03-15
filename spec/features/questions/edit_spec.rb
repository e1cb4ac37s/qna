require 'rails_helper'

feature 'User can create question', %q{
  In order to correct mistakes in my question
  As an authenticated user
  I'd like to be able to edit the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      within '.question__actions' do
        click_on 'Edit'
      end
    end

    scenario 'edits the question title' do
      within '.question' do
        expect(page).to have_selector 'input'
      end

      new_title = 'New question title'
      fill_in 'Title', with: new_title

      click_on 'Save'

      expect(page).to have_content new_title
    end

    scenario 'edits the question body' do
      within '.question' do
        expect(page).to have_selector 'textarea'

        new_body = 'New question body'
        fill_in 'Body', with: new_body
        click_on 'Save'

        expect(page).to have_content new_body
      end
    end

    scenario 'adds files while editing question' do
      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits the question with errors' do
      within '.question' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content question.body
      end
    end
  end

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).not_to have_selector '.question__actions'
  end

  scenario "Authenticated user can not edit other user's question" do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).not_to have_selector '.question__actions'
  end
end