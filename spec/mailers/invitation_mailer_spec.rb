require "rails_helper"

RSpec.describe InvitationMailer, type: :mailer do
  let(:invitation) { create(:invitation, email: "creator@example.com") }

  describe "#invite" do
    subject(:mail) { InvitationMailer.invite(invitation) }

    it "sends to the invitee's email" do
      expect(mail.to).to eq(["creator@example.com"])
    end

    it "sends from the Sew Twirly address" do
      expect(mail.from).to eq(["noreply@sewtwirly.com"])
    end

    it "has the correct subject" do
      expect(mail.subject).to include("Sew Twirly")
      expect(mail.subject).to include("creator")
    end

    it "includes the invitation acceptance link in the HTML body" do
      expect(mail.html_part.body.to_s).to include(invitation.token)
    end

    it "includes the invitation acceptance link in the text body" do
      expect(mail.text_part.body.to_s).to include(invitation.token)
    end
  end
end
