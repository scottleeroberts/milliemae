require "rails_helper"

RSpec.describe "Likes", type: :system do
  let(:creator) { create(:user, :creator) }
  let(:project) { create(:project, :published, user: creator) }
  let(:user) { create(:user) }

  describe "on the project show page" do
    context "when not signed in" do
      it "shows a like link pointing to sign in" do
        visit project_path(project)
        expect(page).to have_link("♥ Like", href: new_user_session_path)
      end

      it "shows the like count" do
        create(:like, project: project)
        visit project_path(project)
        expect(page).to have_content("1 like")
      end
    end

    context "when signed in" do
      before { sign_in_via_form user }

      it "shows a Like button when not liked" do
        visit project_path(project)
        expect(page).to have_button("♥ Like")
      end

      it "liking a project updates the button and count without a page reload" do
        visit project_path(project)
        click_button "♥ Like"
        expect(page).to have_button("♥ Unlike")
        expect(page).to have_content("1 like")
      end

      it "unliking a project reverts the button" do
        create(:like, user: user, project: project)
        visit project_path(project)
        click_button "♥ Unlike"
        expect(page).to have_button("♥ Like")
        expect(page).to have_content("0 likes")
      end
    end
  end
end
