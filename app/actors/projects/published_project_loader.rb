class Projects::PublishedProjectLoader < ApplicationActor
  input :slug, type: String

  output :project

  def call
    self.project = Project.published
                          .includes(:user, :tags, :likes,
                                    project_images: [:product_links, { image_attachment: :blob }])
                          .find_by!(slug: slug)
  end
end
