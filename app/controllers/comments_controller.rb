class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def create
    @comment = @project.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to project_path(@project) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :new, status: :unprocessable_content }
        format.html { redirect_to project_path(@project), alert: @comment.errors.full_messages.first }
      end
    end
  end

  def destroy
    @comment = @project.comments.find(params[:id])
    unless @comment.user == current_user || current_user.admin?
      return redirect_to project_path(@project), alert: "Not authorized."
    end

    @comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to project_path(@project) }
    end
  end

  private

  def set_project
    @project = Project.published.find_by!(slug: params[:project_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
