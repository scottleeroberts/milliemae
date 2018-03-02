class Authors::ChangePasswordsController < AuthorController

  def update
    author = current_author
    if author.valid_password?(author_password_params[:current_password])
      if author.change_password(author_password_params)
        sign_in(author, bypass: true)
        flash[:success] = 'Successfully changed password.'
      else
        flash[:danger] = author.pretty_errors
      end
    else
      flash[:danger] = 'Current password was incorrect.'
    end

    redirect_to edit_authors_account_path
  end

  private

  def author_password_params
    params.require(:author).permit(:current_password, :new_password, :new_password_confirmation)
  end
end
