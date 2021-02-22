require 'rails_helper'

feature 'User can view list of questions', %q{
  As user
  I'd like to be able to see all questions asked
} do
  scenario 'User can see questions list' do
    user = create(:user)
    questions = 3.times.map do |i|
      create(:question, title: "Question #{i + 1}", user: user)
    end
    visit root_path
    questions.each { |q| expect(page).to have_content q.body }
  end
end