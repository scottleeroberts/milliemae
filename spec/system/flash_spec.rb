require "rails_helper"

RSpec.describe "Flash messages", type: :system do
  it "dismisses an alert when the close button is clicked" do
    visit new_user_session_path
    fill_in "Email", with: "missing@example.com"
    fill_in "Password", with: "wrongpassword"
    click_button "Log in"

    expect(page).to have_text("Invalid email or password")

    find('button[aria-label="Dismiss"]').click

    expect(page).not_to have_text("Invalid email or password")
  end
end
