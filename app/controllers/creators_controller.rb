class CreatorsController < ApplicationController
  def show
    @creator = User.includes(:followers).find_by!(username: params[:id])
    @projects = @creator.projects.for_feed
                        .includes(:tags, project_images: { image_attachment: :blob })
  end
end
