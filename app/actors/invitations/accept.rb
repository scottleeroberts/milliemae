class Invitations::Accept < ApplicationActor
  input :invitation, type: Invitation
  input :attributes, type: Hash

  output :user, type: User

  def call
    self.user = User.new(attributes.merge(email: invitation.email, role: :creator))

    ActiveRecord::Base.transaction do
      fail_with_record!(user) unless user.save
      invitation.update!(accepted_at: Time.current)
    end
  end
end
