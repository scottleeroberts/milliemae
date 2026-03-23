require "rails_helper"

RSpec.describe User, type: :model do
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
      user = create(:user, :creator)
      expect(user.instagram).to be_nil
      expect(user.etsy).to be_nil
    end
  end

  describe "#gravatar_url" do
    it "returns a gravatar URL based on email" do
      user = create(:user, :creator, email: "test@example.com")
      expected_hash = Digest::MD5.hexdigest("test@example.com")
      expect(user.gravatar_url).to include(expected_hash)
      expect(user.gravatar_url).to include("gravatar.com/avatar")
    end

    it "accepts a custom size" do
      user = create(:user, :creator, email: "test@example.com")
      expect(user.gravatar_url(size: 200)).to include("s=200")
    end
  end
end
