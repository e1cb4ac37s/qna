require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions and provide answers
  As an unregistered user
  I'd like to sign up
} do
  scenario 'Unauthenticated user can register' do
    visit root_path

    expect(page).to have_content 'Register'
  end

  scenario 'Authenticated user can not register' do
    sign_in(create(:user))
    visit root_path

    expect(page).not_to have_content 'Register'
  end

  describe 'Unauthenticated user tries to sign up ' do
    background do
      visit new_user_registration_path
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
    end

    scenario 'with new email' do
      fill_in 'Email', with: 'johndoe@example.com'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'with existing email' do
      user = create(:user)

      fill_in 'Email', with: user.email
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end