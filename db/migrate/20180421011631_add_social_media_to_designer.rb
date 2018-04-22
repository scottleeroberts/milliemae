class AddSocialMediaToDesigner < ActiveRecord::Migration[5.1]
  def change
    add_column :designers, :facebook, :string
    add_column :designers, :website, :string
    add_column :designers, :pinterest, :string
    add_column :designers, :instagram, :string
    add_column :designers, :etsy, :string
  end
end
