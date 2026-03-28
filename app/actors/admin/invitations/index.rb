class Admin::Invitations::Index < ApplicationActor
  output :invitations
  output :new_invitation

  def call
    self.invitations = Invitation.includes(:invited_by).order(created_at: :desc)
    self.new_invitation = Invitation.new
  end
end
