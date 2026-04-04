class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def create
    Likes::Create.call(project: @project, user: current_user)
    @project.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to project_path(@project) }
    end
  end

  def destroy
    Likes::Destroy.call(project: @project, user: current_user)
    @project.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to project_path(@project) }
    end
  end

  private

  def set_project
    @project = Project.published.find_by!(slug: params[:project_id])
  end
end
