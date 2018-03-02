class Authors::AccountsController < AuthorController

  def edit
  end

  def update
    if current_author.update(author_info_params)
      flash[:success] = 'Successfully saved info.'
    else
      flash[:danger] = current_author.display_error_messages
    end
    redirect_to edit_authors_account_path
  end


  private

  def author_info_params
    params.require(:author).permit(:name, :email, :bio)
  end
end
