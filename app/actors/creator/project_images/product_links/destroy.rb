class Creator::ProjectImages::ProductLinks::Destroy < ApplicationActor
  input :product_link, type: ProductLink

  def call
    product_link.destroy!
  end
end
