class Creator::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_creator!
  before_action :set_project, only: [ :show, :edit, :update, :destroy, :publish, :unpublish ]

  def index
    actor = Creator::Projects::DashboardQuery.call(user: current_user)
    @projects = actor.projects
    @published_count = actor.published_count
    @total_likes = actor.total_likes
    @follower_count = actor.follower_count
  end

  def show; end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)

    if @project.save
      redirect_to creator_project_path(@project), notice: "Project created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to creator_project_path(@project), notice: "Project updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @project.destroy!
    redirect_to creator_projects_path, notice: "Project deleted."
  end

  def publish
    @project.publish!
    redirect_to creator_projects_path, notice: "\"#{@project.title}\" published."
  end

  def unpublish
    @project.unpublish!
    redirect_to creator_projects_path, notice: "\"#{@project.title}\" unpublished."
  end

  private

  def set_project
    @project = Creator::Projects::ProjectLoader.call(user: current_user, slug: params[:id]).project
  end

  def project_params
    params.require(:project).permit(:title, :body, :tag_list)
  end
end
