require "rails_helper"

RSpec.describe ProductLink, type: :model do
  describe "validations" do
    subject(:product_link) { build(:product_link) }

    it "is valid with valid attributes" do
      expect(product_link).to be_valid
    end

    it "requires a label" do
      product_link.label = ""
      expect(product_link).not_to be_valid
      expect(product_link.errors[:label]).to include("can't be blank")
    end

    it "requires a url" do
      product_link.url = ""
      expect(product_link).not_to be_valid
      expect(product_link.errors[:url]).to include("can't be blank")
    end

    it "rejects urls without http/https scheme" do
      product_link.url = "ftp://example.com"
      expect(product_link).not_to be_valid
      expect(product_link.errors[:url]).to include("must start with http:// or https://")
    end

    it "rejects urls with whitespace in the host" do
      product_link.url = "https:// example.com"
      expect(product_link).not_to be_valid
      expect(product_link.errors[:url]).to be_present
    end

    it "rejects urls without a dot in the host" do
      product_link.url = "https://localhost"
      expect(product_link).not_to be_valid
      expect(product_link.errors[:url]).to be_present
    end

    it "accepts https urls" do
      product_link.url = "https://www.amazon.com/dp/B08XYZ"
      expect(product_link).to be_valid
    end

    it "accepts http urls" do
      product_link.url = "http://example.com/product"
      expect(product_link).to be_valid
    end

    it "rejects urls with trailing content after newline" do
      product_link.url = "https://evil.com\njavascript:alert(1)"
      expect(product_link).not_to be_valid
    end

    it "requires x coordinate" do
      product_link.x = nil
      expect(product_link).not_to be_valid
    end

    it "requires y coordinate" do
      product_link.y = nil
      expect(product_link).not_to be_valid
    end

    it "rejects x outside 0..1" do
      product_link.x = 1.5
      expect(product_link).not_to be_valid
      product_link.x = -0.1
      expect(product_link).not_to be_valid
    end

    it "rejects y outside 0..1" do
      product_link.y = 1.1
      expect(product_link).not_to be_valid
      product_link.y = -0.1
      expect(product_link).not_to be_valid
    end

    it "accepts boundary values for x" do
      product_link.x = 0.0
      expect(product_link).to be_valid
      product_link.x = 1.0
      expect(product_link).to be_valid
    end

    it "accepts boundary values for y" do
      product_link.y = 0.0
      expect(product_link).to be_valid
      product_link.y = 1.0
      expect(product_link).to be_valid
    end
  end

  describe "associations" do
    it "belongs to a project_image" do
      product_link = described_class.new(project_image: build(:project_image, :without_image))
      expect(product_link.project_image).to be_present
    end
  end
end
