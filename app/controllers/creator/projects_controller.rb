class Creator::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_creator!
  before_action :set_project, only: [ :show, :edit, :update, :destroy, :publish, :unpublish ]

  def index
    actor = Creator::Projects::Index.call(user: current_user)
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
    actor = Creator::Projects::Create.result(
      user: current_user,
      attributes: project_params.to_h.symbolize_keys
    )
    @project = actor.project

    if actor.success?
      redirect_to creator_project_path(@project), notice: "Project created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    actor = Creator::Projects::Update.result(
      project_record: @project,
      attributes: project_params.to_h.symbolize_keys
    )
    @project = actor.project

    if actor.success?
      redirect_to creator_project_path(@project), notice: "Project updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    Creator::Projects::Destroy.call(project: @project)
    redirect_to creator_projects_path, notice: "Project deleted."
  end

  def publish
    Creator::Projects::Publish.call(project: @project)
    redirect_to creator_projects_path, notice: "\"#{@project.title}\" published."
  end

  def unpublish
    Creator::Projects::Unpublish.call(project: @project)
    redirect_to creator_projects_path, notice: "\"#{@project.title}\" unpublished."
  end

  private

  def set_project
    @project = Creator::Projects::Show.call(user: current_user, slug: params[:id]).project
  end

  def project_params
    params.require(:project).permit(:title, :body, :tag_list)
  end
end
