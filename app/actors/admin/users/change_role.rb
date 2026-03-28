class Admin::Users::ChangeRole < ApplicationActor
  input :current_user, type: User
  input :target_user, type: User
  input :role, type: String

  output :user, type: User

  def call
    self.user = target_user
    fail!(error: "Cannot change your own role.") if target_user == current_user

    target_user.role = role
    fail_with_record!(target_user) unless target_user.save
  rescue ArgumentError
    fail!(error: "Invalid role.")
  end
end
