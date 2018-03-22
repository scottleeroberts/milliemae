class AddCoordinatesToProductLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :product_links, :x1, :integer
    add_column :product_links, :y1, :integer
    add_column :product_links, :x2, :integer
    add_column :product_links, :y2, :integer
  end
end
