class AddSocialLinksToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :instagram, :string
    add_column :users, :etsy, :string
    add_column :users, :pinterest, :string
    add_column :users, :website, :string
    add_column :users, :facebook, :string
  end
end
