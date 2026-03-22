class AddPhase4PublicPages < ActiveRecord::Migration[8.1]
  # Isolated migration model — insulated from future model changes.
  class MigrationUser < ApplicationRecord
    self.table_name = "users"
  end

  def change
    # Users: add username for public creator profile URLs (/creators/:username)
    add_column :users, :username, :string

    reversible do |dir|
      dir.up do
        add_index :users, :username, unique: true

        MigrationUser.find_each do |user|
          base = user.name.parameterize.presence || "user-#{user.id}"
          username = base
          counter = 2
          while MigrationUser.exists?(username: username)
            username = "#{base}-#{counter}"
            counter += 1
          end
          MigrationUser.where(id: user.id).update_all(username: username)
        end

        change_column_null :users, :username, false
      end

      dir.down do
        remove_index :users, :username
      end
    end

    # Projects: composite index for public feed ORDER BY published_at, created_at
    add_index :projects, [ :published_at, :created_at ],
              name: "index_projects_on_published_at_and_created_at"
  end
end
