require "rails_helper"

RSpec.describe Invitation, type: :model do
  subject(:invitation) { build(:invitation) }

  describe "validations" do
    it "requires email" do
      invitation.email = nil
      expect(invitation).not_to be_valid
      expect(invitation.errors[:email]).to be_present
    end

    it "requires token uniqueness" do
      existing = create(:invitation)
      invitation.token = existing.token
      expect(invitation).not_to be_valid
      expect(invitation.errors[:token]).to be_present
    end

    it "validates email format" do
      invitation.email = "not-an-email"
      expect(invitation).not_to be_valid
      expect(invitation.errors[:email]).to be_present
    end

    it "allows a well-formed email" do
      invitation.email = "creator@example.com"
      expect(invitation).to be_valid
    end

    context "email uniqueness among pending" do
      it "rejects duplicate email when a pending invitation exists" do
        create(:invitation, email: "creator@example.com")
        duplicate = build(:invitation, email: "creator@example.com")
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:email]).to include("already has a pending invitation")
      end

      it "allows same email if previous invitation is accepted" do
        create(:invitation, :accepted, email: "creator@example.com")
        new_invite = build(:invitation, email: "creator@example.com")
        expect(new_invite).to be_valid
      end
    end
  end

  describe "associations" do
    it "belongs to invited_by (User)" do
      expect(Invitation.reflect_on_association(:invited_by).macro).to eq(:belongs_to)
    end
  end

  describe "token generation" do
    it "generates a token before create" do
      invitation = build(:invitation, token: nil)
      invitation.save!
      expect(invitation.token).to be_present
    end

    it "does not overwrite an existing token" do
      invitation = build(:invitation, token: "existing-token")
      invitation.valid?
      expect(invitation.token).to eq("existing-token")
    end
  end

  describe "scopes" do
    let!(:pending_invite) { create(:invitation) }
    let!(:accepted_invite) { create(:invitation, :accepted) }

    it ".pending returns only uninvited invitations" do
      expect(Invitation.pending).to include(pending_invite)
      expect(Invitation.pending).not_to include(accepted_invite)
    end

    it ".accepted returns only accepted invitations" do
      expect(Invitation.accepted).to include(accepted_invite)
      expect(Invitation.accepted).not_to include(pending_invite)
    end
  end

  describe "#accepted?" do
    it "returns false when accepted_at is nil" do
      expect(build(:invitation).accepted?).to be false
    end

    it "returns true when accepted_at is set" do
      expect(build(:invitation, :accepted).accepted?).to be true
    end
  end
end
