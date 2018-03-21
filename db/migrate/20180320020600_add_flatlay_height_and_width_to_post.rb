class AddFlatlayHeightAndWidthToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :flatlay_height, :integer
    add_column :posts, :flatlay_width, :integer
  end
end
