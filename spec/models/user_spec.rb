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

    it "requires a password of at least 8 characters" do
      user.password = "short1"
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end
  end

  describe "roles" do
    it "defaults to audience role" do
      expect(User.new).to be_audience
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

    it "destroys associated sent_invitations when the user is destroyed" do
      admin = create(:user, :admin)
      create_list(:invitation, 2, invited_by: admin)
      expect { admin.destroy }.to change(Invitation, :count).by(-2)
    end

    it "destroys associated comments when the user is destroyed" do
      user = create(:user)
      create_list(:comment, 2, user: user)
      expect { user.destroy }.to change(Comment, :count).by(-2)
    end

    it "destroys associated likes when the user is destroyed" do
      user = create(:user)
      project = create(:project, :published)
      create(:like, user: user, project: project)
      expect { user.destroy }.to change(Like, :count).by(-1)
    end

    it "destroys associated follows when the user is destroyed" do
      follower = create(:user)
      creator = create(:user, :creator)
      create(:follow, follower: follower, following: creator)
      expect { follower.destroy }.to change(Follow, :count).by(-1)
    end
  end

  describe "social link columns" do
    it "persists instagram, etsy, pinterest, website, facebook" do
      user = create(:user, :creator,
                    instagram: "https://instagram.com/creator",
                    etsy: "https://etsy.com/shop/maker",
                    pinterest: "https://pinterest.com/creator",
                    website: "https://maker.com",
                    facebook: "https://facebook.com/creator")

      user.reload
      expect(user.instagram).to eq("https://instagram.com/creator")
      expect(user.etsy).to eq("https://etsy.com/shop/maker")
      expect(user.pinterest).to eq("https://pinterest.com/creator")
      expect(user.website).to eq("https://maker.com")
      expect(user.facebook).to eq("https://facebook.com/creator")
    end

    it "allows all social links to be nil" do
      user = build(:user, :creator)
      expect(user.instagram).to be_nil
      expect(user.etsy).to be_nil
    end
  end

  describe "social link URL validation" do
    it "rejects javascript: URLs" do
      user = build(:user, :creator, website: "javascript:alert(1)")
      expect(user).not_to be_valid
      expect(user.errors[:website]).to include("must start with http:// or https://")
    end

    it "rejects data: URLs" do
      user = build(:user, :creator, instagram: "data:text/html,<script>alert(1)</script>")
      expect(user).not_to be_valid
    end

    it "accepts valid https URLs" do
      user = build(:user, :creator, website: "https://example.com")
      expect(user).to be_valid
    end

    it "allows blank social links" do
      user = build(:user, :creator, website: "", instagram: nil)
      expect(user).to be_valid
    end
  end

  describe "#social_links" do
    it "returns only populated social fields" do
      user = build(:user, instagram: "https://instagram.com/sewer",
                           etsy: nil, pinterest: nil, website: nil, facebook: nil)
      expect(user.social_links).to eq({ "Instagram" => "https://instagram.com/sewer" })
    end

    it "returns an empty hash when no social fields are set" do
      user = build(:user, instagram: nil, etsy: nil, pinterest: nil, website: nil, facebook: nil)
      expect(user.social_links).to be_empty
    end

    it "returns all five links in SOCIAL_LINK_FIELDS order" do
      user = build(:user,
        instagram: "https://ig.com/a",
        etsy: "https://etsy.com/shop/a",
        pinterest: "https://pinterest.com/a",
        website: "https://example.com",
        facebook: "https://fb.com/a"
      )
      expect(user.social_links.keys).to eq(%w[Instagram Etsy Pinterest Website Facebook])
    end
  end

  describe "#gravatar_url" do
    it "returns a gravatar URL based on email" do
      user = build(:user, :creator, email: "test@example.com")
      expected_hash = Digest::MD5.hexdigest("test@example.com")
      expect(user.gravatar_url).to include(expected_hash)
      expect(user.gravatar_url).to include("gravatar.com/avatar")
    end

    it "accepts a custom size" do
      user = build(:user, :creator, email: "test@example.com")
      expect(user.gravatar_url(size: 200)).to include("s=200")
    end
  end
end
