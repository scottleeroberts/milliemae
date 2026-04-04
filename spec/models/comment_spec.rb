require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "validations" do
    it "is valid with a body, user, and project" do
      expect(build(:comment)).to be_valid
    end

    it "requires a body" do
      comment = build(:comment, body: "")
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include("can't be blank")
    end

    it "rejects body longer than 2000 characters" do
      comment = build(:comment, body: "a" * 2001)
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to be_present
    end

    it "accepts body of exactly 2000 characters" do
      comment = build(:comment, body: "a" * 2000)
      expect(comment).to be_valid
    end

    it "requires a user" do
      comment = build(:comment, user: nil)
      expect(comment).not_to be_valid
      expect(comment.errors[:user]).to be_present
    end

    it "requires a project" do
      comment = build(:comment, project: nil)
      expect(comment).not_to be_valid
      expect(comment.errors[:project]).to be_present
    end
  end

  describe "dependent destroy" do
    it "is destroyed when the project is destroyed" do
      comment = create(:comment)
      expect { comment.project.destroy }.to change(Comment, :count).by(-1)
    end

    it "is destroyed when the user is destroyed" do
      comment = create(:comment)
      expect { comment.user.destroy }.to change(Comment, :count).by(-1)
    end
  end

  describe "Project#comments ordering" do
    it "returns comments newest first" do
      project = create(:project, :published)
      older = create(:comment, project: project, created_at: 2.hours.ago)
      newer = create(:comment, project: project, created_at: 1.hour.ago)
      expect(project.comments.to_a).to eq([ newer, older ])
    end
  end

  describe "#destroyable_by?" do
    let(:comment) { create(:comment) }

    it "allows the owner" do
      expect(comment).to be_destroyable_by(comment.user)
    end

    it "allows admins" do
      expect(comment).to be_destroyable_by(create(:user, :admin))
    end

    it "rejects other users" do
      expect(comment).not_to be_destroyable_by(create(:user))
    end

    it "rejects nil" do
      expect(comment).not_to be_destroyable_by(nil)
    end
  end
end
