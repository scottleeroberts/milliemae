class InvitationsController < ApplicationController
  before_action :set_pending_invitation, only: [:show, :accept]

  def show
    @user = User.new(email: @invitation.email)
  end

  def accept
    actor = Invitations::Accept.result(
      invitation: @invitation,
      attributes: user_params.to_h.symbolize_keys
    )
    @user = actor.user

    if actor.success?
      sign_in @user
      redirect_to creator_projects_path, notice: "Welcome to Sew Twirly! Your creator account is ready."
    else
      render :show, status: :unprocessable_content
    end
  end

  private

  def set_pending_invitation
    @invitation = Invitation.pending.find_by!(token: params[:token])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "This invitation is invalid or has already been used."
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
