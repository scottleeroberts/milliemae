class AddInspirationFabricToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :inspiration_description, :text
    add_column :posts, :fabric_description, :text
  end
end
