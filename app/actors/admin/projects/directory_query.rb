class Admin::Projects::DirectoryQuery < ApplicationActor
  output :projects

  def call
    self.projects = Project.includes(:user).order(created_at: :desc)
  end
end
