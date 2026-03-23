require "rails_helper"

RSpec.describe "Comments", type: :system do
  let(:creator) { create(:user, :creator) }
  let(:project) { create(:project, :published, user: creator) }
  let(:user) { create(:user) }

  describe "on the project show page" do
    context "when not signed in" do
      it "shows a sign-in prompt instead of the comment form" do
        visit project_path(project)
        expect(page).to have_link("Sign in")
        expect(page).not_to have_field("comment[body]")
      end

      it "shows existing comments" do
        create(:comment, project: project, body: "Beautiful stitching!")
        visit project_path(project)
        expect(page).to have_content("Beautiful stitching!")
      end
    end

    context "when signed in" do
      before { sign_in_via_form user }

      it "shows the comment form" do
        visit project_path(project)
        expect(page).to have_field("comment[body]")
      end

      it "submitting a comment adds it to the list without a page reload" do
        visit project_path(project)
        fill_in "comment[body]", with: "Love this dress!"
        click_button "Post comment"
        expect(page).to have_content("Love this dress!")
        expect(page).to have_content(user.display_name)
      end

      it "clears the form after submitting" do
        visit project_path(project)
        fill_in "comment[body]", with: "Great project!"
        click_button "Post comment"
        expect(page).to have_field("comment[body]", with: "")
      end

      it "shows a validation error for blank comments" do
        visit project_path(project)
        click_button "Post comment"
        expect(page).to have_content("can't be blank")
      end

      it "does not add blank comments to the list" do
        visit project_path(project)
        click_button "Post comment"
        expect(Comment.count).to eq(0)
      end
    end

    context "deleting comments" do
      let!(:comment) { create(:comment, user: user, project: project, body: "Nice work!") }

      before { sign_in_via_form user }

      it "comment owner sees a delete button" do
        visit project_path(project)
        expect(page).to have_button("×")
      end

      it "deleting removes the comment from the page" do
        visit project_path(project)
        accept_confirm { click_button "×" }
        expect(page).not_to have_content("Nice work!")
      end
    end

    context "deleting another user's comment" do
      let!(:other_comment) { create(:comment, project: project, body: "Other comment") }
      let(:other_user) { create(:user) }

      before { sign_in_via_form other_user }

      it "does not show a delete button for another user's comment" do
        visit project_path(project)
        expect(page).not_to have_button("×")
      end
    end
  end
end
