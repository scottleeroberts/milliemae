require "rails_helper"

RSpec.describe "Invitation acceptance", type: :system do
  let!(:invitation) { create(:invitation, email: "newcreator@example.com") }

  it "user accepts invitation and becomes a creator" do
    visit invitation_path(invitation.token)

    expect(page).to have_content("Create your creator account")
    expect(page).to have_field("Email", disabled: true, with: "newcreator@example.com")

    fill_in "user[name]", with: "Jane Smith"
    fill_in "user[password]", with: "password123"
    fill_in "user[password_confirmation]", with: "password123"
    click_button "Create my account"

    expect(page).to have_content("Welcome to Sew Twirly")
    expect(page).to have_content("My Projects")

    user = User.find_by(email: "newcreator@example.com")
    expect(user).to be_present
    expect(user.role).to eq("creator")
    expect(invitation.reload.accepted?).to be true
  end

  it "shows an error for an invalid token" do
    visit invitation_path("invalid-token")
    expect(page).to have_content("invalid or has already been used")
  end
end
