class Project < ApplicationRecord
  belongs_to :user
  has_rich_text :body
  has_many :project_tags, dependent: :destroy
  has_many :tags, through: :project_tags
  has_many :project_images, -> { order(:position) }, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: { message: "has already been taken — try a slightly different title" }

  before_validation :generate_slug, on: :create

  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  scope :recent, -> { order(published_at: :desc, created_at: :desc) }
  scope :for_feed, -> { published.order(Arel.sql("published_at DESC NULLS LAST"), created_at: :desc) }
  scope :with_tag, ->(tag) { tag.present? ? joins(:tags).where(tags: { name: tag }) : all }

  PER_PAGE = 12

  def to_param
    slug
  end

  def cover_image
    project_images.first
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names_string)
    self.tags = names_string.to_s.split(",").map { |n| n.strip.downcase }.reject(&:blank?).uniq.map do |name|
      Tag.find_or_create_by!(name: name)
    end
  end

  def publish!
    update!(published: true, published_at: Time.current)
  end

  def unpublish!
    update!(published: false, published_at: nil)
  end

  def published_date
    return "Not published yet" unless published_at

    "Twirled on #{published_at.strftime('%-b %-d, %-Y')}"
  end

  private

  def generate_slug
    self.slug ||= title&.parameterize
  end
end
