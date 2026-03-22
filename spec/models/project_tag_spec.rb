require "rails_helper"

RSpec.describe ProjectTag, type: :model do
  describe "associations" do
    it "belongs to a project" do
      expect(build(:project_tag).project).to be_a(Project)
    end

    it "belongs to a tag" do
      expect(build(:project_tag).tag).to be_a(Tag)
    end

    it "requires a project" do
      expect(build(:project_tag, project: nil)).not_to be_valid
    end

    it "requires a tag" do
      expect(build(:project_tag, tag: nil)).not_to be_valid
    end
  end

  describe "validations" do
    it "is valid with a unique project/tag combination" do
      expect(build(:project_tag)).to be_valid
    end

    it "prevents the same tag being added to a project twice" do
      existing = create(:project_tag)
      duplicate = build(:project_tag, project: existing.project, tag: existing.tag)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:tag_id]).to include("has already been taken")
    end
  end
end
