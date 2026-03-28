class Admin::UsersController < Admin::BaseController
  def index
    @users = Admin::Users::Index.call.users
  end

  def update
    @user = User.find(params[:id])
    actor = Admin::Users::ChangeRole.result(
      current_user: current_user,
      target_user: @user,
      role: user_params[:role]
    )
    @user = actor.user

    if actor.success?
      redirect_to admin_users_path, notice: "#{@user.display_name}'s role updated to #{@user.role}."
    elsif actor.error == "Cannot change your own role." || actor.error == "Invalid role."
      redirect_to admin_users_path, alert: actor.error
    else
      @users = Admin::Users::Index.call.users
      render :index, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end
end
