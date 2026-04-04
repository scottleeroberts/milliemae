module Creator::ProjectResourceLoader
  extend ActiveSupport::Concern

  private

  def set_creator_project
    @project = current_user.projects.find_by!(slug: creator_project_slug)
  end

  def set_creator_project_image
    @project_image = @project.project_images.find(creator_project_image_id)
  end

  def set_creator_product_link
    @product_link = @project_image.product_links.find(params[:id])
  end

  def creator_project_slug
    params[:project_id] || params[:id]
  end

  def creator_project_image_id
    params[:project_image_id] || params[:id]
  end
end
