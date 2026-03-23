class ProjectImage < ApplicationRecord
  ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  MAX_FILE_SIZE = 10.megabytes

  belongs_to :project
  has_one_attached :image
  has_many :product_links, dependent: :destroy

  validate :image_must_be_attached
  validate :acceptable_image
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def analyze_image_dimensions
    return unless image.attached?
    image.blob.analyze
    update_columns(
      image_width: image.blob.metadata["width"],
      image_height: image.blob.metadata["height"]
    )
  rescue => e
    Rails.logger.warn("ProjectImage#analyze_image_dimensions failed: #{e.message}")
  end

  private

  def image_must_be_attached
    errors.add(:image, :blank) unless image.attached?
  end

  def acceptable_image
    return unless image.attached?

    unless image.blob.content_type.in?(ALLOWED_CONTENT_TYPES)
      errors.add(:image, "must be a JPEG, PNG, WebP, or GIF")
    end

    if image.blob.byte_size > MAX_FILE_SIZE
      errors.add(:image, "must be less than 10 MB")
    end
  end
end
