require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#published_date" do
    it "returns a formatted date when published" do
      project = build(:project, published_at: Time.zone.parse("2026-03-22"))

      expect(helper.published_date(project)).to eq("Twirled on Mar 22, 2026")
    end

    it "returns 'Not published yet' for drafts" do
      project = build(:project, published_at: nil)

      expect(helper.published_date(project)).to eq("Not published yet")
    end
  end
end
