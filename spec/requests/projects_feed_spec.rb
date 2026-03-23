require "rails_helper"

RSpec.describe "Projects feed", type: :request do
  let!(:creator) { create(:user, :creator) }
  let!(:project_a) { create(:project, user: creator, published: true, published_at: 2.days.ago, title: "Red Dress") }
  let!(:project_b) { create(:project, user: creator, published: true, published_at: 1.day.ago, title: "Blue Skirt") }

  before do
    project_a.tag_list = "dresses"
    project_a.save!
    project_b.tag_list = "skirts"
    project_b.save!
  end

  describe "GET /projects" do
    it "shows all published projects" do
      get projects_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Red Dress", "Blue Skirt")
    end
  end

  describe "GET /projects?tag=dresses" do
    it "filters to matching projects" do
      get projects_path(tag: "dresses")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Red Dress")
      expect(response.body).not_to include("Blue Skirt")
    end

    it "shows the active filter indicator" do
      get projects_path(tag: "dresses")
      expect(response.body).to include("dresses")
      expect(response.body).to include("Clear")
    end
  end

  describe "pagination" do
    it "respects page param" do
      get projects_path(page: 1)
      expect(response).to have_http_status(:ok)
    end

    it "does not show pagination when only one page" do
      get projects_path
      expect(response.body).not_to include("Previous")
      expect(response.body).not_to include("Next →")
    end
  end
end
