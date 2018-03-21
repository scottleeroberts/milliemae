class RemovePostBannerImage < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :banner_image_url
  end
end
