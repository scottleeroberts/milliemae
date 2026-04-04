require "rails_helper"

RSpec.describe "Creator::Projects", type: :request do
  let(:creator) { create(:user, :creator) }
  let(:audience) { create(:user) }

  describe "authentication and authorization" do
    it "redirects unauthenticated users to sign in" do
      get creator_projects_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects audience users to root" do
      sign_in audience
      get creator_projects_path
      expect(response).to redirect_to(root_path)
    end

    it "allows creators to access the dashboard" do
      sign_in creator
      get creator_projects_path
      expect(response).to have_http_status(:ok)
    end

    it "allows admins to access the dashboard" do
      sign_in create(:user, :admin)
      get creator_projects_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /creator/projects" do
    before { sign_in creator }

    it "lists only the current creator's projects" do
      own = create(:project, user: creator, title: "My Dress")
      other = create(:project, title: "Not Mine")

      get creator_projects_path

      expect(response.body).to include("My Dress")
      expect(response.body).not_to include("Not Mine")
    end
  end

  describe "GET /creator/projects/new" do
    before { sign_in creator }

    it "renders the new form" do
      get new_creator_project_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /creator/projects" do
    before { sign_in creator }

    let(:valid_params) { { project: { title: "Summer Dress", tag_list: "cotton, dress" } } }

    it "creates a project and redirects to it" do
      expect { post creator_projects_path, params: valid_params }.to change(Project, :count).by(1)

      project = Project.last
      expect(project.title).to eq("Summer Dress")
      expect(response).to redirect_to(creator_project_path(project))
    end

    it "returns unprocessable on invalid params" do
      post creator_projects_path, params: { project: { title: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /creator/projects/:id/edit" do
    before { sign_in creator }

    it "renders the edit form" do
      project = create(:project, user: creator)
      get edit_creator_project_path(project)
      expect(response).to have_http_status(:ok)
    end

    it "returns 404 for another creator's project" do
      other_project = create(:project)
      get edit_creator_project_path(other_project)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /creator/projects/:id" do
    before { sign_in creator }

    it "updates the project" do
      project = create(:project, user: creator)
      patch creator_project_path(project), params: { project: { title: "Updated Title" } }
      expect(project.reload.title).to eq("Updated Title")
      expect(response).to redirect_to(creator_project_path(project))
    end

    it "returns unprocessable on invalid params" do
      project = create(:project, user: creator)
      patch creator_project_path(project), params: { project: { title: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /creator/projects/:id" do
    before { sign_in creator }

    it "destroys the project and redirects to index" do
      project = create(:project, user: creator)
      expect { delete creator_project_path(project) }.to change(Project, :count).by(-1)
      expect(response).to redirect_to(creator_projects_path)
    end
  end

  describe "PATCH /creator/projects/:id/publish" do
    before { sign_in creator }

    it "publishes a draft project" do
      project = create(:project, user: creator)
      patch publish_creator_project_path(project)
      expect(project.reload).to be_published
      expect(response).to redirect_to(creator_projects_path)
    end
  end

  describe "PATCH /creator/projects/:id/unpublish" do
    before { sign_in creator }

    it "unpublishes a published project" do
      project = create(:project, :published, user: creator)
      patch unpublish_creator_project_path(project)
      reloaded = project.reload
      expect(reloaded).not_to be_published
      expect(reloaded.published_at).to be_nil
      expect(response).to redirect_to(creator_projects_path)
    end
  end

  describe "GET /creator/projects (empty state)" do
    before { sign_in creator }

    it "shows the empty state message when no projects exist" do
      get creator_projects_path
      expect(response.body).to include("You haven't created any projects yet")
    end
  end

  describe "GET /creator/projects/:id" do
    before { sign_in creator }

    it "renders the project show page" do
      project = create(:project, user: creator, title: "My Dress")
      get creator_project_path(project)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("My Dress")
    end

    it "returns 404 for another creator's project" do
      other_project = create(:project)
      get creator_project_path(other_project)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "flash messages" do
    before { sign_in creator }

    it "shows a success notice after creating a project" do
      post creator_projects_path, params: { project: { title: "New Dress" } }
      expect(flash[:notice]).to eq("Project created.")
    end

    it "shows a success notice after updating a project" do
      project = create(:project, user: creator)
      patch creator_project_path(project), params: { project: { title: "Updated" } }
      expect(flash[:notice]).to eq("Project updated.")
    end

    it "shows a success notice after deleting a project" do
      project = create(:project, user: creator)
      delete creator_project_path(project)
      expect(flash[:notice]).to eq("Project deleted.")
    end

    it "shows a success notice after publishing a project" do
      project = create(:project, user: creator, title: "My Dress")
      patch publish_creator_project_path(project)
      expect(flash[:notice]).to include("My Dress")
      expect(flash[:notice]).to include("published")
    end

    it "shows a success notice after unpublishing a project" do
      project = create(:project, :published, user: creator, title: "My Dress")
      patch unpublish_creator_project_path(project)
      expect(flash[:notice]).to include("My Dress")
      expect(flash[:notice]).to include("unpublished")
    end
  end

  describe "slug collision on create" do
    before { sign_in creator }

    it "renders the form with errors when the derived slug is already taken" do
      create(:project, title: "Summer Dress")
      post creator_projects_path, params: { project: { title: "Summer Dress" } }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("has already been taken")
    end
  end

  describe "cross-user authorization" do
    let!(:other_project) { create(:project) }

    it "audience user cannot delete a project" do
      sign_in audience
      delete creator_project_path(other_project)
      expect(response).to redirect_to(root_path)
    end

    it "creator cannot delete another creator's project" do
      sign_in creator
      expect { delete creator_project_path(other_project) }.not_to change(Project, :count)
      expect(response).to have_http_status(:not_found)
    end

    it "creator cannot publish another creator's project" do
      sign_in creator
      patch publish_creator_project_path(other_project)
      expect(response).to have_http_status(:not_found)
      expect(other_project.reload).not_to be_published
    end

    it "creator cannot unpublish another creator's project" do
      other_published = create(:project, :published)
      sign_in creator
      patch unpublish_creator_project_path(other_published)
      expect(response).to have_http_status(:not_found)
      expect(other_published.reload).to be_published
    end
  end
end
