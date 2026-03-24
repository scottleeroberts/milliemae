class CreatorsController < ApplicationController
  def show
    @creator = User.creator.includes(:followers).find_by!(username: params[:id])
    @projects = @creator.projects.for_feed
                        .includes(:tags, :likes, :comments, :rich_text_body,
                                  project_images: { image_attachment: :blob })
  end
end
