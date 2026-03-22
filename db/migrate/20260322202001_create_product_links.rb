class CreateProductLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :product_links do |t|
      t.references :project_image, null: false, foreign_key: true
      t.string :label, null: false
      t.string :url, null: false
      t.float :x, null: false
      t.float :y, null: false
      t.timestamps
    end
  end
end
