class Comments::Destroy < ApplicationActor
  input :comment_record, type: Comment
  input :current_user, type: User

  def call
    fail!(error: "Not authorized.") unless comment_record.user == current_user || current_user.admin?

    comment_record.destroy!
  end
end
