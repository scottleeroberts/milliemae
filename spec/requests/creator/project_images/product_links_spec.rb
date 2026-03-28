require "rails_helper"

RSpec.describe "Creator::ProjectImages::ProductLinks", type: :request do
  let(:creator) { create(:user, :creator) }
  let(:project) { create(:project, user: creator, title: "Product Link Project") }
  let(:project_image) { create(:project_image, project: project) }

  let(:valid_params) do
    { product_link: { label: "Simplicity 1234", url: "https://example.com/pattern", x: "0.25", y: "0.40" } }
  end

  describe "authentication" do
    it "redirects unauthenticated users" do
      post creator_project_project_image_product_links_path(project, project_image), params: valid_params
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects audience users" do
      sign_in create(:user)
      post creator_project_project_image_product_links_path(project, project_image), params: valid_params
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST /creator/projects/:project_id/project_images/:project_image_id/product_links" do
    before { sign_in creator }

    it "creates a product link" do
      expect {
        post creator_project_project_image_product_links_path(project, project_image),
          params: valid_params,
          headers: { "Accept" => "text/html" }
      }.to change(ProductLink, :count).by(1)
    end

    it "stores normalized coordinates" do
      post creator_project_project_image_product_links_path(project, project_image),
        params: valid_params,
        headers: { "Accept" => "text/html" }
      link = ProductLink.last
      expect(link.x).to be_within(0.001).of(0.25)
      expect(link.y).to be_within(0.001).of(0.40)
    end

    it "redirects with alert on invalid params (html format)" do
      post creator_project_project_image_product_links_path(project, project_image),
        params: { product_link: { label: "", url: "", x: "0.5", y: "0.5" } },
        headers: { "Accept" => "text/html" }
      expect(response).to redirect_to(creator_project_path(project))
    end

    it "renders turbo_stream error on invalid params (turbo format)" do
      post creator_project_project_image_product_links_path(project, project_image),
        params: { product_link: { label: "", url: "", x: "0.5", y: "0.5" } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.content_type).to include("text/vnd.turbo-stream.html")
      expect(response.body).to include("project_image_#{project_image.id}")
    end

    it "returns 404 when project_image does not belong to creator" do
      other_image = create(:project_image)
      post creator_project_project_image_product_links_path(other_image.project, other_image),
        params: valid_params
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /creator/projects/:project_id/project_images/:project_image_id/product_links/:id" do
    before { sign_in creator }

    it "updates a product link" do
      link = create(:product_link, project_image: project_image)
      patch creator_project_project_image_product_link_path(project, project_image, link),
        params: { product_link: { label: "Updated Label" } },
        headers: { "Accept" => "text/html" }
      expect(link.reload.label).to eq("Updated Label")
    end

    it "redirects with alert on invalid params (html format)" do
      link = create(:product_link, project_image: project_image)
      patch creator_project_project_image_product_link_path(project, project_image, link),
        params: { product_link: { label: "", url: "" } },
        headers: { "Accept" => "text/html" }
      expect(response).to redirect_to(creator_project_path(project))
    end

    it "returns 404 when product link belongs to another creator" do
      other_image = create(:project_image)
      link = create(:product_link, project_image: other_image)
      patch creator_project_project_image_product_link_path(other_image.project, other_image, link),
        params: { product_link: { label: "Hacked" } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /creator/projects/:project_id/project_images/:project_image_id/product_links/:id" do
    before { sign_in creator }

    it "destroys the product link" do
      link = create(:product_link, project_image: project_image)
      expect {
        delete creator_project_project_image_product_link_path(project, project_image, link),
          headers: { "Accept" => "text/html" }
      }.to change(ProductLink, :count).by(-1)
    end

    it "returns 404 when product link belongs to another creator" do
      other_image = create(:project_image)
      link = create(:product_link, project_image: other_image)
      delete creator_project_project_image_product_link_path(other_image.project, other_image, link)
      expect(response).to have_http_status(:not_found)
    end
  end
end
