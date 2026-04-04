module ApplicationHelper
  def published_date(project)
    return "Not published yet" unless project.published_at

    "Twirled on #{project.published_at.strftime('%-b %-d, %-Y')}"
  end
end
