require "rails_helper"

RSpec.describe ProjectImage, type: :model do
  describe "associations" do
    it "belongs to a project" do
      project_image = build(:project_image)
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
  end

  describe "#analyze_image_dimensions" do
    it "leaves dimensions nil when image is not attached" do
      project_image = create(:project_image)
      project_image.image.purge
      project_image.analyze_image_dimensions
      expect(project_image.image_width).to be_nil
      expect(project_image.image_height).to be_nil
    end

    it "stores width and height from blob metadata" do
      project_image = create(:project_image)
      allow(project_image.image.blob).to receive(:analyze)
      allow(project_image.image.blob).to receive(:metadata).and_return("width" => 640, "height" => 480)

      project_image.analyze_image_dimensions

      expect(project_image.reload.image_width).to eq(640)
      expect(project_image.reload.image_height).to eq(480)
    end
  end
end
