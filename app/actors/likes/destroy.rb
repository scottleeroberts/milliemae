class Likes::Destroy < ApplicationActor
  input :project, type: Project
  input :user, type: User

  def call
    project.likes.find_by(user: user)&.destroy!
  end
end
