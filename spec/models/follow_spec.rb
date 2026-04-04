require "rails_helper"

RSpec.describe Follow, type: :model do
  describe "associations" do
    it "requires a follower" do
      follow = build(:follow, follower: nil)
      expect(follow).not_to be_valid
      expect(follow.errors[:follower]).to be_present
    end

    it "requires a following" do
      follow = build(:follow, following: nil)
      expect(follow).not_to be_valid
      expect(follow.errors[:following]).to be_present
    end
  end

  describe "uniqueness" do
    it "prevents duplicate follows" do
      follow = create(:follow)
      duplicate = build(:follow, follower: follow.follower, following: follow.following)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:follower_id]).to be_present
    end

    it "allows following multiple different users" do
      follower = create(:user)
      user_a = create(:user)
      user_b = create(:user)
      create(:follow, follower: follower, following: user_a)
      second = build(:follow, follower: follower, following: user_b)
      expect(second).to be_valid
    end
  end

  describe "self-follow prevention" do
    it "is invalid when follower and following are the same user" do
      user = create(:user)
      follow = build(:follow, follower: user, following: user)
      expect(follow).not_to be_valid
      expect(follow.errors[:follower_id]).to include("cannot follow yourself")
    end
  end

  describe "User#following?" do
    it "returns true when the user is following another user" do
      follow = create(:follow)
      expect(follow.follower.following?(follow.following)).to be true
    end

    it "returns false when the user is not following another user" do
      user = create(:user)
      other = create(:user)
      expect(user.following?(other)).to be false
    end
  end

  describe "User associations" do
    it "exposes followers via has_many :followers" do
      creator = create(:user)
      follower = create(:user)
      create(:follow, follower: follower, following: creator)
      expect(creator.followers).to include(follower)
    end

    it "exposes following via has_many :following" do
      user = create(:user)
      creator = create(:user)
      create(:follow, follower: user, following: creator)
      expect(user.following).to include(creator)
    end
  end

  describe "counter cache" do
    it "increments following user's followers_count on create" do
      creator = create(:user)
      follower = create(:user)
      expect { create(:follow, follower: follower, following: creator) }.to change { creator.reload.followers_count }.by(1)
    end

    it "decrements following user's followers_count on destroy" do
      follow = create(:follow)
      creator = follow.following
      expect { follow.destroy }.to change { creator.reload.followers_count }.by(-1)
    end
  end

  describe "dependent destroy" do
    it "is destroyed when the follower is destroyed" do
      follow = create(:follow)
      expect { follow.follower.destroy }.to change(Follow, :count).by(-1)
    end

    it "is destroyed when the following user is destroyed" do
      follow = create(:follow)
      expect { follow.following.destroy }.to change(Follow, :count).by(-1)
    end
  end
end
