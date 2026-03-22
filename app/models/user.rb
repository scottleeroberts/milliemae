class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum :role, { audience: 0, creator: 1, admin: 2 }

  validates :name, presence: true

  def display_name
    name.presence || "User"
  end
end
