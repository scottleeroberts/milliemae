class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :lockable, :timeoutable

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
  has_many :sent_invitations, class_name: "Invitation", foreign_key: :invited_by_id,
                              dependent: :destroy, inverse_of: :invited_by

  SOCIAL_LINK_FIELDS = {
    "Instagram" => :instagram,
    "Etsy"      => :etsy,
    "Pinterest" => :pinterest,
    "Website"   => :website,
    "Facebook"  => :facebook
  }.freeze

  SOCIAL_URL_PATTERN = /\Ahttps?:\/\/[^\s]+\z/i

  validates :name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       format: { with: /\A[\w-]+\z/, message: "can only contain letters, numbers, hyphens, and underscores" }

  %i[instagram etsy pinterest website facebook].each do |field|
    validates field, format: { with: SOCIAL_URL_PATTERN, message: "must start with http:// or https://" }, allow_blank: true
  end

  before_validation :generate_username, on: :create

  def to_param
    username
  end

  def display_name
    name
  end

  def creator_access?
    creator? || admin?
  end

  def gravatar_url(size: 80)
    hash = Digest::MD5.hexdigest(email.to_s.strip.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=mp"
  end

  def liked?(project)
    likes.exists?(project: project)
  end

  def following?(user)
    follows.exists?(following: user)
  end

  def social_links
    SOCIAL_LINK_FIELDS.filter_map do |label, field|
      url = public_send(field)
      [label, url] if url.present?
    end.to_h
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
