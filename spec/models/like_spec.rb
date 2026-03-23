require "rails_helper"

RSpec.describe Like, type: :model do
  describe "associations" do
    it "belongs to a user" do
      like = build(:like)
      expect(like.user).to be_present
    end

    it "belongs to a project" do
      like = build(:like)
      expect(like.project).to be_present
    end

    it "requires a user" do
      like = build(:like, user: nil)
      expect(like).not_to be_valid
      expect(like.errors[:user]).to be_present
    end

    it "requires a project" do
      like = build(:like, project: nil)
      expect(like).not_to be_valid
      expect(like.errors[:project]).to be_present
    end
  end

  describe "uniqueness" do
    it "prevents a user from liking the same project twice" do
      like = create(:like)
      duplicate = build(:like, user: like.user, project: like.project)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to be_present
    end

    it "allows the same user to like different projects" do
      user = create(:user)
      project1 = create(:project, :published)
      project2 = create(:project, :published)
      create(:like, user: user, project: project1)
      second_like = build(:like, user: user, project: project2)
      expect(second_like).to be_valid
    end

    it "allows different users to like the same project" do
      project = create(:project, :published)
      user1 = create(:user)
      user2 = create(:user)
      create(:like, user: user1, project: project)
      second_like = build(:like, user: user2, project: project)
      expect(second_like).to be_valid
    end
  end

  describe "User#liked?" do
    it "returns true when the user has liked the project" do
      like = create(:like)
      expect(like.user.liked?(like.project)).to be true
    end

    it "returns false when the user has not liked the project" do
      user = create(:user)
      project = create(:project, :published)
      expect(user.liked?(project)).to be false
    end
  end

  describe "dependent destroy" do
    it "is destroyed when the user is destroyed" do
      like = create(:like)
      expect { like.user.destroy }.to change(Like, :count).by(-1)
    end

    it "is destroyed when the project is destroyed" do
      like = create(:like)
      expect { like.project.destroy }.to change(Like, :count).by(-1)
    end
  end
end
