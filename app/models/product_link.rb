class ProductLink < ApplicationRecord
  belongs_to :project_image

  URL_PATTERN = /\Ahttps?:\/\/[^\s]+\.[^\s]{2,}/i

  validates :label, presence: true
  validates :url, presence: true, format: { with: URL_PATTERN, message: "must start with http:// or https://" }
  validates :x, presence: true, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0 }
  validates :y, presence: true, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0 }
end
