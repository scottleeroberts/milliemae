require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /about" do
    it "returns 200" do
      get about_path
      expect(response).to have_http_status(:ok)
    end

    it "renders about content" do
      get about_path
      expect(response.body).to include("About Sew Twirly")
    end
  end

  describe "GET /privacy" do
    it "returns 200" do
      get privacy_path
      expect(response).to have_http_status(:ok)
    end

    it "renders privacy policy content" do
      get privacy_path
      expect(response.body).to include("Privacy Policy")
    end
  end
end
