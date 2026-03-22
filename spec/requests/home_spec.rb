require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "returns success for anonymous visitors" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "returns success for signed-in users" do
      sign_in create(:user)
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
