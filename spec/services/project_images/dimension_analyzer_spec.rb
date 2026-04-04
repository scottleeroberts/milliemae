require "rails_helper"

RSpec.describe ProjectImages::DimensionAnalyzer do
  describe ".call" do
    it "leaves dimensions nil when no image is attached" do
      project_image = create(:project_image)
      project_image.image.purge

      described_class.call(project_image: project_image)

      expect(project_image.image_width).to be_nil
      expect(project_image.image_height).to be_nil
    end

    it "stores width and height from blob metadata" do
      project_image = create(:project_image)
      allow(project_image.image.blob).to receive(:analyze)
      allow(project_image.image.blob).to receive(:metadata).and_return("width" => 640, "height" => 480)

      described_class.call(project_image: project_image)

      expect(project_image.reload.image_width).to eq(640)
      expect(project_image.reload.image_height).to eq(480)
    end
  end
end
