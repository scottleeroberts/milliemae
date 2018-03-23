class AddHeightWidthToProductLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :product_links, :width, :integer
    add_column :product_links, :height, :integer
  end
end
