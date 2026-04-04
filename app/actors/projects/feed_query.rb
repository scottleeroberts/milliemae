class Projects::FeedQuery < ApplicationActor
  input :requested_tag, allow_nil: true
  input :requested_page, type: Integer

  output :tag
  output :page
  output :total_pages
  output :projects
  output :popular_tags

  def call
    self.tag = requested_tag.presence
    self.page = [requested_page, 1].max

    base = Project.for_feed.with_tag(self.tag)
    self.total_pages = [(base.count(:all).to_f / Project::PER_PAGE).ceil, 1].max
    self.projects = base.includes(:user, :tags, :likes, :comments, :rich_text_body,
                                  project_images: { image_attachment: :blob })
                        .limit(Project::PER_PAGE)
                        .offset((self.page - 1) * Project::PER_PAGE)
    self.popular_tags = Tag.joins(:projects)
                           .merge(Project.published)
                           .group(:id)
                           .order(Arel.sql("COUNT(DISTINCT projects.id) DESC"))
                           .limit(12)
  end
end
