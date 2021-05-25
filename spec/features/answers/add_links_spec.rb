require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As a answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/e1cb4ac37s/b79046c7161251a5d245e5f4a83a789b' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body',      with: 'Test answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url',       with: gist_url
      click_on 'Send Answer'
    end

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end