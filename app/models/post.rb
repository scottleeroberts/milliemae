class Post < ApplicationRecord
  extend FriendlyId

  acts_as_taggable

  friendly_id :title, use: :slugged

  belongs_to :author

  scope :most_recent, -> { order(published_at: :desc) }
  scope :published, -> { where(published: true) }

  def should_generate_new_friendly_id?
    title_changed?
  end

  def published_date
    if published_at.present?
      "Published: #{published_at.strftime('%-b %-d, %-Y')}"
    else
      "Not published yet"
    end
  end

  def publish
    update(published: true, published_at: Time.zone.now)
  end

  def unpublish
    update(published: false, published_at: nil)
  end
end

