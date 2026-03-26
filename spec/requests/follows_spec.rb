require "rails_helper"

RSpec.describe "Follows", type: :request do
  let(:creator) { create(:user, :creator) }
  let(:audience_user) { create(:user, username: "audience-user") }
  let(:user) { create(:user) }
  let(:turbo_headers) { turbo_stream_headers }

  describe "POST /creators/:creator_id/follow" do
    context "when not signed in" do
      it "redirects to sign in" do
        post creator_follow_path(creator)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in user }

      it "creates a follow" do
        expect { post creator_follow_path(creator) }.to change(Follow, :count).by(1)
      end

      it "returns a turbo-stream response" do
        post creator_follow_path(creator), headers: turbo_headers
        expect(response.content_type).to include("text/vnd.turbo-stream.html")
      end

      it "redirects to the creator page for html requests" do
        post creator_follow_path(creator)
        expect(response).to redirect_to(creator_path(creator))
      end

      it "is idempotent — double following does not error" do
        post creator_follow_path(creator)
        expect { post creator_follow_path(creator) }.not_to change(Follow, :count)
      end

      it "returns 404 for a non-existent creator" do
        post creator_follow_path("ghost-user")
        expect(response).to have_http_status(:not_found)
      end

      it "returns 404 for a non-creator user" do
        post creator_follow_path(audience_user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "self-follow attempt" do
      before { sign_in creator }

      it "does not create a follow" do
        expect { post creator_follow_path(creator) }.not_to change(Follow, :count)
      end

      it "redirects back with an alert" do
        post creator_follow_path(creator)
        expect(response).to redirect_to(creator_path(creator))
        follow_redirect!
        expect(response.body).to include("cannot follow yourself")
      end
    end
  end

  describe "DELETE /creators/:creator_id/follow" do
    context "when not signed in" do
      it "redirects to sign in" do
        delete creator_follow_path(creator)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before do
        sign_in user
        create(:follow, follower: user, following: creator)
      end

      it "removes the follow" do
        expect { delete creator_follow_path(creator) }.to change(Follow, :count).by(-1)
      end

      it "returns a turbo-stream response" do
        delete creator_follow_path(creator), headers: turbo_headers
        expect(response.content_type).to include("text/vnd.turbo-stream.html")
      end

      it "redirects to the creator page for html requests" do
        delete creator_follow_path(creator)
        expect(response).to redirect_to(creator_path(creator))
      end

      it "is a no-op when not following" do
        delete creator_follow_path(creator)
        expect { delete creator_follow_path(creator) }.not_to change(Follow, :count)
      end

      it "returns 404 for a non-creator user" do
        delete creator_follow_path(audience_user)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
