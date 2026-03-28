class Admin::Projects::Unpublish < ApplicationActor
  input :project, type: Project

  def call
    project.unpublish!
  end
end
