class Tag < ApplicationRecord
  has_many :restaurant_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :restaurants, through: :restaurant_tags
  validates :name, uniqueness: true, presence: true
end
