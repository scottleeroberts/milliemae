require "rails_helper"

RSpec.describe "Creator project image management", type: :system do
  let(:creator) { create(:user, :creator) }
  let(:project) { create(:project, user: creator) }
  let(:image_path) { Rails.root.join("spec/fixtures/files/test_image.png") }

  before { sign_in_via_form creator }

  it "uploads a project image and displays it on the project show page" do
    visit creator_project_path(project)

    expect(page).to have_content("No image yet")

    attach_file "project_image[image]", image_path
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

  it "renders existing hotspots with the shared pink pin styling" do
    project_image = create(:project_image, project: project)
    create(:product_link, project_image: project_image, label: "Pattern", url: "https://example.com/pattern", x: 0.25, y: 0.5)

    visit creator_project_path(project)

    expect(page).to have_css("a.bg-pink-600.rounded-full", text: "1")
  end
end
