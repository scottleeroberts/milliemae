require "rails_helper"

RSpec.describe "Admin project actors" do
  let(:creator) { create(:user, :creator, email: "admin-project-creator@example.com", name: "Admin Project Creator") }

  describe Admin::Projects::Destroy do
    it "destroys the project" do
      project = create(:project, user: creator, title: "Actor Destroy Project")

      expect {
        described_class.call(project: project)
      }.to change(Project, :count).by(-1)
    end
  end

  describe Admin::Projects::Unpublish do
    it "unpublishes the project" do
      project = create(:project, :published, user: creator, title: "Actor Unpublish Project")

      described_class.call(project: project)

      expect(project.reload).not_to be_published
      expect(project.published_at).to be_nil
    end
  end
end
