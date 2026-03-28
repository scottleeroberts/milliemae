require "rails_helper"

RSpec.describe "Creator project image actors" do
  let(:creator) { create(:user, :creator, email: "actor-project-image-creator@example.com", name: "Actor Project Image Creator") }
  let(:project) { create(:project, user: creator, title: "Actor Project Image Project") }
  let(:image_file) { fixture_file_upload(Rails.root.join("spec/fixtures/files/test_image.png"), "image/png") }

  describe Creator::ProjectImages::Create do
    it "creates a project image and analyzes dimensions" do
      result = described_class.call(project: project, image: image_file)

      expect(result.project_image).to be_persisted
      expect(result.project_image.image).to be_attached
    end

    it "fails without an image" do
      result = described_class.result(project: project, image: nil)

      expect(result).to be_failure
      expect(result.project_image.errors[:image]).to be_present
    end
  end

  describe Creator::ProjectImages::Destroy do
    it "destroys the project image" do
      project_image = create(:project_image, project: project)

      expect {
        described_class.call(project_image: project_image)
      }.to change(ProjectImage, :count).by(-1)
    end
  end
end
