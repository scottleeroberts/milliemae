require "rails_helper"

RSpec.describe "Creator project actors" do
  let(:creator) { create(:user, :creator, email: "creator-project-actor@example.com", name: "Creator Project Actor") }

  describe Creator::Projects::Create do
    it "creates a project for the creator" do
      result = described_class.call(user: creator, attributes: { title: "Summer Dress", tag_list: "linen" })

      expect(result.project).to be_persisted
      expect(result.project.user).to eq(creator)
      expect(result.project.tags.map(&:name)).to eq(["linen"])
    end

    it "fails with invalid params" do
      result = described_class.result(user: creator, attributes: { title: "" })

      expect(result).to be_failure
      expect(result.project.errors[:title]).to be_present
    end
  end

  describe Creator::Projects::Update do
    it "updates the project" do
      project = create(:project, user: creator, title: "Update Actor Project")

      described_class.call(project_record: project, attributes: { title: "Updated" })

      expect(project.reload.title).to eq("Updated")
    end
  end

  describe Creator::Projects::Destroy do
    it "destroys the project" do
      project = create(:project, user: creator, title: "Destroy Actor Project")

      expect {
        described_class.call(project: project)
      }.to change(Project, :count).by(-1)
    end
  end

  describe Creator::Projects::Publish do
    it "publishes the project" do
      project = create(:project, user: creator, title: "Publish Actor Project")

      described_class.call(project: project)

      expect(project.reload).to be_published
    end
  end

  describe Creator::Projects::Unpublish do
    it "unpublishes the project" do
      project = create(:project, :published, user: creator)

      described_class.call(project: project)

      expect(project.reload).not_to be_published
    end
  end
end
