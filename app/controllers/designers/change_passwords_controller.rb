class Designers::ChangePasswordsController < DesignerController

  def update
    designer = current_designer
    if designer.valid_password?(designer_password_params[:current_password])
      if designer.change_password(designer_password_params)
        sign_in(designer, bypass: true)
        flash[:success] = 'Successfully changed password.'
      else
        flash[:danger] = designer.pretty_errors
      end
    else
      flash[:danger] = 'Current password was incorrect.'
    end

    redirect_to edit_designers_account_path
  end

  private

  def designer_password_params
    params.require(:designer).permit(:current_password, :new_password, :new_password_confirmation)
  end
end
