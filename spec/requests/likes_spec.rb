require "rails_helper"

RSpec.describe "Likes", type: :request do
  let(:creator) { create(:user, :creator, email: "likes-creator@example.com", name: "Likes Creator") }
  let(:project) { create(:project, :published, user: creator, title: "Likes Request Project") }
  let(:user) { create(:user, email: "likes-user@example.com", name: "Likes User") }
  let(:turbo_headers) { turbo_stream_headers }

  describe "POST /projects/:project_id/like" do
    context "when not signed in" do
      it "redirects to sign in" do
        post project_like_path(project)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in user }

      it "creates a like" do
        expect { post project_like_path(project) }.to change(Like, :count).by(1)
      end

      it "returns a turbo-stream response" do
        post project_like_path(project), headers: turbo_headers
        expect(response.content_type).to include("text/vnd.turbo-stream.html")
      end

      it "redirects to the project page for html requests" do
        post project_like_path(project)
        expect(response).to redirect_to(project_path(project))
      end

      it "is idempotent — double liking does not error" do
        post project_like_path(project)
        expect { post project_like_path(project) }.not_to change(Like, :count)
      end

      it "returns 404 for a draft project" do
        draft = create(:project, user: creator)
        post project_like_path(draft)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /projects/:project_id/like" do
    context "when not signed in" do
      it "redirects to sign in" do
        delete project_like_path(project)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before do
        sign_in user
        create(:like, user: user, project: project)
      end

      it "removes the like" do
        expect { delete project_like_path(project) }.to change(Like, :count).by(-1)
      end

      it "returns a turbo-stream response" do
        delete project_like_path(project), headers: turbo_headers
        expect(response.content_type).to include("text/vnd.turbo-stream.html")
      end

      it "redirects to the project page for html requests" do
        delete project_like_path(project)
        expect(response).to redirect_to(project_path(project))
      end

      it "is a no-op when not liked" do
        delete project_like_path(project)
        expect { delete project_like_path(project) }.not_to change(Like, :count)
      end
    end
  end
end
