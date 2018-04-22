class Designers::AccountsController < DesignerController

  def edit
  end

  def update
    if current_designer.update(designer_info_params)
      flash[:success] = 'Successfully saved info.'
    else
      flash[:danger] = current_designer.pretty_errors
    end
    redirect_to edit_designers_account_path
  end

  private

  def designer_info_params
    params.require(:designer).permit(:name, :email, :bio, :facebook, :website, :pinterest, :instagram, :etsy)
  end
end
