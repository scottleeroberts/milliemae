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

    it "requires a username" do
      # Use a persisted user so the on: :create callback doesn't regenerate it.
      persisted = create(:user)
      persisted.username = ""
      expect(persisted).not_to be_valid
      expect(persisted.errors[:username]).to include("can't be blank")
    end

    it "requires a unique username" do
      create(:user, username: "taken-name")
      user.username = "taken-name"
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("has already been taken")
    end

    it "rejects usernames with special characters" do
      user.username = "bad name!"
      expect(user).not_to be_valid
      expect(user.errors[:username]).to be_present
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

  describe "username generation" do
    it "generates a username from the name on create" do
      user = create(:user, name: "Jane Doe")
      expect(user.username).to eq("jane-doe")
    end

    it "does not overwrite a username set explicitly" do
      user = create(:user, name: "Jane Doe", username: "custom-handle")
      expect(user.username).to eq("custom-handle")
    end

    it "appends a counter to avoid collisions" do
      create(:user, name: "Jane Doe")
      second = create(:user, name: "Jane Doe")
      expect(second.username).to eq("jane-doe-2")
    end

    it "does not regenerate username on update" do
      user = create(:user, name: "Jane Doe")
      original = user.username
      user.update!(name: "Jane Smith")
      expect(user.username).to eq(original)
    end
  end

  describe "#to_param" do
    it "returns the username" do
      user = build(:user, username: "jane-doe")
      expect(user.to_param).to eq("jane-doe")
    end
  end

  describe "#display_name" do
    it "returns the name" do
      expect(build(:user, name: "Jane Doe").display_name).to eq("Jane Doe")
    end
  end

  describe "associations" do
    it "destroys associated projects when the user is destroyed" do
      user = create(:user, :creator)
      create_list(:project, 2, user: user)
      expect { user.destroy }.to change(Project, :count).by(-2)
    end
  end
end
