require "rails_helper"

RSpec.describe "Creator product link actors" do
  let(:project_image) { create(:project_image) }

  describe Creator::ProjectImages::ProductLinks::Create do
    it "creates a product link" do
      expect {
        described_class.call(
          project_image: project_image,
          attributes: { label: "Pattern", url: "https://example.com", x: 0.2, y: 0.4 }
        )
      }.to change(ProductLink, :count).by(1)
    end
  end

  describe Creator::ProjectImages::ProductLinks::Update do
    it "updates the product link" do
      product_link = create(:product_link, project_image: project_image)

      described_class.call(link: product_link, attributes: { label: "Updated" })

      expect(product_link.reload.label).to eq("Updated")
    end

    it "fails with invalid attributes" do
      product_link = create(:product_link, project_image: project_image)

      result = described_class.result(link: product_link, attributes: { label: "", url: "" })

      expect(result).to be_failure
      expect(result.product_link.errors[:label]).to be_present
    end
  end

  describe Creator::ProjectImages::ProductLinks::Destroy do
    it "destroys the product link" do
      product_link = create(:product_link, project_image: project_image)

      expect {
        described_class.call(product_link: product_link)
      }.to change(ProductLink, :count).by(-1)
    end
  end
end
