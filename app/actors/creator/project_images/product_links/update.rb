class Creator::ProjectImages::ProductLinks::Update < ApplicationActor
  input :link, type: ProductLink
  input :attributes, type: Hash

  output :product_link, type: ProductLink

  def call
    self.product_link = link
    fail_with_record!(link) unless link.update(attributes)
  end
end
