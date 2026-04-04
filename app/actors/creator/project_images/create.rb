class Creator::ProjectImages::Create < ApplicationActor
  input :project, type: Project
  input :image

  output :project_image, type: ProjectImage

  def call
    self.project_image = project.project_images.new(position: project.project_images.count)
    project_image.image.attach(image) if image.present?

    fail_with_record!(project_image) unless project_image.save

    ProjectImages::DimensionAnalyzer.call(project_image: project_image)
  end
end
