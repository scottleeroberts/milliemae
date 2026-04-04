class Creator::ProjectImages::ProductLinksController < ApplicationController
  include Creator::ProjectResourceLoader

  before_action :authenticate_user!
  before_action :require_creator!
  before_action :set_creator_project
  before_action :set_creator_project_image
  before_action :set_creator_product_link, only: [:update, :destroy]

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
    Creator::ProjectImages::ProductLinks::Destroy.call(product_link: @product_link)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to creator_project_path(@project), notice: "Hotspot removed." }
    end
  end

  private

  def product_link_params
    params.require(:product_link).permit(:label, :url, :x, :y)
  end
end
