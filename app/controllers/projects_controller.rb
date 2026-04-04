class ProjectsController < ApplicationController
  def index
    actor = Projects::FeedQuery.call(requested_tag: params[:tag], requested_page: params[:page].to_i)
    @tag = actor.tag
    @page = actor.page
    @total_pages = actor.total_pages
    @projects = actor.projects
    @popular_tags = actor.popular_tags
  end

  def show
    @project = Projects::PublishedProjectLoader.call(slug: params[:id]).project
  end
end
