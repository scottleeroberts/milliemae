class BackfillCounterCaches < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      UPDATE projects SET likes_count = (
        SELECT COUNT(*) FROM likes WHERE likes.project_id = projects.id
      )
    SQL

    execute <<~SQL
      UPDATE projects SET comments_count = (
        SELECT COUNT(*) FROM comments WHERE comments.project_id = projects.id
      )
    SQL

    execute <<~SQL
      UPDATE users SET followers_count = (
        SELECT COUNT(*) FROM follows WHERE follows.following_id = users.id
      )
    SQL
  end

  def down
    execute "UPDATE projects SET likes_count = 0, comments_count = 0"
    execute "UPDATE users SET followers_count = 0"
  end
end
