require "rails_helper"

RSpec.describe "Admin invitation management", type: :system do
  let(:admin) { create(:user, :admin) }

  before { sign_in_via_form admin }

  it "admin creates an invitation and sees it in the list" do
    visit admin_invitations_path

    fill_in "invitation[email]", with: "newcreator@example.com"
    click_button "Send Invitation"

    expect(page).to have_content("Invitation sent to newcreator@example.com")
    expect(page).to have_content("newcreator@example.com")
    expect(page).to have_content("Pending")
  end

  it "admin can cancel a pending invitation" do
    create(:invitation, email: "pending@example.com")

    visit admin_invitations_path

    expect(page).to have_content("pending@example.com")

    accept_confirm { click_button "Cancel" }

    expect(page).not_to have_content("pending@example.com")
    expect(page).to have_content("Invitation removed")
  end
end
