class Admin::Users::ChangeRole < ApplicationActor
  SELF_ROLE_CHANGE = :self_role_change
  INVALID_ROLE = :invalid_role

  input :current_user, type: User
  input :target_user, type: User
  input :role, type: String

  output :user, type: User
  output :failure_reason

  def call
    self.user = target_user
    fail!(error: "Cannot change your own role.", failure_reason: SELF_ROLE_CHANGE) if target_user == current_user

    target_user.role = role
    fail_with_record!(target_user) unless target_user.save
  rescue ArgumentError
    fail!(error: "Invalid role.", failure_reason: INVALID_ROLE)
  end
end
