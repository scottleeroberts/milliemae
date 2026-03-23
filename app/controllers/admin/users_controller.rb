class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order(created_at: :desc)
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user
      return redirect_to admin_users_path, alert: "Cannot change your own role."
    end
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "#{@user.display_name}'s role updated to #{@user.role}."
    else
      @users = User.order(created_at: :desc)
      render :index, status: :unprocessable_content
    end
  rescue ArgumentError
    redirect_to admin_users_path, alert: "Invalid role."
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end
end
