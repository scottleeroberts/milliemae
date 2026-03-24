require "rails_helper"

RSpec.describe "Creators", type: :request do
  let(:creator) { create(:user, :creator) }
  let(:audience_user) { create(:user, username: "audience-user") }
  let(:admin) { create(:user, :admin, username: "admin-user") }

  describe "GET /creators/:id" do
    it "is accessible to anonymous visitors" do
      get creator_path(creator)
      expect(response).to have_http_status(:ok)
    end

    it "is accessible to signed-in users" do
      sign_in create(:user)
      get creator_path(creator)
      expect(response).to have_http_status(:ok)
    end

    it "shows the creator's name" do
      get creator_path(creator)
      expect(response.body).to include(creator.display_name)
    end

    it "shows the creator's bio when present" do
      creator.update!(bio: "I love sewing silk blouses.")
      get creator_path(creator)
      expect(response.body).to include("I love sewing silk blouses.")
    end

    it "shows published projects" do
      create(:project, :published, user: creator, title: "My Silk Blouse")
      get creator_path(creator)
      expect(response.body).to include("My Silk Blouse")
    end

    it "does not show draft projects" do
      create(:project, user: creator, title: "Work In Progress")
      get creator_path(creator)
      expect(response.body).not_to include("Work In Progress")
    end

    it "shows empty state when the creator has no published projects" do
      get creator_path(creator)
      expect(response.body).to include("hasn't published any projects yet")
    end

    it "returns 404 for a non-existent username" do
      get creator_path("ghost-user")
      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 for an audience user" do
      get creator_path(audience_user)
      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 for an admin user" do
      get creator_path(admin)
      expect(response).to have_http_status(:not_found)
    end
  end
end
