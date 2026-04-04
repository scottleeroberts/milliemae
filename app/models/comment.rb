class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :project, counter_cache: true

  validates :body, presence: true, length: { maximum: 2000 }

  def destroyable_by?(user)
    user.present? && (self.user == user || user.admin?)
  end
end
