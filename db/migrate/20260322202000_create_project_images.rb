class CreateProjectImages < ActiveRecord::Migration[8.1]
  def change
    create_table :project_images do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :position, null: false, default: 0
      t.integer :image_width
      t.integer :image_height
      t.timestamps
    end
    add_index :project_images, [:project_id, :position]
  end
end
