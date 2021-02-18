require 'rails_helper'

feature 'User can view list of questions', %q{
  As user
  I'd like to be able to see all questions asked
} do
  scenario 'User can see questions list' do
    questions = 3.times.map do |i|
      create(:question, title: "Question #{i + 1}")
    end
    visit root_path
    3.times { |i| expect(page).to have_content "Question #{i + 1}" }
  end
end