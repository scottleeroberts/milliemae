class Creator::ProjectImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_creator!
  before_action :set_project

  def create
    actor = Creator::ProjectImages::Create.result(
      project: @project,
      image: params.dig(:project_image, :image)
    )
    @project_image = actor.project_image

    if actor.success?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to creator_project_path(@project), notice: "Image uploaded." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create_error, status: :unprocessable_content }
        format.html { redirect_to creator_project_path(@project), alert: "Image could not be uploaded." }
      end
    end
  end

  def destroy
    @project_image = @project.project_images.find(params[:id])
    Creator::ProjectImages::Destroy.call(project_image: @project_image)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to creator_project_path(@project), notice: "Image removed." }
    end
  end

  private

  def set_project
    @project = current_user.projects.find_by!(slug: params[:project_id])
  end
end
