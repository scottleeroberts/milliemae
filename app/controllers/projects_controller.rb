class ProjectsController < ApplicationController
  def index
    @tag = params[:tag].presence
    @page = [params[:page].to_i, 1].max
    base = Project.for_feed.with_tag(@tag)
    @total_pages = [(base.count(:all).to_f / Project::PER_PAGE).ceil, 1].max
    @projects = base
                  .includes(:user, :tags, :likes, :comments, :rich_text_body,
                            project_images: { image_attachment: :blob })
                  .limit(Project::PER_PAGE)
                  .offset((@page - 1) * Project::PER_PAGE)
    @popular_tags = Tag.joins(:project_tags).group(:id).order(Arel.sql("count(*) DESC")).limit(12)
  end

  def show
    @project = Project.published
                      .includes(:user, :tags, :likes,
                                project_images: [:product_links, { image_attachment: :blob }])
                      .find_by!(slug: params[:id])
  end
end
