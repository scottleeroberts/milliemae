require "rails_helper"

RSpec.describe "Like actors" do
  describe Likes::Create do
    let(:project) { create(:project, :published) }
    let(:user) { create(:user) }

    it "creates a like" do
      expect {
        described_class.call(project: project, user: user)
      }.to change(Like, :count).by(1)
    end

    it "is idempotent" do
      create(:like, project: project, user: user)

      expect {
        described_class.call(project: project, user: user)
      }.not_to change(Like, :count)
    end
  end

  describe Likes::Destroy do
    it "destroys the like when present" do
      user = create(:user, email: "like-destroy-user@example.com", name: "Like Destroy User")
      project = create(:project, :published, title: "Like Destroy Project")
      like = create(:like, project: project, user: user)

      expect {
        described_class.call(project: like.project, user: like.user)
      }.to change(Like, :count).by(-1)
    end
  end
end
