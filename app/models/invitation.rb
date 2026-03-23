class Invitation < ApplicationRecord
  EXPIRY_PERIOD = 7.days

  belongs_to :invited_by, class_name: "User"

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :email, uniqueness: {
    conditions: -> { pending },
    message: "already has a pending invitation"
  }

  scope :pending, -> { where(accepted_at: nil).where("expires_at IS NULL OR expires_at > ?", Time.current) }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :expired, -> { where(accepted_at: nil).where("expires_at <= ?", Time.current) }

  before_validation :generate_token, on: :create
  before_validation :set_expiry, on: :create

  def accepted?
    accepted_at.present?
  end

  def expired?
    !accepted? && expires_at.present? && expires_at <= Time.current
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end

  def set_expiry
    self.expires_at ||= EXPIRY_PERIOD.from_now
  end
end
