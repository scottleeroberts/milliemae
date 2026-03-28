class Creator::ProjectImages::ProductLinks::Create < ApplicationActor
  input :project_image, type: ProjectImage
  input :attributes, type: Hash

  output :product_link, type: ProductLink

  def call
    self.product_link = project_image.product_links.new(attributes)
    fail_with_record!(product_link) unless product_link.save
  end
end
