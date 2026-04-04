require "rails_helper"

RSpec.describe ProjectImage, type: :model do
  describe "associations" do
    it "belongs to a project" do
      project_image = build(:project_image, :without_image)
      expect(project_image.project).to be_present
    end

    it "destroys product_links when destroyed" do
      project_image = create(:project_image)
      create_list(:product_link, 2, project_image: project_image)
      expect { project_image.destroy }.to change(ProductLink, :count).by(-2)
    end
  end

  describe "validations" do
    it "requires an attached image" do
      pi = ProjectImage.new(project: create(:project), position: 0)
      expect(pi).not_to be_valid
      expect(pi.errors[:image]).to be_present
    end

    it "requires a non-negative position" do
      project_image = build(:project_image, position: -1)
      expect(project_image).not_to be_valid
    end

    it "is valid with valid attributes" do
      project_image = build(:project_image)
      expect(project_image).to be_valid
    end

    it "rejects non-image content types" do
      project_image = build(:project_image, :without_image)
      project_image.image.attach(
        io: StringIO.new("<html>evil</html>"),
        filename: "evil.html",
        content_type: "text/html"
      )
      expect(project_image).not_to be_valid
      expect(project_image.errors[:image]).to include("must be a JPEG, PNG, WebP, or GIF")
    end

    it "rejects files larger than 10 MB" do
      project_image = build(:project_image)
      blob = project_image.image.blob
      allow(blob).to receive(:byte_size).and_return(11.megabytes)
      expect(project_image).not_to be_valid
      expect(project_image.errors[:image]).to include("must be less than 10 MB")
    end
  end

end
