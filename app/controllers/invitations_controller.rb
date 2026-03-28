class InvitationsController < ApplicationController
  def show
    @invitation = Invitation.pending.find_by!(token: params[:token])
    @user = User.new(email: @invitation.email)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "This invitation is invalid or has already been used."
  end

  def accept
    @invitation = Invitation.pending.find_by!(token: params[:token])
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
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "This invitation is invalid or has already been used."
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
