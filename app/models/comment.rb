class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :body, presence: true, length: { maximum: 2000 }
end
