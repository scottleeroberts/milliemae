require "rails_helper"

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:audience) { create(:user) }

  describe "GET /admin/users" do
    it "returns 200 for admin" do
      sign_in admin
      get admin_users_path
      expect(response).to have_http_status(:ok)
    end

    it "redirects non-admin" do
      sign_in audience
      get admin_users_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH /admin/users/:id" do
    before { sign_in admin }

    it "updates the user's role" do
      patch admin_user_path(audience.id), params: { user: { role: "creator" } }
      expect(audience.reload.role).to eq("creator")
    end

    it "redirects with notice" do
      patch admin_user_path(audience.id), params: { user: { role: "creator" } }
      expect(response).to redirect_to(admin_users_path)
      follow_redirect!
      expect(response.body).to include("role updated")
    end

    it "rejects non-admin access" do
      sign_in audience
      patch admin_user_path(admin.id), params: { user: { role: "audience" } }
      expect(response).to redirect_to(root_path)
    end
  end
end
