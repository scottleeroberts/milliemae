class Admin::Invitations::Destroy < ApplicationActor
  input :invitation, type: Invitation

  def call
    invitation.destroy!
  end
end
