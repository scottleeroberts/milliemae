class Follows::Create < ApplicationActor
  input :follower, type: User
  input :following, type: User

  output :follow, type: Follow

  def call
    fail!(error: "You cannot follow yourself.") if follower == following

    self.follow = follower.follows.find_or_initialize_by(following: following)
    fail_with_record!(follow) unless follow.persisted? || follow.save
  end
end
