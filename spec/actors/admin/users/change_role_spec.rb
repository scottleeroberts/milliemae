require "rails_helper"

RSpec.describe Admin::Users::ChangeRole do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  it "updates the user's role" do
    described_class.call(current_user: admin, target_user: user, role: "creator")

    expect(user.reload.role).to eq("creator")
  end

  it "fails when the admin updates their own role" do
    result = described_class.result(current_user: admin, target_user: admin, role: "audience")

    expect(result).to be_failure
    expect(result.failure_reason).to eq(described_class::SELF_ROLE_CHANGE)
    expect(result.error).to eq("Cannot change your own role.")
  end

  it "fails with an invalid role" do
    result = described_class.result(current_user: admin, target_user: user, role: "superadmin")

    expect(result).to be_failure
    expect(result.failure_reason).to eq(described_class::INVALID_ROLE)
    expect(result.error).to eq("Invalid role.")
  end
end
