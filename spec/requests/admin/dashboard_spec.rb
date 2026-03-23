require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:audience) { create(:user) }

  describe "GET /admin" do
    context "as admin" do
      before { sign_in admin }

      it "returns 200" do
        get admin_root_path
        expect(response).to have_http_status(:ok)
      end

      it "renders user and project counts" do
        create(:user)
        create(:user, :creator)
        get admin_root_path
        expect(response.body).to include("Audience", "Creators")
      end
    end

    context "as non-admin" do
      it "redirects an audience user" do
        sign_in audience
        get admin_root_path
        expect(response).to redirect_to(root_path)
      end

      it "redirects an unauthenticated visitor" do
        get admin_root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
