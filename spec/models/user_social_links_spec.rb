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
end
