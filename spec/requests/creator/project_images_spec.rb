require "rails_helper"

RSpec.describe "Creator::ProjectImages", type: :request do
  let(:creator) { create(:user, :creator) }
  let(:project) { create(:project, user: creator) }
  let(:image_file) { fixture_file_upload(Rails.root.join("spec/fixtures/files/test_image.png"), "image/png") }

  describe "authentication and authorization" do
    it "redirects unauthenticated users" do
      post creator_project_project_images_path(project), params: { project_image: { image: image_file } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects audience users" do
      sign_in create(:user)
      post creator_project_project_images_path(project), params: { project_image: { image: image_file } }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST /creator/projects/:project_id/project_images" do
    before { sign_in creator }

    it "creates a project image and responds" do
      expect {
        post creator_project_project_images_path(project),
          params: { project_image: { image: image_file } },
          headers: { "Accept" => "text/html" }
      }.to change(ProjectImage, :count).by(1)
    end

    it "attaches the image to the project" do
      post creator_project_project_images_path(project),
        params: { project_image: { image: image_file } },
        headers: { "Accept" => "text/html" }
      expect(project.project_images.reload.last.image).to be_attached
    end

    it "returns 404 when project does not belong to current creator" do
      other_project = create(:project)
      post creator_project_project_images_path(other_project),
        params: { project_image: { image: image_file } }
      expect(response).to have_http_status(:not_found)
    end

    it "rejects upload with no file" do
      post creator_project_project_images_path(project),
        params: { project_image: { image: nil } },
        headers: { "Accept" => "text/html" }
      expect(response).to redirect_to(creator_project_path(project))
    end

    it "responds with turbo_stream on successful upload" do
      post creator_project_project_images_path(project),
        params: { project_image: { image: image_file } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/vnd.turbo-stream.html")
    end

    it "responds with turbo_stream error on failed upload" do
      post creator_project_project_images_path(project),
        params: { project_image: { image: nil } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.content_type).to include("text/vnd.turbo-stream.html")
    end
  end

  describe "DELETE /creator/projects/:project_id/project_images/:id" do
    before { sign_in creator }

    it "destroys the project image" do
      project_image = create(:project_image, project: project)
      expect {
        delete creator_project_project_image_path(project, project_image),
          headers: { "Accept" => "text/html" }
      }.to change(ProjectImage, :count).by(-1)
    end

    it "returns 404 when project image does not belong to creator" do
      other_project_image = create(:project_image)
      delete creator_project_project_image_path(other_project_image.project, other_project_image),
        headers: { "Accept" => "text/html" }
      expect(response).to have_http_status(:not_found)
    end
  end
end
