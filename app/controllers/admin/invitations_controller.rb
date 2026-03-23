class Admin::InvitationsController < Admin::BaseController
  def index
    @invitations = Invitation.includes(:invited_by).order(created_at: :desc)
    @new_invitation = Invitation.new
  end

  def create
    @new_invitation = Invitation.new(invitation_params.merge(invited_by: current_user))
    if @new_invitation.save
      InvitationMailer.invite(@new_invitation).deliver_later
      redirect_to admin_invitations_path, notice: "Invitation sent to #{@new_invitation.email}."
    else
      @invitations = Invitation.includes(:invited_by).order(created_at: :desc)
      render :index, status: :unprocessable_content
    end
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    redirect_to admin_invitations_path, notice: "Invitation removed."
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
