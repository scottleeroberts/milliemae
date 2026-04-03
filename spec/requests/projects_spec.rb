require "rails_helper"

RSpec.describe "Projects", type: :request do
  let(:creator) { create(:user, :creator) }

  describe "GET /projects (feed)" do
    it "is accessible to anonymous visitors" do
      get projects_path
      expect(response).to have_http_status(:ok)
    end

    it "is accessible to signed-in users" do
      sign_in create(:user)
      get projects_path
      expect(response).to have_http_status(:ok)
    end

    it "shows published projects" do
      create(:project, :published, user: creator, title: "My Summer Dress")
      get projects_path
      expect(response.body).to include("My Summer Dress")
    end

    it "does not show draft projects" do
      create(:project, user: creator, title: "Secret Draft")
      get projects_path
      expect(response.body).not_to include("Secret Draft")
    end

    it "shows creator name for each project" do
      create(:project, :published, user: creator)
      get projects_path
      expect(response.body).to include(creator.display_name)
    end

    it "shows project tags" do
      project = create(:project, :published, user: creator)
      project.tag_list = "cotton, dress"
      project.save!
      get projects_path
      expect(response.body).to include("cotton")
    end

    it "orders feed with most-recently-published first" do
      older = create(:project, :published, user: creator, title: "Older Project", published_at: 3.days.ago)
      newer = create(:project, :published, user: creator, title: "Newer Project", published_at: 1.day.ago)
      get projects_path
      expect(response.body.index("Newer Project")).to be < response.body.index("Older Project")
    end

    it "shows empty state when no projects are published" do
      get projects_path
      expect(response.body).to include("No projects published yet")
    end

    it "does not show popular tags that only exist on draft projects" do
      draft_project = create(:project, user: creator, title: "Draft Tag Source")
      draft_project.tag_list = "private-tag"
      draft_project.save!

      get projects_path

      expect(response.body).not_to include("private-tag")
    end
  end

  describe "GET /projects?tag= (tag filtering)" do
    let!(:tagged_project) do
      p = create(:project, :published, user: creator, title: "Red Dress", published_at: 2.days.ago)
      p.tag_list = "dresses"
      p.save!
      p
    end
    let!(:other_project) do
      p = create(:project, :published, user: creator, title: "Blue Skirt", published_at: 1.day.ago)
      p.tag_list = "skirts"
      p.save!
      p
    end

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

  describe "GET / (root)" do
    it "renders the project feed" do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /projects/:id" do
    context "with a published project" do
      let!(:project) { create(:project, :published, user: creator, title: "My Dress") }

      it "renders the project detail page" do
        get project_path(project)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("My Dress")
      end

      it "shows the creator's name with a link to their profile" do
        get project_path(project)
        expect(response.body).to include(creator.display_name)
        expect(response.body).to include(creator_path(creator))
      end

      it "shows tags" do
        project.tag_list = "linen, blouse"
        project.save!
        get project_path(project)
        expect(response.body).to include("linen")
      end

      it "shows the back link to the feed" do
        get project_path(project)
        expect(response.body).to include(projects_path)
      end
    end

    context "with product links (hotspot shopping list)" do
      let!(:project) { create(:project, :published, user: creator, title: "My Dress") }
      let!(:project_image) { create(:project_image, project: project) }
      let!(:product_link) { create(:product_link, project_image: project_image, label: "Linen Blouse", url: "https://example.com/blouse") }

      it "renders the shopping list with product link labels" do
        get project_path(project)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Shopping List")
        expect(response.body).to include("Linen Blouse")
      end

      it "renders multiple numbered hotspot items" do
        create(:product_link, project_image: project_image, label: "Silk Skirt", url: "https://example.com/skirt")
        get project_path(project)
        expect(response.body).to include("Linen Blouse")
        expect(response.body).to include("Silk Skirt")
      end
    end

    context "with a draft project" do
      let!(:draft) { create(:project, user: creator, title: "Unpublished") }

      it "returns 404" do
        get project_path(draft)
        expect(response).to have_http_status(:not_found)
      end
    end

    it "returns 404 for a non-existent slug" do
      get project_path("does-not-exist")
      expect(response).to have_http_status(:not_found)
    end
  end
end
