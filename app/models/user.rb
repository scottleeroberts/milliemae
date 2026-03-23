class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum :role, { audience: 0, creator: 1, admin: 2 }

  has_many :projects, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_projects, through: :likes, source: :project
  has_many :follows, foreign_key: :follower_id, dependent: :destroy, inverse_of: :follower
  has_many :following, through: :follows
  has_many :follower_follows, class_name: "Follow", foreign_key: :following_id,
                              dependent: :destroy, inverse_of: :following
  has_many :followers, through: :follower_follows, source: :follower
  has_many :comments, dependent: :destroy

  validates :name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       format: { with: /\A[\w-]+\z/, message: "can only contain letters, numbers, hyphens, and underscores" }

  before_validation :generate_username, on: :create

  def to_param
    username
  end

  def display_name
    name
  end

  def liked?(project)
    likes.exists?(project: project)
  end

  def following?(user)
    follows.exists?(following: user)
  end

  private

  def generate_username
    return if username.present?

    base = name.to_s.parameterize.presence || "user"
    candidate = base
    counter = 2
    while User.exists?(username: candidate)
      candidate = "#{base}-#{counter}"
      counter += 1
    end
    self.username = candidate
  end
end
