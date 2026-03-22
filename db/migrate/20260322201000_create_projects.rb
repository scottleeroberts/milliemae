class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false
      t.boolean :published, null: false, default: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :projects, :slug, unique: true
  end
end
