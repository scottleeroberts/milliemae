class ProjectImages::DimensionAnalyzer
  def self.call(project_image:)
    new(project_image: project_image).call
  end

  def initialize(project_image:)
    @project_image = project_image
  end

  def call
    return unless project_image.image.attached?

    project_image.image.blob.analyze
    project_image.update_columns(
      image_width: project_image.image.blob.metadata["width"],
      image_height: project_image.image.blob.metadata["height"]
    )
  rescue StandardError => e
    Rails.logger.warn("ProjectImages::DimensionAnalyzer failed: #{e.message}")
  end

  private

  attr_reader :project_image
end
