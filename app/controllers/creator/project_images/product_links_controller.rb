class Creator::ProjectImages::ProductLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_creator!
  before_action :set_project
  before_action :set_project_image

  def create
    actor = Creator::ProjectImages::ProductLinks::Create.result(
      project_image: @project_image,
      attributes: product_link_params.to_h.symbolize_keys
    )
    @product_link = actor.product_link

    if actor.success?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to creator_project_path(@project), notice: "Hotspot added." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create_error, status: :unprocessable_content }
        format.html { redirect_to creator_project_path(@project), alert: "Could not save hotspot." }
      end
    end
  end

  def update
    @product_link = @project_image.product_links.find(params[:id])
    actor = Creator::ProjectImages::ProductLinks::Update.result(
      link: @product_link,
      attributes: product_link_params.to_h.symbolize_keys
    )
    @product_link = actor.product_link

    if actor.success?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to creator_project_path(@project), notice: "Hotspot updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :update_error, status: :unprocessable_content }
        format.html { redirect_to creator_project_path(@project), alert: "Could not update hotspot." }
      end
    end
  end

  def destroy
    @product_link = @project_image.product_links.find(params[:id])
    Creator::ProjectImages::ProductLinks::Destroy.call(product_link: @product_link)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to creator_project_path(@project), notice: "Hotspot removed." }
    end
  end

  private

  def set_project
    @project = current_user.projects.find_by!(slug: params[:project_id])
  end

  def set_project_image
    @project_image = @project.project_images.find(params[:project_image_id])
  end

  def product_link_params
    params.require(:product_link).permit(:label, :url, :x, :y)
  end
end
