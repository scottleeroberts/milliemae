class Admin::DashboardController < Admin::BaseController
  def index
    @audience_count = User.audience.count
    @creator_count = User.creator.count
    @admin_count = User.admin.count
    @published_projects_count = Project.published.count
    @draft_projects_count = Project.where(published: false).count
    @pending_invitations_count = Invitation.pending.count
    @recent_comments = Comment.includes(:user, :project).order(created_at: :desc).limit(10)
  end
end
