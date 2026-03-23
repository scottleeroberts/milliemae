class AddPhase5SocialLayer < ActiveRecord::Migration[8.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end
    add_index :likes, [ :user_id, :project_id ], unique: true

    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :following, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :follows, [ :follower_id, :following_id ], unique: true

    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end
  end
end
