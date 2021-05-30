require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As a answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/e1cb4ac37s/b79046c7161251a5d245e5f4a83a789b' }
  given(:regular_url) { 'http://example.com' }

  before do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body',  with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Velit scelerisque in dictum non.'
    end
  end

  scenario 'User adds (multiple) links when answers question', js: true do
    3.times { click_on 'Add Link' }

    all('.link-fields').each_with_index do |lf, i|
      within lf do
        fill_in 'Link name', with: "Link ##{i + 1}"
        fill_in 'Url',       with: regular_url
      end
    end

    click_on 'Send Answer'

    within '.answers' do
      3.times { |i| expect(page).to have_link "Link ##{i + 1}", href: regular_url }
    end
    expect(page).not_to have_css '.link-fields'
  end

  scenario 'User adds gist when answers question', js: true do
    click_on 'Add Link'

    within '.link-fields' do
      fill_in 'Link name', with: "Gist"
      fill_in 'Url',       with: gist_url
    end

    click_on 'Send Answer'

    within '.answers' do
      expect(page).to have_link "Gist", href: gist_url
      expect(page).to have_css '.gist pre'
      expect(page).not_to have_css '.link-fields'
    end
  end
end