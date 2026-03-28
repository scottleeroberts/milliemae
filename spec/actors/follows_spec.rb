require "rails_helper"

RSpec.describe "Follow actors" do
  describe Follows::Create do
    let(:follower) { create(:user, email: "follower@example.com", name: "Follower User") }
    let(:following) { create(:user, :creator, email: "creator@example.com", name: "Creator User") }

    it "creates a follow" do
      expect {
        described_class.call(follower: follower, following: following)
      }.to change(Follow, :count).by(1)
    end

    it "is idempotent" do
      create(:follow, follower: follower, following: following)

      expect {
        described_class.call(follower: follower, following: following)
      }.not_to change(Follow, :count)
    end

    it "fails when following yourself" do
      result = described_class.result(follower: following, following: following)

      expect(result).to be_failure
      expect(result.error).to eq("You cannot follow yourself.")
    end
  end

  describe Follows::Destroy do
    it "destroys the follow when present" do
      follower = create(:user, email: "destroy-follower@example.com", name: "Destroy Follower")
      following = create(:user, :creator, email: "destroy-creator@example.com", name: "Destroy Creator")
      follow = create(:follow, follower: follower, following: following)

      expect {
        described_class.call(follower: follow.follower, following: follow.following)
      }.to change(Follow, :count).by(-1)
    end
  end
end
