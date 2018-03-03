class Author < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :database_authenticatable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :posts

  validates_presence_of :name, :email

  def change_password(attrs)
    update(password: attrs[:new_password], password_confirmation: attrs[:new_password_confirmation])
  end

  def gravatar_image_url
    "https://www.gravatar.com/avatar/#{gravatar_hash}"
  end

  def display_name
    return "Author" unless name.present?
    name
  end

  private

  def gravatar_hash
    Digest::MD5.hexdigest(self.email.downcase)
  end
end
