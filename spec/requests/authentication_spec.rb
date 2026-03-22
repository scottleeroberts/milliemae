require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "audience registration" do
    it "allows a new user to register" do
      post user_registration_path, params: {
        user: { name: "New User", email: "new@example.com", password: "password123", password_confirmation: "password123" }
      }
      expect(User.last.audience?).to be true
    end

    it "creates user with audience role by default" do
      post user_registration_path, params: {
        user: { name: "New User", email: "new@example.com", password: "password123", password_confirmation: "password123" }
      }
      expect(User.last.role).to eq("audience")
    end
  end

  describe "sign in" do
    let(:user) { create(:user, password: "password123") }

    it "allows a user to sign in" do
      post user_session_path, params: {
        user: { email: user.email, password: "password123" }
      }
      expect(response).to redirect_to(root_path)
    end

    it "rejects invalid credentials" do
      post user_session_path, params: {
        user: { email: user.email, password: "wrongpassword" }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "sign out" do
    let(:user) { create(:user) }

    it "allows a signed-in user to sign out" do
      sign_in user
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "creator sign in" do
    let(:creator) { create(:user, :creator, password: "password123") }

    it "allows a creator to sign in" do
      post user_session_path, params: {
        user: { email: creator.email, password: "password123" }
      }
      expect(response).to redirect_to(root_path)
    end
  end
end
