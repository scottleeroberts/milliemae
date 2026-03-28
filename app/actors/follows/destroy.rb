class Follows::Destroy < ApplicationActor
  input :follower, type: User
  input :following, type: User

  def call
    follower.follows.find_by(following: following)&.destroy!
  end
end
