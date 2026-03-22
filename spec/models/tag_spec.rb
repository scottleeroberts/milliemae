require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "validations" do
    it "is valid with a name" do
      expect(build(:tag)).to be_valid
    end

    it "requires a name" do
      expect(build(:tag, name: "")).not_to be_valid
    end

    it "requires a unique name (case-insensitive)" do
      create(:tag, name: "cotton")
      expect(build(:tag, name: "Cotton")).not_to be_valid
    end
  end

  describe "normalisation" do
    it "downcases the name before validation" do
      tag = create(:tag, name: "COTTON")
      expect(tag.name).to eq("cotton")
    end

    it "strips whitespace from the name" do
      tag = create(:tag, name: "  cotton  ")
      expect(tag.name).to eq("cotton")
    end

    it "is invalid when the name is only whitespace" do
      expect(build(:tag, name: "   ")).not_to be_valid
    end
  end

  describe "associations" do
    it "destroys project_tags when the tag is destroyed" do
      project = create(:project, :with_tags)
      tag = Tag.find_by(name: "cotton")
      expect { tag.destroy }.to change(ProjectTag, :count).by(-1)
    end
  end
end
