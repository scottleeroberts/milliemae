class Like < ApplicationRecord
  belongs_to :user
  belongs_to :project, counter_cache: true

  validates :user_id, uniqueness: { scope: :project_id, message: "has already liked this project" }
end
