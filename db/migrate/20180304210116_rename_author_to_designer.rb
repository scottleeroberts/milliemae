class RenameAuthorToDesigner < ActiveRecord::Migration[5.1]
  def change
    rename_table :authors, :designers
    rename_column :posts, :author_id, :designer_id
  end
end
