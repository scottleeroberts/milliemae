class ProductLink < ApplicationRecord
  belongs_to :post

  validates_presence_of [:url, :description]
end
