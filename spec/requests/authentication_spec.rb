require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "registration" do
    let(:valid_params) do
      { user: { name: "New User", email: "new@example.com", password: "password123", password_confirmation: "password123" } }
    end

    it "creates an audience user and redirects" do
      expect { post user_registration_path, params: valid_params }.to change(User, :count).by(1)

      user = User.last
      expect(user.email).to eq("new@example.com")
      expect(user).to be_audience
      expect(response).to redirect_to(root_path)
    end

    it "rejects registration without a name" do
      params = { user: { name: "", email: "new@example.com", password: "password123", password_confirmation: "password123" } }
      expect { post user_registration_path, params: params }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "rejects registration with mismatched passwords" do
      params = { user: { name: "New User", email: "new@example.com", password: "password123", password_confirmation: "different" } }
      expect { post user_registration_path, params: params }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "rejects registration with a duplicate email" do
      create(:user, email: "taken@example.com")
      params = { user: { name: "New User", email: "taken@example.com", password: "password123", password_confirmation: "password123" } }
      expect { post user_registration_path, params: params }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "sign in" do
    let!(:user) { create(:user, email: "test@example.com", password: "password123") }

    it "redirects to root on valid credentials" do
      post user_session_path, params: { user: { email: "test@example.com", password: "password123" } }
      expect(response).to redirect_to(root_path)
    end

    it "returns unprocessable on invalid credentials" do
      post user_session_path, params: { user: { email: "test@example.com", password: "wrongpassword" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "account update" do
    let!(:user) { create(:user, name: "Old Name", email: "user@example.com", password: "password123") }

    it "updates the user's name" do
      sign_in user
      put user_registration_path, params: {
        user: { name: "New Name", current_password: "password123" }
      }
      expect(user.reload.name).to eq("New Name")
    end

    it "rejects update with wrong current password" do
      sign_in user
      put user_registration_path, params: {
        user: { name: "New Name", current_password: "wrongpassword" }
      }
      expect(user.reload.name).to eq("Old Name")
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "sign out" do
    it "redirects to root when signed in" do
      sign_in create(:user)
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end

    it "redirects to root when not signed in" do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end
