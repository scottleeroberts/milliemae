# Shared examples for creator-protected request specs.
#
# Usage — define `make_request` as a method or let before including:
#
#   describe "GET /creator/projects" do
#     def make_request = get(creator_projects_path)
#     include_examples "requires creator role"
#   end
RSpec.shared_examples "requires creator role" do
  context "when unauthenticated" do
    it "redirects to sign in" do
      make_request
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when signed in as audience" do
    it "redirects to root" do
      sign_in create(:user)
      make_request
      expect(response).to redirect_to(root_path)
    end
  end
end
