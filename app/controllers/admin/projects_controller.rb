class Admin::ProjectsController < Admin::BaseController
  before_action :set_project, only: [:destroy, :unpublish]

  def index
    @projects = Admin::Projects::DirectoryQuery.call.projects
  end

  def destroy
    Admin::Projects::Destroy.call(project: @project)
    redirect_to admin_projects_path, notice: "Project deleted."
  end

  def unpublish
    Admin::Projects::Unpublish.call(project: @project)
    redirect_to admin_projects_path, notice: "\"#{@project.title}\" unpublished."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
