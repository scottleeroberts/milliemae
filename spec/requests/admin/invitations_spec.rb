require "rails_helper"

RSpec.describe "Admin::Invitations", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:audience) { create(:user) }

  describe "GET /admin/invitations" do
    it "returns 200 for admin" do
      sign_in admin
      get admin_invitations_path
      expect(response).to have_http_status(:ok)
    end

    it "redirects audience users" do
      sign_in audience
      get admin_invitations_path
      expect(response).to redirect_to(root_path)
    end

    it "redirects creators" do
      sign_in create(:user, :creator)
      get admin_invitations_path
      expect(response).to redirect_to(root_path)
    end

    it "redirects unauthenticated visitors" do
      get admin_invitations_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST /admin/invitations" do
    it "prevents unauthenticated visitors" do
      expect {
        post admin_invitations_path, params: { invitation: { email: "new@example.com" } }
      }.not_to change(Invitation, :count)
    end

    it "redirects creators" do
      sign_in create(:user, :creator)
      post admin_invitations_path, params: { invitation: { email: "new@example.com" } }
      expect(response).to redirect_to(root_path)
    end

    context "as admin" do
      before { sign_in admin }

      context "with valid email" do
        it "creates an invitation" do
          expect {
            post admin_invitations_path, params: { invitation: { email: "new@example.com" } }
          }.to change(Invitation, :count).by(1)
        end

        it "enqueues an invitation email" do
          expect {
            post admin_invitations_path, params: { invitation: { email: "new@example.com" } }
          }.to have_enqueued_mail(InvitationMailer, :invite)
        end

        it "redirects with notice" do
          post admin_invitations_path, params: { invitation: { email: "new@example.com" } }
          expect(response).to redirect_to(admin_invitations_path)
          follow_redirect!
          expect(response.body).to include("Invitation sent")
        end
      end

      context "with invalid email" do
        it "does not create an invitation" do
          expect {
            post admin_invitations_path, params: { invitation: { email: "not-an-email" } }
          }.not_to change(Invitation, :count)
        end

        it "re-renders with unprocessable_content status" do
          post admin_invitations_path, params: { invitation: { email: "not-an-email" } }
          expect(response).to have_http_status(:unprocessable_content)
        end
      end

      context "with duplicate pending email" do
        before { create(:invitation, email: "taken@example.com") }

        it "does not create a duplicate" do
          expect {
            post admin_invitations_path, params: { invitation: { email: "taken@example.com" } }
          }.not_to change(Invitation, :count)
        end

        it "does not create a duplicate with different casing" do
          expect {
            post admin_invitations_path, params: { invitation: { email: "TAKEN@example.com" } }
          }.not_to change(Invitation, :count)
        end
      end
    end
  end

  describe "DELETE /admin/invitations/:id" do
    let!(:invitation) { create(:invitation) }

    it "prevents unauthenticated visitors" do
      expect { delete admin_invitation_path(invitation) }.not_to change(Invitation, :count)
    end

    it "redirects creators" do
      sign_in create(:user, :creator)
      delete admin_invitation_path(invitation)
      expect(response).to redirect_to(root_path)
    end

    context "as admin" do
      before { sign_in admin }

      it "destroys the invitation" do
        expect {
          delete admin_invitation_path(invitation)
        }.to change(Invitation, :count).by(-1)
      end

      it "redirects with notice" do
        delete admin_invitation_path(invitation)
        expect(response).to redirect_to(admin_invitations_path)
      end
    end
  end
end
