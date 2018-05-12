class RemovePatternDescriptionFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :pattern_description
  end
end
