require "rails_helper"

RSpec.describe "Invitations", type: :request do
  let!(:invitation) { create(:invitation, email: "creator@example.com") }

  describe "GET /invitations/:token" do
    context "with a valid pending token" do
      it "returns 200 and shows the registration form" do
        get invitation_path(invitation.token)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Create your creator account")
      end

      it "pre-populates the email" do
        get invitation_path(invitation.token)
        expect(response.body).to include("creator@example.com")
      end
    end

    context "with an invalid token" do
      it "redirects to root with alert" do
        get invitation_path("invalid-token")
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("invalid or has already been used")
      end
    end

    context "with an already-accepted token" do
      let!(:accepted) { create(:invitation, :accepted) }

      it "redirects to root" do
        get invitation_path(accepted.token)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /invitations/:token/accept" do
    let(:valid_params) do
      { user: { name: "Jane Smith", password: "password123", password_confirmation: "password123" } }
    end

    context "with valid data" do
      it "creates a user with creator role" do
        expect {
          post accept_invitation_path(invitation.token), params: valid_params
        }.to change(User, :count).by(1)

        user = User.last
        expect(user.email).to eq("creator@example.com")
        expect(user.role).to eq("creator")
      end

      it "marks the invitation as accepted" do
        post accept_invitation_path(invitation.token), params: valid_params
        expect(invitation.reload.accepted?).to be true
      end

      it "signs in the user and redirects to creator dashboard" do
        post accept_invitation_path(invitation.token), params: valid_params
        expect(response).to redirect_to(creator_projects_path)
        follow_redirect!
        expect(response.body).to include("Welcome to Sew Twirly")
      end
    end

    context "with invalid data (password too short)" do
      it "does not create a user" do
        expect {
          post accept_invitation_path(invitation.token),
               params: { user: { name: "Jane", password: "short", password_confirmation: "short" } }
        }.not_to change(User, :count)
      end

      it "re-renders the form with unprocessable_content" do
        post accept_invitation_path(invitation.token),
             params: { user: { name: "Jane", password: "short", password_confirmation: "short" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "with an already-accepted invitation" do
      let!(:accepted) { create(:invitation, :accepted) }

      it "redirects to root" do
        post accept_invitation_path(accepted.token), params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
