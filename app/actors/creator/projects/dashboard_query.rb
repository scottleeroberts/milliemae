class Creator::Projects::DashboardQuery < ApplicationActor
  input :user, type: User

  output :projects
  output :published_count
  output :total_likes
  output :follower_count

  def call
    self.projects = user.projects.includes(:tags).recent
    self.published_count = projects.count(&:published?)
    self.total_likes = Like.joins(:project).where(projects: { user_id: user.id }).count
    self.follower_count = user.followers.count
  end
end
