class Admin::Invitations::Create < ApplicationActor
  input :invited_by, type: User
  input :attributes, type: Hash

  output :invitation, type: Invitation

  def call
    self.invitation = Invitation.new(attributes.merge(invited_by: invited_by))
    fail_with_record!(invitation) unless invitation.save

    InvitationMailer.invite(invitation).deliver_later
  end
end
