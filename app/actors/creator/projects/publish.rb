class Creator::Projects::Publish < ApplicationActor
  input :project, type: Project

  def call
    project.publish!
  end
end
