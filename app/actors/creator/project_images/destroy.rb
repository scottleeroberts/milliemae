class Creator::ProjectImages::Destroy < ApplicationActor
  input :project_image, type: ProjectImage

  def call
    project_image.destroy!
  end
end
