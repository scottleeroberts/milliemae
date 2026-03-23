class AddExpiresAtToInvitations < ActiveRecord::Migration[8.1]
  def change
    add_column :invitations, :expires_at, :datetime
  end
end
