require "rails_helper"

RSpec.describe "Public Projects", type: :system do
  let(:creator) { create(:user, :creator, name: "Alice Maker") }

  describe "feed" do
    it "shows published projects to anonymous visitors" do
      create(:project, :published, user: creator, title: "Summer Sundress")
      visit projects_path
      expect(page).to have_text("Summer Sundress")
      expect(page).to have_text("Alice Maker")
    end

    it "does not show draft projects" do
      create(:project, user: creator, title: "Secret WIP")
      visit projects_path
      expect(page).not_to have_text("Secret WIP")
    end

    it "shows empty state when nothing is published" do
      visit projects_path
      expect(page).to have_text("No projects published yet")
    end

    it "links each card to the project detail page" do
      project = create(:project, :published, user: creator, title: "Floral Skirt")
      visit projects_path
      click_link "Floral Skirt"
      expect(page).to have_current_path(project_path(project))
      expect(page).to have_text("Floral Skirt")
    end

    it "links the creator name on a card to the creator profile" do
      create(:project, :published, user: creator, title: "Linen Trousers")
      visit projects_path
      click_link "Alice Maker"
      expect(page).to have_current_path(creator_path(creator))
    end
  end

  describe "project detail" do
    let!(:project) do
      create(:project, :published, user: creator, title: "Silk Blouse")
    end

    it "renders the project title and creator" do
      visit project_path(project)
      expect(page).to have_text("Silk Blouse")
      expect(page).to have_text("Alice Maker")
    end

    it "links back to the feed" do
      visit project_path(project)
      expect(page).to have_link("← All Projects", href: projects_path)
    end

    it "links the creator name to their profile" do
      visit project_path(project)
      click_link "Alice Maker"
      expect(page).to have_current_path(creator_path(creator))
    end
  end

  describe "creator profile" do
    it "shows the creator name and their published projects" do
      create(:project, :published, user: creator, title: "Wool Coat")
      visit creator_path(creator)
      expect(page).to have_text("Alice Maker")
      expect(page).to have_text("Wool Coat")
    end

    it "does not show draft projects on the profile" do
      create(:project, user: creator, title: "Unfinished Cape")
      visit creator_path(creator)
      expect(page).not_to have_text("Unfinished Cape")
    end
  end
end
