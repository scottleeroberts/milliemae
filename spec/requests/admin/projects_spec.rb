require "rails_helper"

RSpec.describe "Admin::Projects", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:creator) { create(:user, :creator) }
  let!(:project) { create(:project, user: creator, published: true, published_at: 1.day.ago) }

  describe "GET /admin/projects" do
    it "returns 200 for admin" do
      sign_in admin
      get admin_projects_path
      expect(response).to have_http_status(:ok)
    end

    it "shows all projects including drafts" do
      draft = create(:project, user: creator, published: false)
      sign_in admin
      get admin_projects_path
      expect(response.body).to include(project.title, draft.title)
    end

    it "redirects non-admin" do
      sign_in creator
      get admin_projects_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE /admin/projects/:id" do
    before { sign_in admin }

    it "destroys the project" do
      expect {
        delete admin_project_path(project.id)
      }.to change(Project, :count).by(-1)
    end

    it "redirects with notice" do
      delete admin_project_path(project.id)
      expect(response).to redirect_to(admin_projects_path)
    end
  end

  describe "PATCH /admin/projects/:id/unpublish" do
    before { sign_in admin }

    it "unpublishes the project" do
      patch unpublish_admin_project_path(project.id)
      expect(project.reload.published).to be false
    end

    it "redirects with notice" do
      patch unpublish_admin_project_path(project.id)
      expect(response).to redirect_to(admin_projects_path)
    end
  end
end
