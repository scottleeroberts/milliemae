class AddPatternToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :pattern_url, :string
    add_column :posts, :pattern_name, :string
    add_column :posts, :pattern_description, :text
  end
end
