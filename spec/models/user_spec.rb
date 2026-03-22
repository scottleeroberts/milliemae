require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "requires a name" do
      user = build(:user, name: "")
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "requires an email" do
      user = build(:user, email: "")
      expect(user).not_to be_valid
    end

    it "requires a unique email" do
      create(:user, email: "taken@example.com")
      user = build(:user, email: "taken@example.com")
      expect(user).not_to be_valid
    end

    it "requires a password of at least 6 characters" do
      user = build(:user, password: "short")
      expect(user).not_to be_valid
    end
  end

  describe "roles" do
    it "defaults to audience role" do
      user = User.new
      expect(user.audience?).to be true
    end

    it "can be a creator" do
      user = build(:user, :creator)
      expect(user.creator?).to be true
    end

    it "can be an admin" do
      user = build(:user, :admin)
      expect(user.admin?).to be true
    end
  end

  describe "#display_name" do
    it "returns the name when present" do
      user = build(:user, name: "Jane Doe")
      expect(user.display_name).to eq("Jane Doe")
    end

    it "returns 'User' when name is blank" do
      user = build(:user, name: "")
      allow(user).to receive(:name).and_return("")
      expect(user.display_name).to eq("User")
    end
  end
end
