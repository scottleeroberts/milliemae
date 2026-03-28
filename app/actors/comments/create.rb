class Comments::Create < ApplicationActor
  input :project, type: Project
  input :user, type: User
  input :attributes, type: Hash

  output :comment, type: Comment

  def call
    self.comment = project.comments.build(attributes.merge(user: user))
    fail_with_record!(comment) unless comment.save
  end
end
