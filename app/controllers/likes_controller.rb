class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def create
    @project.likes.find_or_create_by!(user: current_user)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to project_path(@project) }
    end
  end

  def destroy
    @project.likes.find_by(user: current_user)&.destroy
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
