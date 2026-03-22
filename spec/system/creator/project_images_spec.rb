require "rails_helper"

RSpec.describe "Creator project image management", type: :system do
  let(:creator) { create(:user, :creator) }
  let(:project) { create(:project, user: creator) }
  let(:image_path) { Rails.root.join("spec/fixtures/files/test_image.png") }

  before { sign_in creator }

  it "uploads a project image and displays it on the project show page" do
    visit creator_project_path(project)

    expect(page).to have_content("No image yet")

    attach_file "image", image_path
    click_button "Upload"

    expect(page).to have_css("img[src*='test']", wait: 5)
    expect(page).not_to have_content("No image yet")
  end

  it "removes a project image" do
    project_image = create(:project_image, project: project)

    visit creator_project_path(project)

    accept_confirm { click_button "Remove image" }

    expect(page).to have_content("No image yet", wait: 5)
    expect(ProjectImage.count).to eq(0)
  end
end
