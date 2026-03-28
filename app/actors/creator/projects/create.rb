class Creator::Projects::Create < ApplicationActor
  input :user, type: User
  input :attributes, type: Hash

  output :project, type: Project

  def call
    self.project = user.projects.new(attributes)
    fail_with_record!(project) unless project.save
  end
end
