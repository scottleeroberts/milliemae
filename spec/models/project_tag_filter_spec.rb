require "rails_helper"

RSpec.describe Project, type: :model do
  let!(:creator) { create(:user, :creator) }
  let!(:dress_project) do
    p = create(:project, user: creator, published: true, published_at: 1.day.ago)
    p.tag_list = "dresses"
    p.save!
    p
  end
  let!(:skirt_project) do
    p = create(:project, user: creator, published: true, published_at: 1.day.ago)
    p.tag_list = "skirts"
    p.save!
    p
  end

  describe ".with_tag" do
    it "returns all published projects when tag is nil" do
      result = Project.for_feed.with_tag(nil)
      expect(result).to include(dress_project, skirt_project)
    end

    it "filters by tag name" do
      result = Project.for_feed.with_tag("dresses")
      expect(result).to include(dress_project)
      expect(result).not_to include(skirt_project)
    end

    it "returns none for an unused tag" do
      expect(Project.for_feed.with_tag("quilts")).to be_empty
    end

    it "is case-insensitive" do
      result = Project.for_feed.with_tag("Dresses")
      expect(result).to include(dress_project)
    end
  end

  describe "tag limit" do
    it "rejects more than 10 tags" do
      p = create(:project, user: creator, published: true, published_at: 1.day.ago)
      p.tag_list = (1..11).map { |n| "tag#{n}" }.join(", ")
      expect(p).not_to be_valid
      expect(p.errors[:tags]).to include("maximum of 10 tags allowed")
    end

    it "accepts 10 tags" do
      p = create(:project, user: creator, published: true, published_at: 1.day.ago)
      p.tag_list = (1..10).map { |n| "tag#{n}" }.join(", ")
      expect(p).to be_valid
    end
  end

  describe "PER_PAGE" do
    it "is defined" do
      expect(Project::PER_PAGE).to eq(12)
    end
  end
end
