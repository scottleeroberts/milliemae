class Admin::Dashboard::Load < ApplicationActor
  output :audience_count
  output :creator_count
  output :admin_count
  output :published_projects_count
  output :draft_projects_count
  output :pending_invitations_count
  output :recent_comments

  def call
    self.audience_count = User.audience.count
    self.creator_count = User.creator.count
    self.admin_count = User.admin.count
    self.published_projects_count = Project.published.count
    self.draft_projects_count = Project.where(published: false).count
    self.pending_invitations_count = Invitation.pending.count
    self.recent_comments = Comment.includes(:user, :project).order(created_at: :desc).limit(10)
  end
end
