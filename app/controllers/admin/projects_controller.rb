class Admin::ProjectsController < Admin::BaseController
  before_action :set_project, only: [:destroy, :unpublish]

  def index
    @projects = Project.includes(:user, :tags).order(created_at: :desc)
  end

  def destroy
    @project.destroy
    redirect_to admin_projects_path, notice: "Project deleted."
  end

  def unpublish
    @project.unpublish!
    redirect_to admin_projects_path, notice: "\"#{@project.title}\" unpublished."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
