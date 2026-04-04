require "rails_helper"

RSpec.describe "Image variant rendering", type: :request do
  describe "project feed (index)" do
    it "renders card cover images as variant representation URLs" do
      project = create(:project, :published)
      create(:project_image, project: project, position: 0)

      get projects_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("/rails/active_storage/representations/")
    end
  end

  describe "project detail (show)" do
    it "renders hotspot images with srcset pointing to variant representation URLs" do
      project = create(:project, :published)
      image = create(:project_image, project: project, position: 0, image_width: 1200, image_height: 800)
      create(:product_link, project_image: image)

      get project_path(project)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('srcset="/rails/active_storage/representations/')
      expect(response.body).to include('width="1200"')
      expect(response.body).to include('height="800"')
    end

    it "omits width and height attributes when dimensions are nil" do
      project = create(:project, :published)
      create(:project_image, project: project, position: 0, image_width: nil, image_height: nil)

      get project_path(project)

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to match(/width=""/)
      expect(response.body).not_to match(/height=""/)
    end
  end
end
