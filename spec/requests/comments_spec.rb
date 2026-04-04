require "rails_helper"

RSpec.describe "Comments", type: :request do
  let(:creator) { create(:user, :creator) }
  let(:project) { create(:project, :published, user: creator, title: "Commented Project") }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:turbo_headers) { turbo_stream_headers }

  describe "POST /projects/:project_id/comments" do
    context "when not signed in" do
      it "redirects to sign in" do
        post project_comments_path(project), params: { comment: { body: "Nice!" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in user }

      it "creates a comment with valid params" do
        expect {
          post project_comments_path(project), params: { comment: { body: "Beautiful work!" } }
        }.to change(Comment, :count).by(1)
      end

      it "returns a turbo-stream response on success" do
        post project_comments_path(project), headers: turbo_headers,
             params: { comment: { body: "Great project!" } }
        expect(response.content_type).to include("text/vnd.turbo-stream.html")
      end

      it "does not create a comment with a blank body" do
        expect {
          post project_comments_path(project), params: { comment: { body: "" } }
        }.not_to change(Comment, :count)
      end

      it "returns 422 and turbo-stream on validation failure" do
        post project_comments_path(project), headers: turbo_headers,
             params: { comment: { body: "" } }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.content_type).to include("text/vnd.turbo-stream.html")
      end

      it "returns 404 for a draft project" do
        draft = create(:project, user: creator, title: "Draft Comment Project")
        post project_comments_path(draft), params: { comment: { body: "Nice!" } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /projects/:project_id/comments/:id" do
    let!(:comment) { create(:comment, user: user, project: project) }

    context "when not signed in" do
      it "redirects to sign in" do
        delete project_comment_path(project, comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "as the comment owner" do
      before { sign_in user }

      it "destroys the comment" do
        expect { delete project_comment_path(project, comment) }.to change(Comment, :count).by(-1)
      end

      it "redirects to the project page for html requests" do
        delete project_comment_path(project, comment)
        expect(response).to redirect_to(project_path(project))
      end
    end

    context "as an admin" do
      let(:admin) { create(:user, :admin) }

      before { sign_in admin }

      it "can destroy any comment" do
        expect { delete project_comment_path(project, comment) }.to change(Comment, :count).by(-1)
      end
    end

    context "as another user" do
      before { sign_in other_user }

      it "does not destroy the comment" do
        expect { delete project_comment_path(project, comment) }.not_to change(Comment, :count)
      end

      it "redirects with an alert" do
        delete project_comment_path(project, comment)
        expect(response).to redirect_to(project_path(project))
        follow_redirect!
        expect(response.body).to include("Not authorized")
      end
    end
  end
end
