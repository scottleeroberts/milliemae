class Admin::Projects::Destroy < ApplicationActor
  input :project, type: Project

  def call
    project.destroy!
  end
end
