class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def create
    actor = Comments::Create.result(
      project: @project,
      user: current_user,
      attributes: comment_params.to_h.symbolize_keys
    )
    @comment = actor.comment

    if actor.success?
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
    actor = Comments::Destroy.result(comment_record: @comment, current_user: current_user)
    return redirect_to project_path(@project), alert: actor.error if actor.failure?

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
