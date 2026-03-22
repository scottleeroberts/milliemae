require "rails_helper"

RSpec.describe "Authentication", type: :system do
  describe "sign up" do
    it "creates an account and signs in" do
      visit new_user_registration_path

      fill_in "Name", with: "Jane Maker"
      fill_in "Email", with: "jane@example.com"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Sign up"

      expect(page).to have_text("Jane Maker")
      expect(page).to have_text("Sign out")
      expect(User.last).to be_audience
    end

    it "shows errors when fields are missing" do
      visit new_user_registration_path
      click_button "Sign up"

      expect(page).to have_text("can't be blank")
    end
  end

  describe "sign in and out" do
    let!(:user) { create(:user, name: "Existing User", email: "existing@example.com", password: "password123") }

    it "signs in with valid credentials and signs out" do
      visit new_user_session_path
      fill_in "Email", with: "existing@example.com"
      fill_in "Password", with: "password123"
      click_button "Log in"

      expect(page).to have_text("Existing User")
      expect(page).to have_text("Sign out")

      click_on "Sign out"
      expect(page).to have_text("Sign in")
    end

    it "shows an error with invalid credentials" do
      visit new_user_session_path
      fill_in "Email", with: "existing@example.com"
      fill_in "Password", with: "wrongpassword"
      click_button "Log in"

      expect(page).to have_text("Invalid email or password")
    end
  end
end
