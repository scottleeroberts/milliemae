require "rails_helper"

RSpec.describe Invitations::Accept do
  let(:invitation) { create(:invitation, email: "invite-creator@example.com") }

  it "creates a creator account and accepts the invitation" do
    result = described_class.call(
      invitation: invitation,
      attributes: { name: "Jane Smith", password: "password123", password_confirmation: "password123" }
    )

    expect(result.user).to be_persisted
    expect(result.user.role).to eq("creator")
    expect(invitation.reload).to be_accepted
  end

  it "fails without accepting the invitation when the user is invalid" do
    result = described_class.result(
      invitation: invitation,
      attributes: { name: "Jane", password: "short", password_confirmation: "short" }
    )

    expect(result).to be_failure
    expect(invitation.reload).not_to be_accepted
  end
end
