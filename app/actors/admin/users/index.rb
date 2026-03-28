class Admin::Users::Index < ApplicationActor
  output :users

  def call
    self.users = User.order(created_at: :desc)
  end
end
