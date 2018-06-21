class Designer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :database_authenticatable,
    :recoverable, :rememberable, :trackable, :validatable

  HTTP = "http://"

  has_many :posts

  before_validation :smart_add_url_protocol

  validates_presence_of :name, :email

  def change_password(attrs)
    update(password: attrs[:new_password], password_confirmation: attrs[:new_password_confirmation])
  end

  def gravatar_image_url
    "https://www.gravatar.com/avatar/#{gravatar_hash}"
  end

  def display_name
    return "Designer" unless name.present?
    name
  end

  private

  def smart_add_url_protocol
    [:facebook, :website, :pinterest, :instagram, :etsy].each do |social_url_attr|
      unless self.send(social_url_attr)[/\Ahttp:\/\//] || self.send(social_url_attr)[/\Ahttps:\/\//]
        self.send("#{social_url_attr}=", HTTP + self.send(social_url_attr))
      end
    end
  end

  def gravatar_hash
    Digest::MD5.hexdigest(self.email.downcase)
  end
end
