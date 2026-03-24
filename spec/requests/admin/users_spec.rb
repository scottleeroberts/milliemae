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
    it "prevents unauthenticated visitors" do
      patch admin_user_path(audience.id), params: { user: { role: "creator" } }
      expect(audience.reload.role).to eq("audience")
    end

    it "redirects creators" do
      sign_in create(:user, :creator)
      patch admin_user_path(audience.id), params: { user: { role: "creator" } }
      expect(response).to redirect_to(root_path)
    end

    it "rejects non-admin access" do
      sign_in audience
      patch admin_user_path(admin.id), params: { user: { role: "audience" } }
      expect(response).to redirect_to(root_path)
    end

    context "as admin" do
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

      it "prevents admin from changing own role" do
        patch admin_user_path(admin.id), params: { user: { role: "audience" } }
        expect(admin.reload.role).to eq("admin")
        expect(response).to redirect_to(admin_users_path)
        follow_redirect!
        expect(response.body).to include("Cannot change your own role")
      end

      it "redirects with alert for invalid role" do
        patch admin_user_path(audience.id), params: { user: { role: "superadmin" } }
        expect(response).to redirect_to(admin_users_path)
        follow_redirect!
        expect(response.body).to include("Invalid role")
      end
    end
  end
end
