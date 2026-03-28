class Likes::Create < ApplicationActor
  input :project, type: Project
  input :user, type: User

  output :like, type: Like

  def call
    self.like = project.likes.find_or_initialize_by(user: user)
    fail_with_record!(like) unless like.persisted? || like.save
  end
end
