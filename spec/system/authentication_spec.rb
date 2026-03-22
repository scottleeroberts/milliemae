require "rails_helper"

RSpec.describe "Authentication", type: :system do
  it "allows a new user to sign up" do
    visit new_user_registration_path

    fill_in "Name", with: "Jane Maker"
    fill_in "Email", with: "jane@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Sign up"

    expect(page).to have_text("Jane Maker")
    expect(page).to have_text("Sign out")
  end

  it "allows an existing user to sign in and out" do
    create(:user, email: "existing@example.com", password: "password123")

    visit new_user_session_path
    fill_in "Email", with: "existing@example.com"
    fill_in "Password", with: "password123"
    click_button "Log in"

    expect(page).to have_text("Sign out")

    click_on "Sign out"
    expect(page).to have_text("Sign in")
  end
end
