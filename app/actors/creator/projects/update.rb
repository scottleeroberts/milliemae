class Creator::Projects::Update < ApplicationActor
  input :project_record, type: Project
  input :attributes, type: Hash

  output :project, type: Project

  def call
    self.project = project_record
    fail_with_record!(project_record) unless project_record.update(attributes)
  end
end
