class CreateProductLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :product_links do |t|
      t.integer :post_id
      t.string :description
      t.string :url
    end
  end
end
