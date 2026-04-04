class Admin::Projects::DirectoryQuery < ApplicationActor
  output :projects

  def call
    self.projects = Project.includes(:user, :tags).order(created_at: :desc)
  end
end
