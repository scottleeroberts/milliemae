class Creator::Projects::DashboardQuery < ApplicationActor
  input :user, type: User

  output :projects
  output :published_count
  output :total_likes
  output :follower_count

  def call
    self.projects = user.projects.includes(:tags).recent
    self.published_count = user.projects.published.count
    self.total_likes = user.projects.sum(:likes_count)
    self.follower_count = user.followers_count
  end
end
