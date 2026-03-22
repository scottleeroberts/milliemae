require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "returns success" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "is accessible without authentication" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
