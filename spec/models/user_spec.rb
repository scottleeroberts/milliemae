require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject(:user) { build(:user) }

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "requires a name" do
      user.name = ""
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "requires an email" do
      user.email = ""
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires a valid email format" do
      user.email = "notanemail"
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it "requires a unique email" do
      create(:user, email: "taken@example.com")
      user.email = "taken@example.com"
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "requires a password of at least 6 characters" do
      user.password = "short"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end

  describe "roles" do
    it "defaults to audience role" do
      expect(User.new).to be_audience
    end

    it "can be a creator" do
      expect(build(:user, :creator)).to be_creator
    end

    it "can be an admin" do
      expect(build(:user, :admin)).to be_admin
    end

    describe "scopes" do
      let!(:audience_user) { create(:user) }
      let!(:creator_user) { create(:user, :creator) }
      let!(:admin_user) { create(:user, :admin) }

      it "scopes by audience" do
        expect(User.audience).to contain_exactly(audience_user)
      end

      it "scopes by creator" do
        expect(User.creator).to contain_exactly(creator_user)
      end

      it "scopes by admin" do
        expect(User.admin).to contain_exactly(admin_user)
      end
    end
  end

  describe "#display_name" do
    it "returns the name" do
      expect(build(:user, name: "Jane Doe").display_name).to eq("Jane Doe")
    end
  end
end
