class ProjectsController < ApplicationController
  def index
    @projects = Project.for_feed
                       .includes(:user, :tags, project_images: { image_attachment: :blob })
  end

  def show
    @project = Project.published
                      .includes(:user, :tags, :likes,
                                project_images: [:product_links, { image_attachment: :blob }])
                      .find_by!(slug: params[:id])
  end
end
