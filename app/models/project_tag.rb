class ProjectTag < ApplicationRecord
  belongs_to :project
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :project_id }
end
