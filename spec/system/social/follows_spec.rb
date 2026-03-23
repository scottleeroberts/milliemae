require "rails_helper"

RSpec.describe "Follows", type: :system do
  let(:creator) { create(:user, :creator) }
  let(:user) { create(:user) }

  describe "on the creator profile page" do
    context "when not signed in" do
      it "does not show a follow button" do
        visit creator_path(creator)
        expect(page).not_to have_button("Follow")
      end

      it "shows the follower count" do
        create(:follow, follower: user, following: creator)
        visit creator_path(creator)
        expect(page).to have_content("1 follower")
      end
    end

    context "when signed in as a different user" do
      before { sign_in_via_form user }

      it "shows a Follow button when not following" do
        visit creator_path(creator)
        expect(page).to have_button("Follow")
      end

      it "following updates the button and follower count" do
        visit creator_path(creator)
        click_button "Follow"
        expect(page).to have_button("Following")
        expect(page).to have_content("1 follower")
      end

      it "unfollowing reverts the button" do
        create(:follow, follower: user, following: creator)
        visit creator_path(creator)
        click_button "Following"
        expect(page).to have_button("Follow")
        expect(page).to have_content("0 followers")
      end
    end

    context "when viewing own profile" do
      before { sign_in_via_form creator }

      it "does not show a follow button on own profile" do
        visit creator_path(creator)
        expect(page).not_to have_button("Follow")
        expect(page).not_to have_button("Following")
      end
    end
  end
end
