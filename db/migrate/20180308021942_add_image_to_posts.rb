class AddImageToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :flatlay_image, :string
    add_column :posts, :showcase_image, :string
  end
end
