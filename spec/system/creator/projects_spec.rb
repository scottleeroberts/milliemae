require "rails_helper"

RSpec.describe "Creator Projects", type: :system do
  let(:creator) { create(:user, :creator) }

  before { sign_in_via_form(creator) }

  describe "empty state" do
    it "shows the empty state message and a New Project link" do
      visit creator_projects_path
      expect(page).to have_text("You haven't created any projects yet")
      expect(page).to have_link("New Project", href: new_creator_project_path)
    end
  end

  describe "creating a project" do
    it "creates a project with title and tags and redirects to the show page" do
      visit new_creator_project_path

      fill_in "Title", with: "My Summer Dress"
      fill_in "Tags", with: "cotton, dress"
      click_button "Create Project"

      expect(page).to have_text("Project created.")
      expect(page).to have_text("My Summer Dress")
      expect(page).to have_text("cotton")
    end

    it "creates a project with rich text body content" do
      visit new_creator_project_path

      fill_in "Title", with: "Floral Blouse"
      page.execute_script(
        "document.querySelector('trix-editor').editor.loadHTML('<p>A beautiful floral blouse</p>')"
      )
      click_button "Create Project"

      expect(page).to have_text("Floral Blouse")
      expect(page).to have_text("A beautiful floral blouse")
    end

    it "shows validation errors when title is blank" do
      visit new_creator_project_path
      click_button "Create Project"

      expect(page).to have_text("can't be blank")
    end
  end

  describe "editing a project" do
    let!(:project) { create(:project, user: creator, title: "Old Title") }

    it "updates the project and shows a success notice" do
      visit edit_creator_project_path(project)

      fill_in "Title", with: "New Title"
      click_button "Update Project"

      expect(page).to have_text("New Title")
      expect(page).to have_text("Project updated.")
    end

    it "shows validation errors when title is cleared" do
      visit edit_creator_project_path(project)

      fill_in "Title", with: ""
      click_button "Update Project"

      expect(page).to have_text("can't be blank")
    end
  end

  describe "publishing and unpublishing" do
    let!(:project) { create(:project, user: creator) }

    it "publishes a draft project from the dashboard" do
      visit creator_projects_path

      click_button "Publish"

      expect(page).to have_text("published")
      expect(page).to have_button("Unpublish")
    end

    it "unpublishes a published project from the dashboard" do
      project.publish!
      visit creator_projects_path

      click_button "Unpublish"

      expect(page).to have_text("unpublished")
      expect(page).to have_button("Publish")
    end
  end

  describe "deleting a project" do
    let!(:project) { create(:project, user: creator, title: "Soon Gone") }

    it "deletes the project after confirmation and shows a notice" do
      visit creator_projects_path

      accept_confirm do
        click_button "Delete"
      end

      expect(page).not_to have_text("Soon Gone")
      expect(page).to have_text("Project deleted.")
    end
  end

  describe "navigation" do
    it "shows a My Projects link in the nav for creators" do
      visit root_path
      expect(page).to have_link("My Projects", href: creator_projects_path)
    end
  end
end
