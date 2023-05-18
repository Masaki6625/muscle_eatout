class RestaurantTag < ApplicationRecord
  belongs_to :restaurant
  belongs_to :tag

  validates :restaurant_id, presence: true
  validates :tag_id, presence: true
end
