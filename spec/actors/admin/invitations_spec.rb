require "rails_helper"

RSpec.describe "Admin invitation actors" do
  describe Admin::Invitations::Create do
    let(:admin) { create(:user, :admin) }

    it "creates an invitation and enqueues mail" do
      expect {
        described_class.call(invited_by: admin, attributes: { email: "new@example.com" })
      }.to change(Invitation, :count).by(1)
        .and have_enqueued_mail(InvitationMailer, :invite)
    end

    it "returns a failure result for invalid input" do
      result = described_class.result(invited_by: admin, attributes: { email: "invalid" })

      expect(result).to be_failure
      expect(result.invitation.errors[:email]).to be_present
    end
  end
end
