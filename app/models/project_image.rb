class ProjectImage < ApplicationRecord
  belongs_to :project
  has_one_attached :image
  has_many :product_links, dependent: :destroy

  validate :image_must_be_attached
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
end
