class InvitationMailer < ApplicationMailer
  default from: "noreply@sewtwirly.com"

  def invite(invitation)
    @invitation = invitation
    @accept_url = invitation_url(@invitation.token)
    mail(to: @invitation.email, subject: "You're invited to join Sew Twirly as a creator!")
  end
end
