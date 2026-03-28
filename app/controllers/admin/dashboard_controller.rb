class Admin::DashboardController < Admin::BaseController
  def index
    actor = Admin::Dashboard::Load.call
    @audience_count = actor.audience_count
    @creator_count = actor.creator_count
    @admin_count = actor.admin_count
    @published_projects_count = actor.published_projects_count
    @draft_projects_count = actor.draft_projects_count
    @pending_invitations_count = actor.pending_invitations_count
    @recent_comments = actor.recent_comments
  end
end
