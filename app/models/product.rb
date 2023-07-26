class Product < ApplicationRecord
  has_one_attached :image
  validates :name, presence: true
  attr_accessor :old_price
  attr_accessor :new_price
  belongs_to :category
  has_many :order_items
  # ...
end
