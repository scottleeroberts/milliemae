class Creator::ProjectImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_creator!
  before_action :set_project

  def create
    @project_image = @project.project_images.new(position: @project.project_images.count)
    @project_image.image.attach(params.dig(:project_image, :image))

    if @project_image.save
      @project_image.analyze_image_dimensions
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
    @project_image.destroy

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
