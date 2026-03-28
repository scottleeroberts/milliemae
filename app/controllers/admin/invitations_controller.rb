class Admin::InvitationsController < Admin::BaseController
  def index
    actor = Admin::Invitations::Index.call
    @invitations = actor.invitations
    @new_invitation = actor.new_invitation
  end

  def create
    actor = Admin::Invitations::Create.result(
      invited_by: current_user,
      attributes: invitation_params.to_h.symbolize_keys
    )
    @new_invitation = actor.invitation

    if actor.success?
      redirect_to admin_invitations_path, notice: "Invitation sent to #{@new_invitation.email}."
    else
      index_actor = Admin::Invitations::Index.call
      @invitations = index_actor.invitations
      render :index, status: :unprocessable_content
    end
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    Admin::Invitations::Destroy.call(invitation: @invitation)
    redirect_to admin_invitations_path, notice: "Invitation removed."
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
