require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Authenticated user can not sign in' do
    sign_in(user)
    visit root_path

    expect(page).not_to have_content 'Sign in'
  end

  scenario 'Unauthenticated user can sign in' do
    visit root_path

    expect(page).to have_content 'Sign in'
  end

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong_user@test.com'
    fill_in 'Password', with: 'password'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end